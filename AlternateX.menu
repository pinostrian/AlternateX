-- Alternate X | Rayfield Style Hub

local AX = {}
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Player = Players.LocalPlayer

-- Utility
local function round(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = obj
end

-- Window
function AX:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.fromScale(0.45, 0.55)
    Main.Position = UDim2.fromScale(0.5, 0.5)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    round(Main, 12)

    -- Drag
    local dragging, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = startPos + UDim2.fromOffset(delta.X, delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Title
    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, -20, 0, 40)
    Title.Position = UDim2.fromOffset(10, 5)
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Left

    -- Tabs
    local Tabs = Instance.new("Frame", Main)
    Tabs.Size = UDim2.new(0, 120, 1, -60)
    Tabs.Position = UDim2.fromOffset(10, 50)
    Tabs.BackgroundTransparency = 1

    local TabLayout = Instance.new("UIListLayout", Tabs)
    TabLayout.Padding = UDim.new(0, 6)

    local Pages = Instance.new("Frame", Main)
    Pages.Size = UDim2.new(1, -150, 1, -60)
    Pages.Position = UDim2.fromOffset(140, 50)
    Pages.BackgroundTransparency = 1

    local Window = {}

    function Window:CreateTab(name)
        local TabBtn = Instance.new("TextButton", Tabs)
        TabBtn.Size = UDim2.new(1, 0, 0, 36)
        TabBtn.Text = name
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 14
        TabBtn.TextColor3 = Color3.fromRGB(220,220,220)
        TabBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
        round(TabBtn, 8)

        local Page = Instance.new("ScrollingFrame", Pages)
        Page.Size = UDim2.fromScale(1,1)
        Page.CanvasSize = UDim2.new(0,0,0,0)
        Page.ScrollBarImageTransparency = 1
        Page.Visible = false
        Page.BackgroundTransparency = 1

        local Layout = Instance.new("UIListLayout", Page)
        Layout.Padding = UDim.new(0, 8)

        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 10)
        end)

        TabBtn.MouseButton1Click:Connect(function()
            for _,v in pairs(Pages:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            Page.Visible = true
        end)

        local Tab = {}

        function Tab:AddButton(text, callback)
            local Btn = Instance.new("TextButton", Page)
            Btn.Size = UDim2.new(1, -10, 0, 38)
            Btn.Text = text
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 14
            Btn.TextColor3 = Color3.new(1,1,1)
            Btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
            round(Btn, 8)

            Btn.MouseButton1Click:Connect(callback)
        end

        function Tab:AddToggle(text, default, callback)
            local Toggle = Instance.new("TextButton", Page)
            Toggle.Size = UDim2.new(1, -10, 0, 38)
            Toggle.Text = text
            Toggle.Font = Enum.Font.Gotham
            Toggle.TextSize = 14
            Toggle.TextColor3 = Color3.new(1,1,1)
            Toggle.BackgroundColor3 = default and Color3.fromRGB(0,170,255) or Color3.fromRGB(40,40,40)
            round(Toggle, 8)

            local state = default
            Toggle.MouseButton1Click:Connect(function()
                state = not state
                Toggle.BackgroundColor3 = state and Color3.fromRGB(0,170,255) or Color3.fromRGB(40,40,40)
                callback(state)
            end)
        end

        if #Pages:GetChildren() == 1 then Page.Visible = true end
        return Tab
    end

    return Window
end

return AX
