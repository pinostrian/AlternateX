--==================================================
-- 𝚊𝚕𝚝𝚎𝚛𝙽𝚊𝚝𝚎-𝚇
-- 𝚜𝚙𝚎𝚌𝚒𝚊𝚕𝚒𝚣𝚎𝚍 𝚑𝚞𝚋
--==================================================

local AlternateX = {}
AlternateX.__index = AlternateX

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Player = Players.LocalPlayer

--==================================================
-- Utility
--==================================================

local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    return obj
end

local function Round(ui, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = ui
end

--==================================================
-- Loading Screen
--==================================================

local function ShowLoading(title, subtitle)
    local gui = Create("ScreenGui", {Parent = Player.PlayerGui, ResetOnSpawn = false})
    local frame = Create("Frame", {
        Parent = gui,
        Size = UDim2.fromScale(1,1),
        BackgroundColor3 = Color3.fromRGB(10,10,10)
    })

    local titleLabel = Create("TextLabel", {
        Parent = frame,
        Size = UDim2.fromScale(1,0.1),
        Position = UDim2.fromScale(0,0.45),
        Text = title,
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.GothamBold,
        TextScaled = true,
        BackgroundTransparency = 1
    })

    local subLabel = Create("TextLabel", {
        Parent = frame,
        Size = UDim2.fromScale(1,0.05),
        Position = UDim2.fromScale(0,0.53),
        Text = subtitle,
        TextColor3 = Color3.fromRGB(180,180,180),
        Font = Enum.Font.Gotham,
        TextScaled = true,
        BackgroundTransparency = 1
    })

    task.wait(1.5)
    gui:Destroy()
end

--==================================================
-- Key System
--==================================================

local function RunKeySystem(settings)
    if not settings then return true end

    local accepted = false

    local gui = Create("ScreenGui", {Parent = Player.PlayerGui, ResetOnSpawn = false})
    local frame = Create("Frame", {
        Parent = gui,
        Size = UDim2.fromScale(0.3,0.3),
        Position = UDim2.fromScale(0.35,0.35),
        BackgroundColor3 = Color3.fromRGB(20,20,20)
    })
    Round(frame, 12)

    local box = Create("TextBox", {
        Parent = frame,
        Size = UDim2.fromScale(0.9,0.2),
        Position = UDim2.fromScale(0.05,0.4),
        PlaceholderText = "Enter Key",
        Text = "",
        Font = Enum.Font.Gotham,
        TextColor3 = Color3.new(1,1,1),
        BackgroundColor3 = Color3.fromRGB(30,30,30)
    })
    Round(box, 8)

    local verify = Create("TextButton", {
        Parent = frame,
        Size = UDim2.fromScale(0.4,0.18),
        Position = UDim2.fromScale(0.05,0.7),
        Text = "Verify",
        Font = Enum.Font.GothamBold,
        TextColor3 = Color3.new(1,1,1),
        BackgroundColor3 = Color3.fromRGB(50,120,255)
    })
    Round(verify, 8)

    verify.MouseButton1Click:Connect(function()
        if box.Text ~= "" then
            accepted = true
            gui:Destroy()
        end
    end)

    repeat task.wait() until accepted
    return true
end

--==================================================
-- Window
--==================================================

function AlternateX:CreateWindow(config)
    ShowLoading(config.LoadingTitle or "Alternate X", config.LoadingSubtitle or "Loading")

    if config.KeySystem then
        RunKeySystem(config.KeySettings)
    end

    local Window = {}
    Window.Tabs = {}

    local gui = Create("ScreenGui", {Parent = Player.PlayerGui, ResetOnSpawn = false})
    local main = Create("Frame", {
        Parent = gui,
        Size = UDim2.fromScale(0.45,0.55),
        Position = UDim2.fromScale(0.275,0.225),
        BackgroundColor3 = Color3.fromRGB(18,18,18)
    })
    Round(main, 14)

    local tabHolder = Create("Frame", {
        Parent = main,
        Size = UDim2.fromScale(0.25,1),
        BackgroundColor3 = Color3.fromRGB(22,22,22)
    })

    local contentHolder = Create("Frame", {
        Parent = main,
        Position = UDim2.fromScale(0.25,0),
        Size = UDim2.fromScale(0.75,1),
        BackgroundTransparency = 1
    })

    --==================================================
    -- Tabs
    --==================================================

    function Window:CreateTab(name)
        local Tab = {}

        local button = Create("TextButton", {
            Parent = tabHolder,
            Size = UDim2.fromScale(1,0.08),
            Text = name,
            Font = Enum.Font.Gotham,
            TextColor3 = Color3.new(1,1,1),
            BackgroundTransparency = 1
        })

        local page = Create("Frame", {
            Parent = contentHolder,
            Size = UDim2.fromScale(1,1),
            Visible = false,
            BackgroundTransparency = 1
        })

        button.MouseButton1Click:Connect(function()
            for _, t in pairs(Window.Tabs) do
                t.Page.Visible = false
            end
            page.Visible = true
        end)

        function Tab:AddButton(info)
            local btn = Create("TextButton", {
                Parent = page,
                Size = UDim2.fromScale(0.9,0.1),
                Position = UDim2.fromScale(0.05,0.05),
                Text = info.Name,
                Font = Enum.Font.Gotham,
                TextColor3 = Color3.new(1,1,1),
                BackgroundColor3 = Color3.fromRGB(35,35,35)
            })
            Round(btn, 8)

            btn.MouseButton1Click:Connect(info.Callback)
        end

        Tab.Page = page
        table.insert(Window.Tabs, Tab)

        if #Window.Tabs == 1 then
            page.Visible = true
        end

        return Tab
    end

    return Window
end

--==================================================
-- Return
--==================================================

return setmetatable({}, AlternateX)
