# Booting the Library
```lua
local UnfairLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/UnfairLTD/UnfairLibary/refs/heads/main/Source.lua"))()
```

# Creating the Main Window
```lua
local Window = UnfairLibrary:CreateWindow("UI Name")
```

# Creating Tabs
```lua
local Tab = Window:CreateTab("Main")
```

# Label:
```lua
Window:AddLabel(Tab, "This is a label")
```

# Button

```lua
Window:AddButton(Tab, "Click Me", function()
    print("Button Clicked")
    Window:Notify("You clicked the button!")
end)
```

# Toggle

```lua
Window:AddToggle(Tab, "Enable Feature", function(state)
    print("Toggled:", state)
end)
```

# Input Box

```lua
Window:AddInput(Tab, "Type here", function(text)
    print("Input Received:", text)
end)
```

# Dropdown

```lua
Window:AddDropdown(Tab, "Select Color", {"Red", "Green", "Blue"}, function(option)
    print("Selected:", option)
end)
```

# Slider

```lua
Window:AddSlider(Tab, "Volume", 0, 10, function(value)
    print("Slider Value:", value)
end)
```

# Notification
```lua
Window:Notify("This is a notification message!")
```

Coming Soon
# -  Color Picker
# -  Tickbox (separate visual from Toggle)
# -  Theme/Style customization
# -  Window resizing
