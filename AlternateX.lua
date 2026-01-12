-- AlternateX Library
local AlternateX = {}

-- Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- ===================== UTILS =====================
local function round(ui, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = ui
end

local function getParent()
	return (gethui and gethui())
		or game.CoreGui
		or LP:WaitForChild("PlayerGui")
end

-- ===================== WINDOW =====================
function AlternateX:CreateWindow(cfg)
	cfg = cfg or {}

	print("[AlternateX] CreateWindow called")

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "AlternateXUI"
	ScreenGui.ResetOnSpawn = false
	pcall(function()
		ScreenGui.Parent = getParent()
	end)

	-- MAIN
	local Main = Instance.new("Frame", ScreenGui)
	Main.Size = UDim2.fromOffset(560, 380)
	Main.Position = UDim2.fromScale(0.5, 0.5)
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
	round(Main, 14)

	-- TITLE
	local Title = Instance.new("TextLabel", Main)
	Title.Size = UDim2.new(1, -20, 0, 40)
	Title.Position = UDim2.fromOffset(10, 5)
	Title.Text = cfg.Name or "AlternateX"
	Title.TextColor3 = Color3.new(1,1,1)
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 20
	Title.BackgroundTransparency = 1
	Title.TextXAlignment = Left

	-- SIDEBAR
	local TabsFrame = Instance.new("Frame", Main)
	TabsFrame.Size = UDim2.fromOffset(140, 300)
	TabsFrame.Position = UDim2.fromOffset(10, 60)
	TabsFrame.BackgroundTransparency = 1

	local TabLayout = Instance.new("UIListLayout", TabsFrame)
	TabLayout.Padding = UDim.new(0, 6)

	-- PAGES
	local Pages = Instance.new("Frame", Main)
	Pages.Size = UDim2.fromOffset(380, 300)
	Pages.Position = UDim2.fromOffset(170, 60)
	Pages.BackgroundTransparency = 1

	local Window = {}
	local firstPage = nil

	-- ===================== TAB =====================
	function Window:CreateTab(name)
		print("[AlternateX] Tab created:", name)

		local TabBtn = Instance.new("TextButton", TabsFrame)
		TabBtn.Size = UDim2.new(1, 0, 0, 36)
		TabBtn.Text = name
		TabBtn.Font = Enum.Font.Gotham
		TabBtn.TextSize = 14
		TabBtn.TextColor3 = Color3.fromRGB(220,220,220)
		TabBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
		round(TabBtn, 8)

		local Page = Instance.new("ScrollingFrame", Pages)
		Page.Size = UDim2.fromScale(1,1)
		Page.ScrollBarImageTransparency = 1
		Page.Visible = false
		Page.BackgroundTransparency = 1
		Page.CanvasSize = UDim2.new()

		local Layout = Instance.new("UIListLayout", Page)
		Layout.Padding = UDim.new(0, 8)

		Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Page.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 10)
		end)

		TabBtn.MouseButton1Click:Connect(function()
			for _,v in pairs(Pages:GetChildren()) do
				if v:IsA("ScrollingFrame") then
					v.Visible = false
				end
			end
			Page.Visible = true
		end)

		if not firstPage then
			firstPage = Page
			Page.Visible = true
		end

		local Tab = {}

		function Tab:AddButton(text, cb)
			local Btn = Instance.new("TextButton", Page)
			Btn.Size = UDim2.new(1, -10, 0, 36)
			Btn.Text = text
			Btn.Font = Enum.Font.Gotham
			Btn.TextSize = 14
			Btn.TextColor3 = Color3.new(1,1,1)
			Btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
			round(Btn, 8)
			Btn.MouseButton1Click:Connect(function()
				pcall(cb)
			end)
		end

		return Tab
	end

	return Window
end

return AlternateX
