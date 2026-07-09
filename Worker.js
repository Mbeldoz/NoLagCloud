const rateLimits = new Map();
const RATE_LIMIT_WINDOW_MS = 60 * 1000;
const RATE_LIMIT_MAX_REQUESTS = 30;

export default {
  async fetch(request, env) {
    const userAgent = request.headers.get("User-Agent") || "";
    const isRoblox =
      userAgent.includes("Roblox") ||
      userAgent.includes("roblox") ||
      userAgent.includes("GameClient");

    if (isRoblox) {
      const clientIp =
        request.headers.get("CF-Connecting-IP") ||
        request.headers.get("X-Forwarded-For") ||
        "unknown";
      const rateLimit = checkRateLimit(clientIp);

      if (!rateLimit.allowed) {
        return new Response("Too many requests", {
          status: 429,
          headers: {
            "Content-Type": "text/plain; charset=utf-8",
            "Retry-After": String(rateLimit.retryAfter),
          },
        });
      }

      const luaUrl = new URL("/file/script.lua", request.url);
      const luaResponse = await env.ASSETS.fetch(luaUrl);

      if (!luaResponse.ok) {
        return new Response("file/script.lua not found", { status: 404 });
      }

      return new Response(luaResponse.body, {
        status: luaResponse.status,
        headers: {
          "Content-Type": "application/x-lua; charset=utf-8",
          "Cache-Control": "no-cache",
        },
      });
    }

    return env.ASSETS.fetch(request);
  },
};

function checkRateLimit(key) {
  const now = Date.now();
  const current = rateLimits.get(key);

  if (!current || now >= current.resetAt) {
    rateLimits.set(key, {
      count: 1,
      resetAt: now + RATE_LIMIT_WINDOW_MS,
    });

    return { allowed: true, retryAfter: 0 };
  }

  if (current.count >= RATE_LIMIT_MAX_REQUESTS) {
    return {
      allowed: false,
      retryAfter: Math.ceil((current.resetAt - now) / 1000),
    };
  }

  current.count += 1;
  return { allowed: true, retryAfter: 0 };
}
