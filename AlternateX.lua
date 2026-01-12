-- AlternateX Library (A.X Library) 
local AlternateX = {}

-- Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- Utility
local function round(ui, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = ui
end

local function safeParent(gui)
    pcall(function()
        gui.Parent = game.CoreGui
    end)
end

-- ========== WINDOW ==========
function AlternateX:CreateWindow(cfg)
    cfg = cfg or {}

    -- Defaults
    local Name = cfg.Name or "AlternateX"
    local LoadingTitle = cfg.LoadingTitle or Name
    local LoadingSubtitle = cfg.LoadingSubtitle or ""
    local Theme = cfg.Theme or "Default"

    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AlternateXUI"
    ScreenGui.ResetOnSpawn = false
    safeParent(ScreenGui)

    -- Main Frame
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.fromOffset(560, 380)
    Main.Position = UDim2.fromScale(0.5, 0.5)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(22,22,22)
    round(Main, 14)

    -- Dragging
    local dragging, dragStart, startPos
    Main.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = i.Position
            startPos = Main.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - dragStart
            Main.Position = startPos + UDim2.fromOffset(delta.X, delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Title
    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, -20, 0, 40)
    Title.Position = UDim2.fromOffset(10, 8)
    Title.Text = Name
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.TextColor3 = Color3.new(1,1,1)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Left

    -- Sidebar
    local TabsFrame = Instance.new("Frame", Main)
    TabsFrame.Size = UDim2.fromOffset(140, 300)
    TabsFrame.Position = UDim2.fromOffset(10, 60)
    TabsFrame.BackgroundTransparency = 1

    local TabLayout = Instance.new("UIListLayout", TabsFrame)
    TabLayout.Padding = UDim.new(0, 6)

    -- Pages
    local Pages = Instance.new("Frame", Main)
    Pages.Size = UDim2.fromOffset(380, 300)
    Pages.Position = UDim2.fromOffset(170, 60)
    Pages.BackgroundTransparency = 1

    -- Window API
    local Window = {}

    function Window:CreateTab(tabName)
        -- Tab Button
        local TabBtn = Instance.new("TextButton", TabsFrame)
        TabBtn.Size = UDim2.new(1, 0, 0, 36)
        TabBtn.Text = tabName
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 14
        TabBtn.TextColor3 = Color3.fromRGB(230,230,230)
        TabBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
        round(TabBtn, 8)

        -- Page
        local Page = Instance.new("ScrollingFrame", Pages)
        Page.Size = UDim2.fromScale(1,1)
        Page.ScrollBarImageTransparency = 1
        Page.CanvasSize = UDim2.new(0,0,0,0)
        Page.Visible = false
        Page.BackgroundTransparency = 1

        local Layout = Instance.new("UIListLayout", Page)
        Layout.Padding = UDim.new(0, 8)

        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 12)
        end)

        TabBtn.MouseButton1Click:Connect(function()
            for _,v in pairs(Pages:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            Page.Visible = true
        end)

        if #Pages:GetChildren() == 1 then
            Page.Visible = true
        end

        -- Tab API
        local Tab = {}

        function Tab:AddButton(text, callback)
            local Btn = Instance.new("TextButton", Page)
            Btn.Size = UDim2.new(1, -10, 0, 38)
            Btn.Text = text
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 14
            Btn.TextColor3 = Color3.new(1,1,1)
            Btn.BackgroundColor3 = Color3.fromRGB(42,42,42)
            round(Btn, 8)
            Btn.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
        end

        function Tab:AddToggle(text, default, callback)
            local state = default or false
            local Tog = Instance.new("TextButton", Page)
            Tog.Size = UDim2.new(1, -10, 0, 38)
            Tog.Text = text
            Tog.Font = Enum.Font.Gotham
            Tog.TextSize = 14
            Tog.TextColor3 = Color3.new(1,1,1)
            Tog.BackgroundColor3 = state and Color3.fromRGB(0,170,255) or Color3.fromRGB(42,42,42)
            round(Tog, 8)

            Tog.MouseButton1Click:Connect(function()
                state = not state
                Tog.BackgroundColor3 = state and Color3.fromRGB(0,170,255) or Color3.fromRGB(42,42,42)
                pcall(callback, state)
            end)
        end

        return Tab
    end

    return Window
end

return AlternateX

--[[====================================================
	AlternateX Example Usage
======================================================

-- Load the library
local AlternateX = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/pinostrian/AlternateX/main/AlternateX.lua"
))()

-- Create Window
local Window = AlternateX:CreateWindow({
	Name = "AlternateX Example Window",
	LoadingTitle = "AlternateX Interface Suite",
	LoadingSubtitle = "by Sirius",
	Theme = "Default",
	Icon = 0,

	ConfigurationSaving = {
		Enabled = true,
		FolderName = "AlternateX",
		FileName = "ExampleConfig"
	},

	Discord = {
		Enabled = false,
		Invite = "noinvitelink",
		RememberJoins = true
	},

	KeySystem = false,
	KeySettings = {
		Title = "AlternateX",
		Subtitle = "Key System",
		Note = "Enter the key to continue",
		FileName = "AlternateXKey",
		SaveKey = true,
		GrabKeyFromSite = false,
		Key = {"Hello"}
	}
})

-- Create Tabs
local MainTab = Window:CreateTab("Main")
local MiscTab = Window:CreateTab("Misc")

-- Add Button
MainTab:AddButton("Print Hello", function()
	print("Hello from AlternateX")
end)

-- Add Toggle
MainTab:AddToggle("God Mode", false, function(state)
	print("God Mode:", state)
end)

-- Add more controls as needed
MiscTab:AddButton("Close UI", function()
	game:GetService("CoreGui").AlternateXUI:Destroy()
end)

======================================================]]
