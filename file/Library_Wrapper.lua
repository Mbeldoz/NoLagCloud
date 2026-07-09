-- Discontinue, Merged with HeadLockUI
local FuncsV3 = {}
local SaveConfig = nil  

local function Checker(Val, Val1, Val2)
  return typeof(Val) == Val1 and Val or Val2
end

-- Sets the table that config states will be loaded from and saved to.
function FuncsV3:SetTable(path)
  SaveConfig = path
end

-- Shortcut to create a new window
function FuncsV3:Window(Library, Title, Description, TabWidth, SizeUi)
  Title = Checker(Title, "string", "Window")
  Description = Checker(Description, "string", "")
  TabWidth = Checker(TabWidth, "number", 120)

  return Library:CreateWindow({
    Title = Title,
    Description = Description,
    ["Tab Width"] = TabWidth,
    SizeUi = SizeUi
  })
end

-- Shortcut to create a new Tab
function FuncsV3:Tab(Window, Name, Icon)
  Name = Checker(Name, "string", "Tab")
  Icon = Checker(Icon, "string", "rbxassetid://7734010488")

  return Window:CreateTab({
    Name = Name,
    Icon = Icon
  })
end

-- Section Wrapper
function FuncsV3:Section(Tab, Title, OpenSection)
  Title = Checker(Title, "string", tostring(Title))
  OpenSection = Checker(OpenSection, "boolean", false)

  return Tab:AddSection(Title, OpenSection)
end

-- Section with Header Toggle Wrapper
function FuncsV3:SectionToggle(Tab, Title, OpenSection, Default, Callback)
  Title = Checker(Title, "string", tostring(Title))
  OpenSection = Checker(OpenSection, "boolean", false)
  Callback = Checker(Callback, "function", function() end)

  local _default = (Default == "Save" and SaveConfig)
    and Checker(SaveConfig[Title], "boolean", false)
    or Checker(Default, "boolean", false)

  local function callback_wrapper(v)
    if SaveConfig then
      SaveConfig[Title] = v
    end
    Callback(v)
  end

  return Tab:AddSectionToggle(Title, OpenSection, _default, callback_wrapper)
end

-- Toggle Wrapper (updates SaveConfig if active)
function FuncsV3:Toggle(Tab, Name, Content, Default, Callback)
  Name = Checker(Name, "string", tostring(Name))
  Content = Checker(Content, "string", tostring(Content))
  Callback = Checker(Callback, "function", function() end)

  local _default = (Default == "Save" and SaveConfig)
    and Checker(SaveConfig[Name], "boolean", false)
    or Checker(Default, "boolean", false)

  local function callback_wrapper(v)
    if SaveConfig then
      SaveConfig[Name] = v
    end
    Callback(v)
  end

  return Tab:AddToggle({
    Title = Name,
    Content = Content,
    Default = _default,
    Callback = callback_wrapper
  })
end

-- Button Wrapper
function FuncsV3:Button(Tab, Name, Content, Callback)
  Name = Checker(Name, "string", tostring(Name))
  Content = Checker(Content, "string", tostring(Content))
  Callback = Checker(Callback, "function", function() end)

  return Tab:AddButton({
    Title = Name,
    Content = Content,
    Icon = "rbxassetid://7734010488",
    Callback = Callback
  })
end

-- Dual Button Wrapper
function FuncsV3:DualButton(Tab, LeftTitle, LeftContent, LeftCallback, RightTitle, RightContent, RightCallback)
  LeftTitle = Checker(LeftTitle, "string", tostring(LeftTitle))
  LeftContent = Checker(LeftContent, "string", tostring(LeftContent))
  LeftCallback = Checker(LeftCallback, "function", function() end)

  RightTitle = Checker(RightTitle, "string", tostring(RightTitle))
  RightContent = Checker(RightContent, "string", tostring(RightContent))
  RightCallback = Checker(RightCallback, "function", function() end)

  return Tab:AddDualButton({
    LeftTitle = LeftTitle,
    LeftContent = LeftContent,
    LeftCallback = LeftCallback,
    RightTitle = RightTitle,
    RightContent = RightContent,
    RightCallback = RightCallback
  })
end

-- Dropdown Wrapper (updates SaveConfig if active)
function FuncsV3:Dropdown(Tab, Name, Content, multi, options, Default, Callback)
  Name = Checker(Name, "string", tostring(Name))
  Content = Checker(Content, "string", tostring(Content))
  multi = Checker(multi, "boolean", false)
  options = Checker(options, "table", { "" })
  Callback = Checker(Callback, "function", function() end)

  local _default
  if Default == "Save" then
    if SaveConfig and type(SaveConfig[Name]) == "table" then
      _default = SaveConfig[Name] or {""}
    else
      _default = {(SaveConfig and SaveConfig[Name]) or ""}
    end
  else
    local currentVal = (SaveConfig and SaveConfig[Name]) or Default
    if type(currentVal) == "table" then
      _default = currentVal
    else
      _default = {currentVal or ""}
    end
  end

  local function callback_wrapper(v)
    if SaveConfig then
      SaveConfig[Name] = v
    end
    Callback(v)
  end

  return Tab:AddDropdown({
    Title = Name,
    Content = Content,
    Multi = multi,
    Options = options,
    Default = _default,
    Callback = callback_wrapper
  })
