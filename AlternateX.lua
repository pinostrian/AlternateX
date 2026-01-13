--==================================================
-- Alternate X UI Library
-- 𝙰𝚕𝚝𝚎𝚛𝚗𝚊𝚝𝚎 𝚇 𝚂𝚙𝚎𝚌𝚒𝚊𝚕𝚒𝚣𝚎𝚍 𝚑𝚞𝚋
--==================================================

local AlternateX = {}
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Player = Players.LocalPlayer

--==================================================
-- Utils
--==================================================
local function round(ui, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = ui
end

local function tween(o, t, p)
    TweenService:Create(o, TweenInfo.new(t, Enum.EasingStyle.Quint), p):Play()
end

local function dragify(f)
    local d, s, sp
    f.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            d = true s = i.Position sp = f.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if d and i.UserInputType == Enum.UserInputType.MouseMovement then
            local dx = i.Position - s
            f.Position = sp + UDim2.fromOffset(dx.X, dx.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end
    end)
end

--==================================================
-- Create Window
--==================================================
function AlternateX:CreateWindow(cfg)
    cfg = cfg or {}
    cfg.Icon = cfg.Icon or {}
    cfg.KeySystem = cfg.KeySystem or {}

    local Gui = Instance.new("ScreenGui", Player.PlayerGui)
    Gui.Name = "AlternateX"
    Gui.ResetOnSpawn = false

    ------------------------------------------------
    -- ICON
    ------------------------------------------------
    local IconBtn
    if cfg.Icon.Enabled then
        IconBtn = Instance.new("ImageButton", Gui)
        IconBtn.Size = UDim2.fromOffset(cfg.Icon.Size or 50, cfg.Icon.Size or 50)
        IconBtn.Position = UDim2.fromScale(0.05, 0.5)
        IconBtn.Image = cfg.Icon.ImageId
        IconBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
        round(IconBtn, 14)
        dragify(IconBtn)
    end

    ------------------------------------------------
    -- MAIN WINDOW
    ------------------------------------------------
    local Main = Instance.new("Frame", Gui)
    Main.Size = UDim2.fromOffset(560,360)
    Main.Position = UDim2.fromScale(.5,.5)
    Main.AnchorPoint = Vector2.new(.5,.5)
    Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
    Main.Visible = false
    round(Main,16)
    dragify(Main)

    if IconBtn then
        IconBtn.MouseButton1Click:Connect(function()
            Main.Visible = not Main.Visible
        end)
    else
        Main.Visible = true
    end

    ------------------------------------------------
    -- KEY SYSTEM
    ------------------------------------------------
    local Unlocked = not cfg.KeySystem.Enabled

    if cfg.KeySystem.Enabled then
        local KeyFrame = Instance.new("Frame", Main)
        KeyFrame.Size = UDim2.fromScale(1,1)
        KeyFrame.BackgroundColor3 = Color3.fromRGB(18,18,18)
        round(KeyFrame,16)

        local Title = Instance.new("TextLabel", KeyFrame)
        Title.Text = cfg.KeySystem.Title or "Key System"
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 22
        Title.TextColor3 = Color3.new(1,1,1)
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.fromScale(.5,.28)
        Title.AnchorPoint = Vector2.new(.5,.5)
        Title.Size = UDim2.fromOffset(320,40)

        local Box = Instance.new("TextBox", KeyFrame)
        Box.PlaceholderText = "Enter Key"
        Box.Size = UDim2.fromOffset(260,40)
        Box.Position = UDim2.fromScale(.5,.42)
        Box.AnchorPoint = Vector2.new(.5,.5)
        Box.Font = Enum.Font.Gotham
        Box.TextSize = 14
        Box.BackgroundColor3 = Color3.fromRGB(30,30,30)
        Box.TextColor3 = Color3.new(1,1,1)
        round(Box,10)

        local Verify = Instance.new("TextButton", KeyFrame)
        Verify.Text = "Verify Key"
        Verify.Size = UDim2.fromOffset(260,40)
        Verify.Position = UDim2.fromScale(.5,.54)
        Verify.AnchorPoint = Vector2.new(.5,.5)
        Verify.Font = Enum.Font.GothamBold
        Verify.TextSize = 14
        Verify.BackgroundColor3 = Color3.fromRGB(80,120,255)
        Verify.TextColor3 = Color3.new(1,1,1)
        round(Verify,10)

        local GetKey = Instance.new("TextButton", KeyFrame)
        GetKey.Text = "Get Key"
        GetKey.Size = UDim2.fromOffset(260,36)
        GetKey.Position = UDim2.fromScale(.5,.65)
        GetKey.AnchorPoint = Vector2.new(.5,.5)
        GetKey.Font = Enum.Font.Gotham
        GetKey.TextSize = 13
        GetKey.BackgroundColor3 = Color3.fromRGB(40,40,40)
        GetKey.TextColor3 = Color3.new(1,1,1)
        round(GetKey,10)

        GetKey.MouseButton1Click:Connect(function()
            if setclipboard then setclipboard(cfg.KeySystem.GetKeyUrl) end
        end)

        Verify.MouseButton1Click:Connect(function()
            if Box.Text == cfg.KeySystem.Key then
                tween(KeyFrame, .35, {BackgroundTransparency = 1})
                task.wait(.35)
                KeyFrame:Destroy()
                Unlocked = true
            else
                tween(Box,.15,{BackgroundColor3=Color3.fromRGB(120,40,40)})
                task.wait(.15)
                tween(Box,.15,{BackgroundColor3=Color3.fromRGB(30,30,30)})
            end
        end)
    end

    ------------------------------------------------
    -- CONTENT API
    ------------------------------------------------
    local Pages = Instance.new("Frame", Main)
    Pages.Size = UDim2.fromScale(1,1)
    Pages.BackgroundTransparency = 1

    local Window = {}

    function Window:CreateTab(name)
        if not Unlocked then return end
        local Tab = {}
        function Tab:AddButton(text, cb)
            print("Button:", text)
            if cb then cb() end
        end
        return Tab
    end

    return Window
end

return AlternateX
