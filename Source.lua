

local UnfairLibrary = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Auto-destroy existing UI
local existing = game.CoreGui:FindFirstChild("UnfairLibrary")
if existing then
    existing:Destroy()
end

local Themes = {
    Default = {
        MainBackground = Color3.fromRGB(25, 25, 25),
        TabHolder = Color3.fromRGB(35, 35, 35),
        ContentHolder = Color3.fromRGB(30, 30, 30),
        TabButton = Color3.fromRGB(45, 45, 45),
        Button = Color3.fromRGB(50, 50, 50),
        DropdownOption = Color3.fromRGB(60, 60, 60),
        TextColor = Color3.fromRGB(255, 255, 255),
        NotifyBackground = Color3.fromRGB(60, 60, 60)
    },

    Light = {
        MainBackground = Color3.fromRGB(240, 240, 240),
        TabHolder = Color3.fromRGB(220, 220, 220),
        ContentHolder = Color3.fromRGB(230, 230, 230),
        TabButton = Color3.fromRGB(200, 200, 200),
        Button = Color3.fromRGB(180, 180, 180),
        DropdownOption = Color3.fromRGB(170, 170, 170),
        TextColor = Color3.fromRGB(0, 0, 0),
        NotifyBackground = Color3.fromRGB(200, 200, 200)
    }
}

local currentTheme = Themes.Default

local ConfigName = "UnfairConfig.ulib"
local ConfigPath = ConfigName -- saves in executor workspace root
local Config = {
    Theme = "Default",
    Toggles = {},
    Dropdowns = {}
}

local function SaveConfig()
    local encoded = HttpService:JSONEncode(Config)
    writefile(ConfigPath, encoded)
end

local function LoadConfig()
    if isfile(ConfigPath) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(ConfigPath))
        end)
        if success and type(data) == "table" then
            Config = data
        end
    end
end

LoadConfig()