end

-- Custom Dropdown Wrapper (updates SaveConfig if active)
function FuncsV3:CustomDropDown(Tab, Name, Content, options, Default, Callback)
  Name = Checker(Name, "string", tostring(Name))
  Content = Checker(Content, "string", tostring(Content))
  options = Checker(options, "table", {})
  Callback = Checker(Callback, "function", function() end)

  local _default
  if Default == "Save" then
    if SaveConfig and type(SaveConfig[Name]) == "table" then
      _default = SaveConfig[Name] or {}
    else
      _default = {}
    end
  else
    _default = Checker(Default, "table", {})
  end

  local function callback_wrapper(v)
    if SaveConfig then
      SaveConfig[Name] = v
    end
    Callback(v)
  end

  return Tab:AddCustomDropDown({
    Title = Name,
    Content = Content,
    Options = options,
    Default = _default,
    Callback = callback_wrapper
  })
end

-- Textbox Wrapper (updates SaveConfig if active)
function FuncsV3:Textbox(Tab, Name, Content, Default, Callback)
  Name = Checker(Name, "string", tostring(Name))
  Content = Checker(Content, "string", tostring(Content))
  Callback = Checker(Callback, "function", function() end)

  local _default = (Default == "Save" and SaveConfig)
    and Checker(SaveConfig[Name], "string", "")
    or Checker(Default, "string", "")

  local function callback_wrapper(v)
    if SaveConfig then
      SaveConfig[Name] = v
    end
    Callback(v)
  end

  return Tab:AddInput({
    Title = Name,
    Content = Content,
    Default = _default,
    Callback = callback_wrapper
  })
end

-- Slider Wrapper (updates SaveConfig if active)
function FuncsV3:Slider(Tab, Name, Content, Min, Max, Default, Increment, Callback)
  Name = Checker(Name, "string", tostring(Name))
  Content = Checker(Content, "string", tostring(Content))
  Min = Checker(Min, "number", 0)
  Max = Checker(Max, "number", 100)
  Increment = Checker(Increment, "number", 1)
  Callback = Checker(Callback, "function", function() end)

  local _default = (Default == "Save" and SaveConfig)
    and Checker(SaveConfig[Name], "number", Min)
    or Checker(Default, "number", Min)

  local function callback_wrapper(v)
    if SaveConfig then
      SaveConfig[Name] = v
    end
    Callback(v)
  end

  return Tab:AddSlider({
    Title = Name,
    Content = Content,
    Min = Min,
    Max = Max,
    Increment = Increment,
    Default = _default,
    Callback = callback_wrapper
  })
end

-- Paragraph Wrapper
function FuncsV3:Paragraph(Tab, Name, Content)
  Name = Checker(Name, "string", tostring(Name))
  Content = Checker(Content, "string", tostring(Content))

  return Tab:AddParagraph({
    Title = Name,
    Content = Content
  })
end

-- Line Wrapper
function FuncsV3:Line(Tab)
  return Tab:AddLine()
end

-- Spacer/Labeled Separator Wrapper
function FuncsV3:Spacer(Tab, Title, Content)
  Title = Checker(Title, "string", tostring(Title))
  Content = Checker(Content, "string", tostring(Content))

  return Tab:AddSpacer({
    Title = Title,
    Content = Content
  })
end

-- Checkmark Wrapper (Tab-level checkbox, updates SaveConfig if active)
function FuncsV3:Checkmark(Tab, Text, Default, Callback)
  Text = Checker(Text, "string", tostring(Text))
  Callback = Checker(Callback, "function", function() end)

  local _default = (Default == "Save" and SaveConfig)
    and Checker(SaveConfig[Text], "boolean", false)
    or Checker(Default, "boolean", false)

  local function callback_wrapper(v)
    if SaveConfig then
      SaveConfig[Text] = v
    end
    Callback(v)
  end

  return Tab:AddCheckmark({
    Text = Text,
    Default = _default,
    Callback = callback_wrapper
  })
end

-- Seperator Wrapper
function FuncsV3:Seperator(Tab, Title)
  Title = Checker(Title, "string", tostring(Title))

  return Tab:AddSeperator(Title)
end

-- Table Wrapper
function FuncsV3:Table(Tab, Name, Content, Columns, Rows, RowHeight, MaxBodyHeight, Callback)
  Name = Checker(Name, "string", tostring(Name))
  Content = Checker(Content, "string", tostring(Content))
  Columns = Checker(Columns, "table", { { Name = "Column", Width = 1 } })
  Rows = Checker(Rows, "table", {})
  RowHeight = Checker(RowHeight, "number", 30)
  MaxBodyHeight = Checker(MaxBodyHeight, "number", 180)
  Callback = Checker(Callback, "function", function() end)

  return Tab:AddTable({
    Title = Name,
    Content = Content,
    Columns = Columns,
    Rows = Rows,
    RowHeight = RowHeight,
    MaxBodyHeight = MaxBodyHeight,
    Callback = Callback
  })
end

return FuncsV3
