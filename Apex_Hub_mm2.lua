-- Apex Hub - Safe UI Starter
-- Intended for a LocalScript in Roblox Studio, for your own experience.
-- This starter contains UI only; it does not include cheats, exploit APIs, or player-targeting tools.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remove an earlier copy, if one exists.
local previous = playerGui:FindFirstChild("ApexHubUI")
if previous then
    previous:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "ApexHubUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.DisplayOrder = 50
gui.Parent = playerGui

local panel = Instance.new("Frame")
panel.Name = "Main"
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Position = UDim2.fromScale(0.5, 0.5)
panel.Size = UDim2.new(0, 430, 0, 300)
panel.BackgroundColor3 = Color3.fromRGB(22, 24, 30)
panel.BorderSizePixel = 0
panel.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = panel

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 120, 255)
stroke.Thickness = 1.5
stroke.Transparency = 0.15
stroke.Parent = panel

local sizeConstraint = Instance.new("UISizeConstraint")
sizeConstraint.MinSize = Vector2.new(280, 220)
sizeConstraint.MaxSize = Vector2.new(560, 420)
sizeConstraint.Parent = panel

local top = Instance.new("Frame")
top.Name = "Header"
top.Size = UDim2.new(1, 0, 0, 48)
top.BackgroundColor3 = Color3.fromRGB(31, 34, 43)
top.BorderSizePixel = 0
top.Parent = panel

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 12)
topCorner.Parent = top

local title = Instance.new("TextLabel")
title.Name = "Title"
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 14, 0, 0)
title.Size = UDim2.new(1, -100, 1, 0)
title.Font = Enum.Font.GothamBold
title.Text = "APEX HUB"
title.TextColor3 = Color3.fromRGB(240, 242, 255)
title.TextSize = 17
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = top

local close = Instance.new("TextButton")
close.Name = "Close"
close.AnchorPoint = Vector2.new(1, 0.5)
close.Position = UDim2.new(1, -10, 0.5, 0)
close.Size = UDim2.new(0, 32, 0, 30)
close.BackgroundColor3 = Color3.fromRGB(175, 55, 65)
close.Text = "×"
close.Font = Enum.Font.GothamBold
close.TextSize = 20
close.TextColor3 = Color3.new(1, 1, 1)
close.Parent = top
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)

local tabs = Instance.new("Frame")
tabs.Name = "Tabs"
tabs.Position = UDim2.new(0, 10, 0, 58)
tabs.Size = UDim2.new(0, 112, 1, -68)
tabs.BackgroundTransparency = 1
tabs.Parent = panel

local tabLayout = Instance.new("UIListLayout")
tabLayout.Padding = UDim.new(0, 7)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Parent = tabs

local content = Instance.new("Frame")
content.Name = "Content"
content.Position = UDim2.new(0, 132, 0, 58)
content.Size = UDim2.new(1, -142, 1, -68)
content.BackgroundColor3 = Color3.fromRGB(28, 31, 38)
content.BorderSizePixel = 0
content.Parent = panel
Instance.new("UICorner", content).CornerRadius = UDim.new(0, 9)

local contentPadding = Instance.new("UIPadding")
contentPadding.PaddingTop = UDim.new(0, 12)
contentPadding.PaddingLeft = UDim.new(0, 12)
contentPadding.PaddingRight = UDim.new(0, 12)
contentPadding.Parent = content

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 8)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Parent = content

local function clearContent()
    for _, child in ipairs(content:GetChildren()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") then
            child:Destroy()
        end
    end
end

local function addLabel(text, height)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, height or 28)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 223, 235)
    label.TextSize = 14
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = content
    return label
end

local function showTab(tabName)
    clearContent()
    if tabName == "Home" then
        addLabel("Welcome to Apex Hub", 28).Font = Enum.Font.GothamBold
        addLabel("Safe starter interface • customize this UI for your own game.", 48)
        addLabel("Use the tabs to organize your own experience tools.", 40)
    elseif tabName == "Settings" then
        addLabel("Settings", 28).Font = Enum.Font.GothamBold
        addLabel("This is a starter page. Add settings for your own game here.", 54)
    elseif tabName == "About" then
        addLabel("Apex Hub UI Starter", 28).Font = Enum.Font.GothamBold
        addLabel("Responsive layout with mobile-friendly controls and cleanup.", 54)
    end
end

for index, tabName in ipairs({"Home", "Settings", "About"}) do
    local button = Instance.new("TextButton")
    button.Name = tabName .. "Tab"
    button.LayoutOrder = index
    button.Size = UDim2.new(1, 0, 0, 38)
    button.BackgroundColor3 = Color3.fromRGB(42, 46, 58)
    button.Text = tabName
    button.Font = Enum.Font.GothamMedium
    button.TextSize = 14
    button.TextColor3 = Color3.fromRGB(230, 232, 245)
    button.Parent = tabs
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
    button.Activated:Connect(function()
        showTab(tabName)
    end)
end

showTab("Home")

-- Mobile quick-toggle button
local toggle = Instance.new("TextButton")
toggle.Name = "ApexToggle"
toggle.AnchorPoint = Vector2.new(0, 1)
toggle.Position = UDim2.new(0, 14, 1, -14)
toggle.Size = UDim2.new(0, 58, 0, 58)
toggle.BackgroundColor3 = Color3.fromRGB(65, 75, 190)
toggle.Text = "APEX"
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 13
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Visible = UserInputService.TouchEnabled
toggle.Parent = gui
Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

toggle.Activated:Connect(function()
    panel.Visible = not panel.Visible
end)

close.Activated:Connect(function()
    panel.Visible = false
end)

-- Escape toggles panel on keyboard; touch users use the floating button.
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Escape then
        panel.Visible = not panel.Visible
    end
end)

-- Cleanup API for your own scripts:
_G.ApexHubCleanup = function()
    if gui then
        gui:Destroy()
    end
    _G.ApexHubCleanup = nil
end
