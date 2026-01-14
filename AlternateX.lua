--==================================================
-- Alternate X UI Library
-- Premium | Clean | Stylisg-Inspired
--==================================================

local AX = {}
AX.__index = AX

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Player = Players.LocalPlayer

--------------------------------------------------
-- Utilities
--------------------------------------------------
local function round(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = obj
end

local function tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.25, Enum.EasingStyle.Quint), props):Play()
end

--------------------------------------------------
-- Window
--------------------------------------------------
function AX:CreateWindow(cfg)
    cfg = cfg or {}

    local Window = {}
    setmetatable(Window, AX)

    local gui = Instance.new("ScreenGui", game.CoreGui)
    gui.Name = "AlternateX"
    gui.ResetOnSpawn = false

    --------------------------------------------------
    -- Loading Screen
    --------------------------------------------------
    if cfg.Loading then
        local Load = Instance.new("Frame", gui)
        Load.Size = UDim2.fromScale(1,1)
        Load.BackgroundColor3 = Color3.fromRGB(10,10,12)

        local Title = Instance.new("TextLabel", Load)
        Title.Text = cfg.Loading.Title or "Loading..."
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 30
        Title.TextColor3 = Color3.new(1,1,1)
        Title.BackgroundTransparency = 1
        Title.AnchorPoint = Vector2.new(.5,.5)
        Title.Position = UDim2.fromScale(.5,.45)

        local Sub = Instance.new("TextLabel", Load)
        Sub.Text = cfg.Loading.Subtitle or ""
        Sub.Font = Enum.Font.Gotham
        Sub.TextSize = 14
        Sub.TextColor3 = Color3.fromRGB(170,170,170)
        Sub.BackgroundTransparency = 1
        Sub.AnchorPoint = Vector2.new(.5,.5)
        Sub.Position = UDim2.fromScale(.5,.53)

        task.wait(cfg.Loading.Time or 2)
        tween(Load, {BackgroundTransparency = 1}, .4)
        task.wait(.4)
        Load:Destroy()
    end

    --------------------------------------------------
    -- Key System
    --------------------------------------------------
    if cfg.KeySystem and cfg.KeySystem.Enabled then
        local KeyUI = Instance.new("Frame", gui)
        KeyUI.Size = UDim2.fromScale(1,1)
        KeyUI.BackgroundColor3 = Color3.fromRGB(10,10,12)

        local Box = Instance.new("Frame", KeyUI)
        Box.Size = UDim2.fromOffset(320,190)
        Box.AnchorPoint = Vector2.new(.5,.5)
        Box.Position = UDim2.fromScale(.5,.5)
        Box.BackgroundColor3 = Color3.fromRGB(18,18,22)
        round(Box,16)

        local Input = Instance.new("TextBox", Box)
        Input.PlaceholderText = "Enter Key"
        Input.Size = UDim2.fromOffset(260,42)
        Input.Position = UDim2.fromOffset(30,70)
        Input.BackgroundColor3 = Color3.fromRGB(30,30,35)
        Input.TextColor3 = Color3.new(1,1,1)
        Input.Font = Enum.Font.Gotham
        Input.TextSize = 14
        round(Input,10)

        local Verify = Instance.new("TextButton", Box)
        Verify.Text = "Verify"
        Verify.Size = UDim2.fromOffset(260,38)
        Verify.Position = UDim2.fromOffset(30,125)
        Verify.BackgroundColor3 = Color3.fromRGB(90,90,255)
        Verify.TextColor3 = Color3.new(1,1,1)
        Verify.Font = Enum.Font.GothamBold
        Verify.TextSize = 14
        round(Verify,10)

        Verify.MouseButton1Click:Connect(function()
            if Input.Text == cfg.KeySystem.Key then
                KeyUI:Destroy()
            else
                Verify.Text = "Invalid Key"
                task.wait(1)
                Verify.Text = "Verify"
            end
        end)

        repeat task.wait() until not KeyUI.Parent
    end

    --------------------------------------------------
    -- Main UI
    --------------------------------------------------
    local Main = Instance.new("Frame", gui)
    Main.Size = UDim2.fromOffset(540,360)
    Main.AnchorPoint = Vector2.new(.5,.5)
    Main.Position = UDim2.fromScale(.5,.5)
    Main.BackgroundColor3 = Color3.fromRGB(16,16,20)
    round(Main,18)

    -- Drag
    local drag, startPos, start
    Main.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true
            start = i.Position
            startPos = Main.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - start
            Main.Position = startPos + UDim2.fromOffset(d.X, d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = false
        end
    end)

    --------------------------------------------------
    -- Floating Icon
    --------------------------------------------------
    if cfg.FloatingIcon and cfg.FloatingIcon.Enabled then
        local Icon = Instance.new("ImageButton", gui)
        Icon.Size = UDim2.fromOffset(cfg.FloatingIcon.Size or 50, cfg.FloatingIcon.Size or 50)
        Icon.Position = cfg.FloatingIcon.Position or UDim2.fromScale(0.05,0.5)
        Icon.Image = cfg.FloatingIcon.Image or "rbxassetid://124558441880674"
        Icon.BackgroundColor3 = Color3.fromRGB(22,22,26)
        Icon.AutoButtonColor = false
        round(Icon,14)

        local open = true
        Icon.MouseButton1Click:Connect(function()
            open = not open
            Main.Visible = open
        end)

        -- Drag icon
        local idrag, istart, ipos
        Icon.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                idrag = true
                istart = i.Position
                ipos = Icon.Position
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if idrag and i.UserInputType == Enum.UserInputType.MouseMovement then
                local d = i.Position - istart
                Icon.Position = ipos + UDim2.fromOffset(d.X, d.Y)
            end
        end)
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                idrag = false
            end
        end)
    end

    --------------------------------------------------
    -- Tabs
    --------------------------------------------------
    local Tabs = Instance.new("Frame", Main)
    Tabs.Size = UDim2.fromOffset(140,320)
    Tabs.Position = UDim2.fromOffset(10,20)
    Tabs.BackgroundTransparency = 1

    local Pages = Instance.new("Frame", Main)
    Pages.Size = UDim2.fromOffset(360,320)
    Pages.Position = UDim2.fromOffset(170,20)
    Pages.BackgroundTransparency = 1

    local TList = Instance.new("UIListLayout", Tabs)
    TList.Padding = UDim.new(0,8)

    function Window:CreateTab(name)
        local Tab = {}

        local Btn = Instance.new("TextButton", Tabs)
        Btn.Text = name
        Btn.Size = UDim2.fromOffset(130,38)
        Btn.BackgroundColor3 = Color3.fromRGB(26,26,32)
        Btn.TextColor3 = Color3.fromRGB(220,220,220)
        Btn.Font = Enum.Font.Gotham
        Btn.TextSize = 14
        round(Btn,10)

        local Page = Instance.new("ScrollingFrame", Pages)
        Page.Size = UDim2.fromScale(1,1)
        Page.ScrollBarImageTransparency = 1
        Page.CanvasSize = UDim2.new(0,0,0,0)
        Page.Visible = false

        local PList = Instance.new("UIListLayout", Page)
        PList.Padding = UDim.new(0,10)

        Btn.MouseButton1Click:Connect(function()
            for _,v in ipairs(Pages:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            Page.Visible = true
        end)

        function Tab:AddButton(text, cb)
            local B = Instance.new("TextButton", Page)
            B.Text = text
            B.Size = UDim2.fromOffset(340,42)
            B.BackgroundColor3 = Color3.fromRGB(32,32,38)
            B.TextColor3 = Color3.new(1,1,1)
            B.Font = Enum.Font.GothamBold
            B.TextSize = 14
            round(B,10)

            B.MouseButton1Click:Connect(function()
                tween(B, {BackgroundColor3 = Color3.fromRGB(90,90,255)}, .15)
                task.wait(.15)
                tween(B, {BackgroundColor3 = Color3.fromRGB(32,32,38)}, .15)
                cb()
            end)
        end

        function Tab:AddToggle(text, default, cb)
            local state = default
            local T = Instance.new("TextButton", Page)
            T.Text = text
            T.Size = UDim2.fromOffset(340,42)
            T.BackgroundColor3 = state and Color3.fromRGB(90,90,255) or Color3.fromRGB(32,32,38)
            T.TextColor3 = Color3.new(1,1,1)
            T.Font = Enum.Font.Gotham
            T.TextSize = 14
            round(T,10)

            cb(state)

            T.MouseButton1Click:Connect(function()
                state = not state
                tween(T, {
                    BackgroundColor3 = state and Color3.fromRGB(90,90,255) or Color3.fromRGB(32,32,38)
                })
                cb(state)
            end)
        end

        return Tab
    end

    return Window
end

return AX