local function createUICorner(radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    return corner
end

function UnfairLibrary:CreateWindow(title)
    local gui = Instance.new("ScreenGui")
    gui.Name = "UnfairLibrary"
    gui.Parent = game.CoreGui

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 500, 0, 350)
    main.Position = UDim2.new(0.5, -250, 0.5, -175)
    main.BackgroundColor3 = currentTheme.MainBackground
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    createUICorner(12).Parent = main

    local tabHolder = Instance.new("Frame", main)
    tabHolder.Size = UDim2.new(0, 150, 1, 0)
    tabHolder.Position = UDim2.new(0, 0, 0, 0)
    tabHolder.BackgroundColor3 = currentTheme.TabHolder
    tabHolder.BorderSizePixel = 0
    createUICorner(0).Parent = tabHolder

    local contentHolder = Instance.new("Frame", main)
    contentHolder.Size = UDim2.new(1, -150, 1, 0)
    contentHolder.Position = UDim2.new(0, 150, 0, 0)
    contentHolder.BackgroundColor3 = currentTheme.ContentHolder
    contentHolder.BorderSizePixel = 0
    createUICorner(0).Parent = contentHolder

    local tabs = {}

    local function createTab(tabName)
        local button = Instance.new("TextButton", tabHolder)
        button.Size = UDim2.new(1, 0, 0, 40)
        button.BackgroundColor3 = currentTheme.TabButton
        button.TextColor3 = currentTheme.TextColor
        button.Text = tabName
        button.Font = Enum.Font.GothamBold
        button.TextSize = 14
        button.BorderSizePixel = 0
        button.AutoButtonColor = false
        createUICorner(6).Parent = button

        local tabFrame = Instance.new("Frame", contentHolder)
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.Visible = false
        tabFrame.BackgroundTransparency = 1

        local layout = Instance.new("UIListLayout", tabFrame)
        layout.Padding = UDim.new(0, 5)
        layout.SortOrder = Enum.SortOrder.LayoutOrder

        button.MouseButton1Click:Connect(function()
            for _, t in pairs(tabs) do
                t.frame.Visible = false
            end
            tabFrame.Visible = true
        end)

        table.insert(tabs, {name = tabName, button = button, frame = tabFrame})

        return tabFrame
    end

    local function addLabel(tab, text)
        local label = Instance.new("TextLabel", tab)
        label.Size = UDim2.new(1, -10, 0, 30)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = currentTheme.TextColor
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
    end

    local function addButton(tab, text, callback)
        local btn = Instance.new("TextButton", tab)
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.BackgroundColor3 = currentTheme.Button
        btn.TextColor3 = currentTheme.TextColor
        btn.Text = text
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.BorderSizePixel = 0
        createUICorner(6).Parent = btn
        btn.MouseButton1Click:Connect(callback)
    end

    local function addToggle(tab, text, callback)
        local toggle = Instance.new("TextButton", tab)
        toggle.Size = UDim2.new(1, -10, 0, 30)
        toggle.BackgroundColor3 = currentTheme.Button
        toggle.TextColor3 = currentTheme.TextColor
        toggle.Font = Enum.Font.Gotham
        toggle.TextSize = 14
        toggle.BorderSizePixel = 0
        createUICorner(6).Parent = toggle

        local state = Config.Toggles[text] or false
        toggle.Text = text .. (state and ": ON" or ": OFF")

        toggle.MouseButton1Click:Connect(function()
            state = not state
            Config.Toggles[text] = state
            toggle.Text = text .. (state and ": ON" or ": OFF")
            SaveConfig()
            if callback then callback(state) end
        end)

        if callback then callback(state) end
    end

    local function addInput(tab, placeholder, callback)
        local input = Instance.new("TextBox", tab)
        input.Size = UDim2.new(1, -10, 0, 30)
        input.PlaceholderText = placeholder
        input.BackgroundColor3 = currentTheme.Button
        input.TextColor3 = currentTheme.TextColor
        input.Font = Enum.Font.Gotham
        input.TextSize = 14
        input.BorderSizePixel = 0
        createUICorner(6).Parent = input
        input.FocusLost:Connect(function(enter)
            if enter and callback then
                callback(input.Text)
            end
        end)
    end

    local function addDropdown(tab, title, options, callback)
        local dropdown = Instance.new("TextButton", tab)
        dropdown.Size = UDim2.new(1, -10, 0, 30)
        dropdown.BackgroundColor3 = currentTheme.Button
        dropdown.TextColor3 = currentTheme.TextColor
        dropdown.Font = Enum.Font.Gotham
        dropdown.TextSize = 14
        dropdown.BorderSizePixel = 0
        createUICorner(6).Parent = dropdown

        local selected = Config.Dropdowns[title] or options[1]
        dropdown.Text = title .. ": " .. selected

        dropdown.MouseButton1Click:Connect(function()
            for _, opt in ipairs(options) do
                local btn = Instance.new("TextButton", tab)
                btn.Size = UDim2.new(1, -20, 0, 30)
                btn.BackgroundColor3 = currentTheme.DropdownOption
                btn.Text = opt
                btn.TextColor3 = currentTheme.TextColor
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 14
                btn.BorderSizePixel = 0
                createUICorner(6).Parent = btn

                btn.MouseButton1Click:Connect(function()
                    selected = opt
                    Config.Dropdowns[title] = selected
                    SaveConfig()
                    dropdown.Text = title .. ": " .. opt
                    if callback then callback(opt) end
                    btn:Destroy()
                end)
            end
        end)

        if callback then callback(selected) end
    end

    local function addSlider(tab, label, min, max, callback)
        local frame = Instance.new("Frame", tab)
        frame.Size = UDim2.new(1, -10, 0, 40)
        frame.BackgroundTransparency = 1

        local sliderLabel = Instance.new("TextLabel", frame)
        sliderLabel.Size = UDim2.new(1, 0, 0.5, 0)
        sliderLabel.Text = label
        sliderLabel.TextColor3 = currentTheme.TextColor
        sliderLabel.Font = Enum.Font.Gotham
        sliderLabel.TextSize = 14
        sliderLabel.BackgroundTransparency = 1

        local slider = Instance.new("TextButton", frame)
        slider.Size = UDim2.new(1, 0, 0.5, 0)
        slider.Position = UDim2.new(0, 0, 0.5, 0)
        slider.BackgroundColor3 = currentTheme.Button
        slider.Text = tostring(min)
        slider.TextColor3 = currentTheme.TextColor
        slider.Font = Enum.Font.Gotham
        slider.TextSize = 14
        slider.BorderSizePixel = 0
        createUICorner(6).Parent = slider

        local current = min
        slider.MouseButton1Click:Connect(function()
            current = current + 1
            if current > max then current = min end
            slider.Text = tostring(current)
            if callback then callback(current) end
        end)
    end

    local function notify(text)
        local note = Instance.new("TextLabel", game.CoreGui)
        note.Size = UDim2.new(0, 300, 0, 50)
        note.Position = UDim2.new(0.5, -150, 0.1, 0)
        note.BackgroundColor3 = currentTheme.NotifyBackground
        note.Text = text
        note.TextColor3 = currentTheme.TextColor
        note.Font = Enum.Font.GothamBold
        note.TextSize = 16
        note.BorderSizePixel = 0
        createUICorner(10).Parent = note

        task.delay(3, function()
            note:Destroy()
        end)
    end

    local Window = {
        CreateTab = createTab,
        AddLabel = addLabel,
        AddButton = addButton,
        AddToggle = addToggle,
        AddInput = addInput,
        AddDropdown = addDropdown,
        AddSlider = addSlider,
        Notify = notify,
        SetTheme = function(themeName)
            if Themes[themeName] then
                currentTheme = Themes[themeName]
                Config.Theme = themeName
                SaveConfig()
                notify("Theme set to: " .. themeName)
            else
                warn("Theme not found:", themeName)
            end
        end
    }

    -- Show first tab by default if exists
    if #tabs > 0 then
        tabs[1].frame.Visible = true
    end
    
    Window.SetTheme(Config.Theme)

    return Window
end

return UnfairLibrary
