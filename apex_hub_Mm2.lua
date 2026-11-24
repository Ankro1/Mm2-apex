--[[
	APEX HUB v1.2
	PLAYER • MM2 • FARM • FLING • VISUALS • MISC
	INSERT / RightShift = hide / show
]]

print("[ApexHub] loaded")
if not game:IsLoaded() then game.Loaded:Wait() end

local Players          = game:GetService("Players")
local Workspace        = game:GetService("Workspace")
local TeleportService  = game:GetService("TeleportService")
local HttpService      = game:GetService("HttpService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local VirtualUser      = game:GetService("VirtualUser")
local Lighting         = game:GetService("Lighting")

local Player    = Players.LocalPlayer
local playerGui = Player:WaitForChild("PlayerGui")

pcall(function()
	local old = playerGui:FindFirstChild("ApexHubUI")
	if old then old:Destroy() end
end)

------------------------------------------------------------------
-- Config
------------------------------------------------------------------
local CONFIG_FILE = "ApexHub_Config.json"
local Cfg = { flySpeed = 60, walkSpeed = 40, jumpPower = 90, fov = 100, flingTime = 2.5, farmSpeed = 24, auraRange = 12 }

local canFile = type(writefile) == "function"
	and type(readfile) == "function"
	and type(isfile) == "function"

local function saveCfg()
	if not canFile then return end
	pcall(function() writefile(CONFIG_FILE, HttpService:JSONEncode(Cfg)) end)
end

if canFile then
	pcall(function()
		if isfile(CONFIG_FILE) then
			local d = HttpService:JSONDecode(readfile(CONFIG_FILE))
			if type(d) == "table" then
				Cfg.flySpeed  = math.clamp(tonumber(d.flySpeed)  or Cfg.flySpeed,  10, 300)
				Cfg.walkSpeed = math.clamp(tonumber(d.walkSpeed) or Cfg.walkSpeed, 16, 200)
				Cfg.jumpPower = math.clamp(tonumber(d.jumpPower) or Cfg.jumpPower, 50, 300)
				Cfg.fov       = math.clamp(tonumber(d.fov)       or Cfg.fov,       70, 120)
				Cfg.flingTime = math.clamp(tonumber(d.flingTime) or Cfg.flingTime, 1, 6)
				Cfg.farmSpeed = math.clamp(tonumber(d.farmSpeed) or Cfg.farmSpeed, 10, 60)
				Cfg.auraRange = math.clamp(tonumber(d.auraRange) or Cfg.auraRange, 6, 30)
			end
		end
	end)
end

local Conns = {}
local function track(c) table.insert(Conns, c) return c end

local function getRoot()
	local c = Player.Character
	return c and c:FindFirstChild("HumanoidRootPart")
end
local function getHum()
	local c = Player.Character
	return c and c:FindFirstChildOfClass("Humanoid")
end

local T = {
	bg      = Color3.fromRGB(10, 10, 16),
	panel   = Color3.fromRGB(18, 18, 28),
	row     = Color3.fromRGB(24, 24, 38),
	off     = Color3.fromRGB(46, 46, 68),
	text    = Color3.fromRGB(235, 235, 250),
	sub     = Color3.fromRGB(125, 125, 165),
	accent  = Color3.fromRGB(150, 90, 255),
	accent2 = Color3.fromRGB(60, 200, 255),
	good    = Color3.fromRGB(50, 220, 120),
	bad     = Color3.fromRGB(225, 60, 85),
	warn    = Color3.fromRGB(255, 170, 70),
	info    = Color3.fromRGB(70, 140, 255),
	gold    = Color3.fromRGB(255, 205, 60),
}

------------------------------------------------------------------
-- GUI shell
------------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "ApexHubUI"
gui.ResetOnSpawn = false
gui.DisplayOrder = 1000
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local W, H = 370, 372
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(W, H)
main.Position = UDim2.new(0.5, -W/2, 0.42, -H/2)
main.BackgroundColor3 = T.bg
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.new(1, 1, 1)
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.35
mainStroke.Parent = main
local sg = Instance.new("UIGradient")
sg.Color = ColorSequence.new(T.accent, T.accent2)
sg.Rotation = 45
sg.Parent = mainStroke

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = T.panel
header.BorderSizePixel = 0
header.Parent = main
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 14)
local hFix = Instance.new("Frame")
hFix.Size = UDim2.new(1, 0, 0, 14)
hFix.Position = UDim2.new(0, 0, 1, -14)
hFix.BackgroundColor3 = T.panel
hFix.BorderSizePixel = 0
hFix.Parent = header

local accent = Instance.new("Frame")
accent.Size = UDim2.fromOffset(4, 18)
accent.Position = UDim2.fromOffset(12, 11)
accent.BackgroundColor3 = Color3.new(1, 1, 1)
accent.BorderSizePixel = 0
accent.Parent = header
Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)
local ag = Instance.new("UIGradient")
ag.Color = ColorSequence.new(T.accent, T.accent2)
ag.Rotation = 90
ag.Parent = accent

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 120, 1, 0)
title.Position = UDim2.fromOffset(24, 0)
title.BackgroundTransparency = 1
title.Text = "APEX HUB"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 16
title.Font = Enum.Font.GothamBlack
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header
local tg = Instance.new("UIGradient")
tg.Color = ColorSequence.new(T.accent, T.accent2)
tg.Parent = title

local ver = Instance.new("TextLabel")
ver.Size = UDim2.fromOffset(50, 40)
ver.Position = UDim2.new(1, -112, 0, 0)
ver.BackgroundTransparency = 1
ver.Text = "v1.2"
ver.TextColor3 = T.sub
ver.TextSize = 10
ver.Font = Enum.Font.GothamMedium
ver.TextXAlignment = Enum.TextXAlignment.Right
ver.Parent = header

local function topBtn(txt, x)
	local b = Instance.new("TextButton")
	b.Size = UDim2.fromOffset(24, 24)
	b.Position = UDim2.new(1, x, 0.5, -12)
	b.BackgroundColor3 = T.row
	b.Text = txt
	b.TextColor3 = T.text
	b.TextSize = 11
	b.Font = Enum.Font.GothamBold
	b.BorderSizePixel = 0
	b.AutoButtonColor = false
	b.Parent = header
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
	return b
end

local closeBtn = topBtn("✕", -34)
local minBtn   = topBtn("—", -60)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

local minimized = false
minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	TweenService:Create(main, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
		Size = minimized and UDim2.fromOffset(W, 40) or UDim2.fromOffset(W, H)
	}):Play()
end)

local dragging, dragStart, startPos
header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
	end
end)
header.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)
track(UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local d = input.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
	end
end))
track(UserInputService.InputBegan:Connect(function(i, gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.Insert or i.KeyCode == Enum.KeyCode.RightShift then
		main.Visible = not main.Visible
	end
end))

-- status bar
local statusBg = Instance.new("Frame")
statusBg.Size = UDim2.new(1, -20, 0, 28)
statusBg.Position = UDim2.fromOffset(10, 46)
statusBg.BackgroundColor3 = T.panel
statusBg.BorderSizePixel = 0
statusBg.Parent = main
Instance.new("UICorner", statusBg).CornerRadius = UDim.new(0, 8)

local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.fromOffset(7, 7)
statusDot.Position = UDim2.fromOffset(10, 10)
statusDot.BackgroundColor3 = T.good
statusDot.BorderSizePixel = 0
statusDot.Parent = statusBg
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -26, 1, 0)
statusLabel.Position = UDim2.fromOffset(22, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "READY"
statusLabel.TextColor3 = T.text
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = statusBg

local function setStatus(text, color)
	if statusLabel.Parent then statusLabel.Text = text end
	if statusDot.Parent and color then
		TweenService:Create(statusDot, TweenInfo.new(0.12), { BackgroundColor3 = color }):Play()
	end
end

------------------------------------------------------------------
-- UI builders
------------------------------------------------------------------
local UI = { order = 0 }
local pages, tabBtns = {}, {}
local tabOrder = { "PLAYER", "MM2", "FARM", "FLING", "VISUALS", "MISC" }
local Target = { plr = nil }

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -20, 0, 26)
tabBar.Position = UDim2.fromOffset(10, 80)
tabBar.BackgroundTransparency = 1
tabBar.Parent = main

local function showTab(name)
	for n, p in pairs(pages) do p.Visible = (n == name) end
	for n, b in pairs(tabBtns) do
		local on = (n == name)
		b.BackgroundColor3 = on and T.accent or T.panel
		b.TextColor3 = on and Color3.new(1, 1, 1) or T.sub
	end
end

for i, n in ipairs(tabOrder) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1 / #tabOrder, -4, 1, 0)
	b.Position = UDim2.new((i - 1) / #tabOrder, 0, 0, 0)
	b.BackgroundColor3 = T.panel
	b.Text = n
	b.TextColor3 = T.sub
	b.TextSize = 9
	b.Font = Enum.Font.GothamBold
	b.BorderSizePixel = 0
	b.AutoButtonColor = false
	b.Parent = tabBar
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
	b.MouseButton1Click:Connect(function() showTab(n) end)
	tabBtns[n] = b
end

local function newPage(name)
	local p = Instance.new("ScrollingFrame")
	p.Name = name
	p.Size = UDim2.new(1, -20, 1, -118)
	p.Position = UDim2.fromOffset(10, 112)
	p.BackgroundTransparency = 1
	p.BorderSizePixel = 0
	p.ScrollBarThickness = 2
	p.ScrollBarImageColor3 = T.accent
	p.CanvasSize = UDim2.new()
	p.AutomaticCanvasSize = Enum.AutomaticSize.Y
	p.Visible = false
	p.Parent = main
	local l = Instance.new("UIListLayout")
	l.Padding = UDim.new(0, 6)
	l.SortOrder = Enum.SortOrder.LayoutOrder
	l.Parent = p
	pages[name] = p
	return p
end

function UI.next()
	UI.order += 1
	return UI.order
end

function UI.row(parent, h)
	local f = Instance.new("Frame")
	f.Size = UDim2.new(1, -4, 0, h or 34)
	f.BackgroundColor3 = T.row
	f.BorderSizePixel = 0
	f.LayoutOrder = UI.next()
	f.Parent = parent
	Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
	return f
end

function UI.text(parent, text, size, color, font)
	local l = Instance.new("TextLabel")
	l.BackgroundTransparency = 1
	l.Text = text
	l.TextColor3 = color or T.text
	l.TextSize = size or 11
	l.Font = font or Enum.Font.GothamMedium
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.Parent = parent
	return l
end

function UI.section(parent, text)
	local l = UI.text(parent, text, 9, T.sub, Enum.Font.GothamBold)
	l.Size = UDim2.new(1, -4, 0, 14)
	l.LayoutOrder = UI.next()
	return l
end

function UI.flash(b, text)
	local old = b:GetAttribute("label") or b.Text
	b:SetAttribute("label", old)
	b.Text = text
	task.delay(1.2, function()
		if b.Parent then b.Text = old end
	end)
end

function UI.toggle(parent, text, default, cb)
	local f = UI.row(parent)
	local l = UI.text(f, text, 11)
	l.Size = UDim2.new(1, -64, 1, 0)
	l.Position = UDim2.fromOffset(12, 0)

	local pill = Instance.new("TextButton")
	pill.Size = UDim2.fromOffset(38, 20)
	pill.Position = UDim2.new(1, -48, 0.5, -10)
	pill.Text = ""
	pill.BorderSizePixel = 0
	pill.AutoButtonColor = false
	pill.Parent = f
	Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.fromOffset(14, 14)
	knob.BackgroundColor3 = Color3.new(1, 1, 1)
	knob.BorderSizePixel = 0
	knob.Parent = pill
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	local state = default == true
	local function paint()
		TweenService:Create(pill, TweenInfo.new(0.12), {
			BackgroundColor3 = state and T.accent or T.off
		}):Play()
		TweenService:Create(knob, TweenInfo.new(0.12), {
			Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
		}):Play()
	end
	pill.BackgroundColor3 = state and T.accent or T.off
	knob.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)

	pill.MouseButton1Click:Connect(function()
		state = not state
		paint()
		cb(state)
	end)
	return {
		set = function(v)
			state = (v == true)
			paint()
		end,
		get = function() return state end,
	}
end

function UI.button(parent, text, color, cb)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -4, 0, 34)
	b.BackgroundColor3 = color or T.accent
	b.Text = text
	b.TextColor3 = Color3.new(1, 1, 1)
	b.TextSize = 11
	b.Font = Enum.Font.GothamBold
	b.BorderSizePixel = 0
	b.AutoButtonColor = false
	b.LayoutOrder = UI.next()
	b.Parent = parent
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
	b.MouseButton1Click:Connect(function() cb(b) end)
	return b
end

function UI.stepper(parent, text, get, set, step, lo, hi)
	local f = UI.row(parent)
	local l = UI.text(f, "", 11)
	l.Size = UDim2.new(1, -86, 1, 0)
	l.Position = UDim2.fromOffset(12, 0)
	local function refresh() l.Text = text .. "  ·  " .. tostring(get()) end
	local function mk(txt, xOff, d)
		local b = Instance.new("TextButton")
		b.Size = UDim2.fromOffset(28, 24)
		b.Position = UDim2.new(1, xOff, 0.5, -12)
		b.BackgroundColor3 = T.panel
		b.Text = txt
		b.TextColor3 = T.text
		b.TextSize = 14
		b.Font = Enum.Font.GothamBold
		b.BorderSizePixel = 0
		b.AutoButtonColor = false
		b.Parent = f
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
		b.MouseButton1Click:Connect(function()
			set(math.clamp(get() + d, lo, hi))
			refresh()
		end)
	end
	mk("-", -68, -step)
	mk("+", -36, step)
	refresh()
end

function UI.info(parent, h)
	local f = UI.row(parent, h or 44)
	local l = UI.text(f, "", 11)
	l.Size = UDim2.new(1, -24, 1, 0)
	l.Position = UDim2.fromOffset(12, 0)
	l.TextWrapped = true
	return l
end

function UI.cycler(parent)
	local f = UI.row(parent)
	local l = UI.text(f, "", 11)
	l.Size = UDim2.new(1, -80, 1, 0)
	l.Position = UDim2.fromOffset(12, 0)
	l.TextTruncate = Enum.TextTruncate.AtEnd

	local idx = 1
	local function apply(d)
		local list = {}
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= Player then table.insert(list, p) end
		end
		if #list == 0 then
			Target.plr = nil
			l.Text = "TARGET  ·  —"
			return
		end
		idx = ((idx - 1 + d) % #list) + 1
		Target.plr = list[idx]
		l.Text = "TARGET  ·  " .. list[idx].Name
	end
	local function mk(txt, xOff, d)
		local b = Instance.new("TextButton")
		b.Size = UDim2.fromOffset(28, 24)
		b.Position = UDim2.new(1, xOff, 0.5, -12)
		b.BackgroundColor3 = T.panel
		b.Text = txt
		b.TextColor3 = T.text
		b.TextSize = 14
		b.Font = Enum.Font.GothamBold
		b.BorderSizePixel = 0
		b.AutoButtonColor = false
		b.Parent = f
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
		b.MouseButton1Click:Connect(function() apply(d) end)
	end
	mk("‹", -68, -1)
	mk("›", -36, 1)
	track(Players.PlayerAdded:Connect(function() task.delay(0.2, apply, 0) end))
	track(Players.PlayerRemoving:Connect(function() task.delay(0.2, apply, 0) end))
	apply(0)
end

------------------------------------------------------------------
-- Features: movement (fly / noclip / speed / jump / click tp)
------------------------------------------------------------------
local Fly  = { on = false, up = false, down = false }
local Move = { noclip = false, speed = false, jump = false, infJump = false, clickTp = false,
	origSpeed = 16, origJump = 50 }
local afkOn = false

do
	local bv, bg

	local function stopFly()
		if bv then bv:Destroy() bv = nil end
		if bg then bg:Destroy() bg = nil end
		local h = getHum()
		if h then h.PlatformStand = false end
	end

	-- ▲ ▼ pad for touch (PC: Space / Shift)
	local flyPad = Instance.new("Frame")
	flyPad.Size = UDim2.fromOffset(52, 108)
	flyPad.Position = UDim2.new(1, -66, 0.5, -54)
	flyPad.BackgroundTransparency = 1
	flyPad.Visible = false
	flyPad.Parent = gui

	local function padBtn(txt, y, key)
		local b = Instance.new("TextButton")
		b.Size = UDim2.fromOffset(52, 50)
		b.Position = UDim2.fromOffset(0, y)
		b.BackgroundColor3 = T.panel
		b.BackgroundTransparency = 0.15
		b.Text = txt
		b.TextColor3 = T.text
		b.TextSize = 18
		b.Font = Enum.Font.GothamBold
		b.BorderSizePixel = 0
		b.AutoButtonColor = false
		b.Parent = flyPad
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
		local st = Instance.new("UIStroke")
		st.Color = T.accent
		st.Thickness = 1.2
		st.Parent = b
		b.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				Fly[key] = true
			end
		end)
		b.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				Fly[key] = false
			end
		end)
	end
	padBtn("▲", 0, "up")
	padBtn("▼", 58, "down")

	function Fly.set(v)
		Fly.on = v
		Fly.up, Fly.down = false, false
		flyPad.Visible = v
		if not v then stopFly() end
	end

	track(RunService.RenderStepped:Connect(function()
		if not Fly.on then return end
		local root, cam = getRoot(), Workspace.CurrentCamera
		local hum = getHum()
		if not (root and hum and cam) then return end

		if not bv or bv.Parent ~= root then
			if bv then bv:Destroy() end
			if bg then bg:Destroy() end
			bv = Instance.new("BodyVelocity")
			bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
			bv.Velocity = Vector3.zero
			bv.Parent = root
			bg = Instance.new("BodyGyro")
			bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
			bg.P = 1e4
			bg.Parent = root
		end
		hum.PlatformStand = true

		local cf = cam.CFrame
		local md = hum.MoveDirection
		local fl = Vector3.new(cf.LookVector.X, 0, cf.LookVector.Z)
		local fr = Vector3.new(cf.RightVector.X, 0, cf.RightVector.Z)
		local f = fl.Magnitude > 0.01 and md:Dot(fl.Unit) or 0
		local r = fr.Magnitude > 0.01 and md:Dot(fr.Unit) or 0
		local dir = cf.LookVector * f + cf.RightVector * r

		local ud = 0
		if Fly.up or UserInputService:IsKeyDown(Enum.KeyCode.Space) then ud += 1 end
		if Fly.down or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then ud -= 1 end

		bv.Velocity = (dir + Vector3.new(0, ud, 0)) * Cfg.flySpeed
		bg.CFrame = cf
	end))

	track(RunService.Stepped:Connect(function()
		if not Move.noclip then return end
		local c = Player.Character
		if not c then return end
		for _, p in ipairs(c:GetDescendants()) do
			if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
		end
	end))

	track(RunService.Heartbeat:Connect(function()
		local h = getHum()
		if not h then return end
		if Move.speed then h.WalkSpeed = Cfg.walkSpeed end
		if Move.jump then
			h.UseJumpPower = true
			h.JumpPower = Cfg.jumpPower
		end
	end))

	track(UserInputService.JumpRequest:Connect(function()
		if not Move.infJump then return end
		local h = getHum()
		if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
	end))

	function Move.setSpeed(v)
		local h = getHum()
		local was = Move.speed
		if v and not was and h then Move.origSpeed = h.WalkSpeed end
		Move.speed = v
		if was and not v and h then h.WalkSpeed = Move.origSpeed end
	end

	function Move.setJump(v)
		local h = getHum()
		local was = Move.jump
		if v and not was and h then Move.origJump = h.JumpPower end
		Move.jump = v
		if was and not v and h then h.JumpPower = Move.origJump end
	end

	-- Ctrl + Click teleport (PC)
	local mouse = Player:GetMouse()
	track(UserInputService.InputBegan:Connect(function(i, gp)
		if gp or not Move.clickTp then return end
		if i.UserInputType == Enum.UserInputType.MouseButton1
			and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
			local root = getRoot()
			if root and mouse.Hit then
				root.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
			end
		end
	end))

	track(Player.Idled:Connect(function()
		if not afkOn then return end
		pcall(function()
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new())
		end)
	end))
end

------------------------------------------------------------------
-- Features: MM2 (role = owner of Knife / Gun tool)
-- ban risk on main account, use an alt
------------------------------------------------------------------
local MM2 = { esp = false, gunEsp = false, gunAlert = false, autoShoot = false, autoGrab = false,
	aura = false, camLock = false, mur = nil, she = nil }
local espHL = {}
local gunHL

function MM2.hasTool(plr, name)
	local bp, ch = plr:FindFirstChild("Backpack"), plr.Character
	return (bp and bp:FindFirstChild(name)) or (ch and ch:FindFirstChild(name)) or nil
end

function MM2.roles()
	local mur, she
	for _, plr in ipairs(Players:GetPlayers()) do
		if MM2.hasTool(plr, "Knife") then mur = plr end
		if MM2.hasTool(plr, "Gun") then she = plr end
	end
	return mur, she
end

function MM2.shoot()
	local mur = MM2.roles()
	if not mur then return false, "no murderer" end
	local tRoot = mur.Character and mur.Character:FindFirstChild("HumanoidRootPart")
	if not tRoot then return false, "murderer dead" end
	local gun = MM2.hasTool(Player, "Gun")
	if not gun then return false, "no gun" end

	local ch, hum = Player.Character, getHum()
	if gun.Parent ~= ch and hum then
		hum:EquipTool(gun)
		task.wait(0.15)
	end

	local pos = tRoot.Position + tRoot.AssemblyLinearVelocity * 0.1
	local ok = pcall(function()
		gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(1, pos, "AH2")
	end)
	return ok, ok and "shot" or "remote failed"
end

function MM2.gunDrop()
	local drop = Workspace:FindFirstChild("GunDrop", true)
	if not drop then return nil end
	local part = drop:IsA("BasePart") and drop or drop:FindFirstChildWhichIsA("BasePart", true)
	return drop, part
end

function MM2.grabGun()
	local _, part = MM2.gunDrop()
	local root = getRoot()
	if not (part and root) then return false, "no gun drop" end
	if type(firetouchinterest) == "function" then
		firetouchinterest(root, part, 0)
		task.wait()
		firetouchinterest(root, part, 1)
	else
		local back = root.CFrame
		root.CFrame = part.CFrame
		task.wait(0.25)
		root.CFrame = back
	end
	return true, "grabbed"
end

function MM2.clearEsp()
	for _, h in pairs(espHL) do pcall(function() h:Destroy() end) end
	table.clear(espHL)
end

function MM2.clearGunEsp()
	if gunHL then pcall(function() gunHL:Destroy() end) gunHL = nil end
end

function MM2.alive(plr)
	local h = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
	return h ~= nil and h.Health > 0
end

-- stab remote + touch on knife handle (remote / handle names not verified)
function MM2.hit(plr)
	local knife = MM2.hasTool(Player, "Knife")
	if not knife then return false, "not murderer" end
	local tRoot = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
	if not tRoot then return false, "no target" end
	local ch, hum = Player.Character, getHum()
	if knife.Parent ~= ch and hum then
		hum:EquipTool(knife)
		task.wait(0.1)
	end
	local ev = knife:FindFirstChild("Stab")
	if ev and ev:IsA("RemoteEvent") then
		pcall(function() ev:FireServer("Slash") end)
	end
	local handle = knife:FindFirstChild("Handle")
	if handle and type(firetouchinterest) == "function" then
		pcall(function()
			firetouchinterest(handle, tRoot, 0)
			firetouchinterest(handle, tRoot, 1)
		end)
	end
	return true, "stab"
end

function MM2.killAll()
	if not MM2.hasTool(Player, "Knife") then return false, "not murderer" end
	local root = getRoot()
	if not root then return false, "no char" end
	local back = root.CFrame
	for _, plr in ipairs(Players:GetPlayers()) do
		local tRoot = plr ~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
		if tRoot and MM2.alive(plr) then
			local r = getRoot()
			if not r then break end
			r.CFrame = tRoot.CFrame * CFrame.new(0, 0, 2)
			MM2.hit(plr)
			task.wait(0.25)
		end
	end
	local r = getRoot()
	if r then r.CFrame = back end
	return true, "done"
end

-- map = workspace model that holds CoinContainer (name not verified)
function MM2.map()
	for _, c in ipairs(Workspace:GetChildren()) do
		if c:IsA("Model") and c:FindFirstChild("CoinContainer") then return c end
	end
	return nil
end

function MM2.coins()
	local m = MM2.map()
	local cc = m and m:FindFirstChild("CoinContainer")
	local t = {}
	if not cc then return t end
	for _, c in ipairs(cc:GetChildren()) do
		if c:IsA("BasePart") then table.insert(t, c) end
	end
	return t
end

local function tpTo(container)
	local root = getRoot()
	if not (container and root) then return false end
	local spawns = container:FindFirstChild("Spawns")
	local part = spawns and spawns:FindFirstChildWhichIsA("BasePart", true)
	local cf = part and part.CFrame or (container:IsA("Model") and container:GetPivot())
	if not cf then return false end
	root.CFrame = cf + Vector3.new(0, 5, 0)
	return true
end
function MM2.tpMap()
	return tpTo(MM2.map()), "no map"
end
function MM2.tpLobby()
	return tpTo(Workspace:FindFirstChild("Lobby")), "no lobby"
end

-- aimbot-style camera lock: murderer (or nearest player if you are the murderer)
RunService:BindToRenderStep("ApexCamLock", Enum.RenderPriority.Camera.Value + 1, function()
	if not MM2.camLock then return end
	local cam, root = Workspace.CurrentCamera, getRoot()
	if not (cam and root) then return end
	local tgt
	if MM2.mur and MM2.mur ~= Player then
		tgt = MM2.mur
	else
		local best = math.huge
		for _, plr in ipairs(Players:GetPlayers()) do
			local r = plr ~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
			if r and MM2.alive(plr) then
				local d = (r.Position - root.Position).Magnitude
				if d < best then best, tgt = d, plr end
			end
		end
	end
	local tRoot = tgt and tgt.Character and tgt.Character:FindFirstChild("HumanoidRootPart")
	if tRoot then
		cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, tRoot.Position), 0.35)
	end
end)

-- kill aura (murderer)
task.spawn(function()
	while gui.Parent do
		if MM2.aura and MM2.hasTool(Player, "Knife") then
			local root = getRoot()
			if root then
				for _, plr in ipairs(Players:GetPlayers()) do
					local tRoot = plr ~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
					if tRoot and MM2.alive(plr)
						and (tRoot.Position - root.Position).Magnitude <= Cfg.auraRange then
						pcall(MM2.hit, plr)
					end
				end
			end
		end
		task.wait(0.2)
	end
end)

local function updateEsp(mur, she)
	for plr, h in pairs(espHL) do
		if plr.Parent == nil then h:Destroy() espHL[plr] = nil end
	end
	for _, plr in ipairs(Players:GetPlayers()) do
		local ch = plr.Character
		if plr ~= Player and ch then
			local h = espHL[plr]
			if not h or h.Parent ~= ch then
				if h then h:Destroy() end
				h = Instance.new("Highlight")
				h.FillTransparency = 0.5
				h.OutlineTransparency = 0
				h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				h.Parent = ch
				espHL[plr] = h
			end
			local col = (plr == mur and T.bad) or (plr == she and T.info) or T.good
			h.FillColor = col
			h.OutlineColor = col
		end
	end
end

------------------------------------------------------------------
-- Features: fling (spin + sit on target root, then restore)
------------------------------------------------------------------
local Fling = { busy = false, anti = false }

function Fling.run(plr, duration)
	if Fling.busy then return false, "busy" end
	if Fly.on then return false, "fly off first" end
	local root = getRoot()
	local tRoot = plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
	if not (root and tRoot) then return false, "no target" end

	Fling.busy = true
	local back = root.CFrame
	local prevNoclip = Move.noclip
	Move.noclip = true
	local flung = false
	local t0 = os.clock()

	while (os.clock() - t0) < (duration or Cfg.flingTime) do
		root = getRoot()
		tRoot = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
		if not (root and tRoot) then break end
		root.CFrame = tRoot.CFrame
		root.AssemblyLinearVelocity = Vector3.new(5e4, 5e4, 5e4)
		root.AssemblyAngularVelocity = Vector3.new(0, 5e4, 0)
		RunService.Heartbeat:Wait()
		if tRoot.AssemblyLinearVelocity.Magnitude > 400 then
			flung = true
			break
		end
	end

	root = getRoot()
	if root then
		for _ = 1, 12 do
			root.AssemblyLinearVelocity = Vector3.zero
			root.AssemblyAngularVelocity = Vector3.zero
			root.CFrame = back
			RunService.Heartbeat:Wait()
		end
	end
	Move.noclip = prevNoclip
	Fling.busy = false
	return true, flung and "flung" or "done"
end

function Fling.role(which)
	local mur, she = MM2.roles()
	local plr = (which == "murderer") and mur or she
	if not plr then return false, "no " .. which end
	if plr == Player then return false, "that's you" end
	return Fling.run(plr)
end

function Fling.all()
	if Fling.busy then return false, "busy" end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= Player then
			Fling.run(plr, math.min(Cfg.flingTime, 1.5))
		end
	end
	return true, "done"
end

-- anti-fling: ghost other players' collisions, kill own spin
track(RunService.Stepped:Connect(function()
	if not Fling.anti then return end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= Player and plr.Character then
			for _, p in ipairs(plr.Character:GetChildren()) do
				if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
			end
		end
	end
	local root = getRoot()
	if root and not Fling.busy and root.AssemblyAngularVelocity.Magnitude > 200 then
		root.AssemblyAngularVelocity = Vector3.zero
		root.AssemblyLinearVelocity = Vector3.zero
	end
end))

------------------------------------------------------------------
-- Features: visuals (fullbright / fov / spectate)
------------------------------------------------------------------
local Vis = { fb = false, fov = false, spec = false, fbOrig = nil, fovOrig = 70 }

do
	function Vis.setFb(v)
		if v and not Vis.fb then
			Vis.fbOrig = {
				Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
				FogEnd = Lighting.FogEnd, GlobalShadows = Lighting.GlobalShadows,
				Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
			}
		end
		local was = Vis.fb
		Vis.fb = v
		if was and not v and Vis.fbOrig then
			for k, val in pairs(Vis.fbOrig) do pcall(function() Lighting[k] = val end) end
		end
	end

	function Vis.setFov(v)
		local cam = Workspace.CurrentCamera
		if v and not Vis.fov and cam then Vis.fovOrig = cam.FieldOfView end
		local was = Vis.fov
		Vis.fov = v
		if was and not v and cam then cam.FieldOfView = Vis.fovOrig end
	end

	function Vis.setSpec(v)
		local cam = Workspace.CurrentCamera
		if not cam then return false end
		if v then
			local h = Target.plr and Target.plr.Character
				and Target.plr.Character:FindFirstChildOfClass("Humanoid")
			if not h then return false end
			cam.CameraSubject = h
			Vis.spec = true
			return true
		end
		Vis.spec = false
		local own = getHum()
		if own then cam.CameraSubject = own end
		return true
	end

	track(RunService.Heartbeat:Connect(function()
		if Vis.fb then
			Lighting.Brightness = 2
			Lighting.ClockTime = 14
			Lighting.FogEnd = 1e5
			Lighting.GlobalShadows = false
			Lighting.Ambient = Color3.fromRGB(178, 178, 178)
			Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
		end
	end))

	track(RunService.RenderStepped:Connect(function()
		local cam = Workspace.CurrentCamera
		if not cam then return end
		if Vis.fov then cam.FieldOfView = Cfg.fov end
		if Vis.spec then
			local h = Target.plr and Target.plr.Character
				and Target.plr.Character:FindFirstChildOfClass("Humanoid")
			if h and cam.CameraSubject ~= h then cam.CameraSubject = h end
		end
	end))
end

------------------------------------------------------------------
-- Features: farm / xray / tracers / name tags / fps
------------------------------------------------------------------
local Farm    = { on = false, count = 0, esp = false, prevNoclip = false }
local Xray    = { on = false, parts = {}, map = nil }
local Tracers = { on = false, lines = {} }
local Names   = { on = false, tags = {} }
local coinAdorn = {}

function Farm.set(v)
	if v == Farm.on then return end
	Farm.on = v
	if v then
		Farm.prevNoclip = Move.noclip
		Move.noclip = true
	else
		Move.noclip = Farm.prevNoclip
	end
end

-- coin farm: tween to nearest coin (map must have CoinContainer)
task.spawn(function()
	while gui.Parent do
		if Farm.on then
			local root, hum = getRoot(), getHum()
			local coins = MM2.coins()
			if root and hum and hum.Health > 0 and #coins > 0 then
				table.sort(coins, function(a, b)
					return (a.Position - root.Position).Magnitude < (b.Position - root.Position).Magnitude
				end)
				local c = coins[1]
				local dist = (c.Position - root.Position).Magnitude
				local dur = math.max(dist / Cfg.farmSpeed, 0.05)
				local tw = TweenService:Create(root, TweenInfo.new(dur, Enum.EasingStyle.Linear),
					{ CFrame = CFrame.new(c.Position) })
				tw:Play()
				local t0 = os.clock()
				while Farm.on and c.Parent and (os.clock() - t0) < dur + 0.1 do task.wait() end
				tw:Cancel()
				local r = getRoot()
				if r and c.Parent and type(firetouchinterest) == "function" then
					pcall(function()
						firetouchinterest(r, c, 0)
						firetouchinterest(r, c, 1)
					end)
				end
				if not c.Parent then Farm.count += 1 end
				task.wait(0.05)
			else
				task.wait(0.5)
			end
		else
			task.wait(0.3)
		end
	end
end)

local function updateCoinEsp()
	local seen = {}
	for _, c in ipairs(MM2.coins()) do
		seen[c] = true
		if not coinAdorn[c] then
			local a = Instance.new("BoxHandleAdornment")
			a.Adornee = c
			a.Size = Vector3.new(1.6, 1.6, 0.6)
			a.AlwaysOnTop = true
			a.ZIndex = 5
			a.Transparency = 0.35
			a.Color3 = T.gold
			a.Parent = c
			coinAdorn[c] = a
		end
	end
	for c, a in pairs(coinAdorn) do
		if not seen[c] then a:Destroy() coinAdorn[c] = nil end
	end
end
local function clearCoinEsp()
	for _, a in pairs(coinAdorn) do pcall(function() a:Destroy() end) end
	table.clear(coinAdorn)
end

-- name + role + distance tags
local function updateNames(mur, she)
	for plr, g in pairs(Names.tags) do
		if plr.Parent == nil then g:Destroy() Names.tags[plr] = nil end
	end
	local myRoot = getRoot()
	for _, plr in ipairs(Players:GetPlayers()) do
		local head = plr.Character and plr.Character:FindFirstChild("Head")
		if plr ~= Player and head then
			local g = Names.tags[plr]
			if not g or g.Parent ~= head then
				if g then g:Destroy() end
				g = Instance.new("BillboardGui")
				g.Size = UDim2.fromOffset(140, 32)
				g.StudsOffset = Vector3.new(0, 2.5, 0)
				g.AlwaysOnTop = true
				g.Parent = head
				local t = Instance.new("TextLabel")
				t.Name = "L"
				t.Size = UDim2.new(1, 0, 1, 0)
				t.BackgroundTransparency = 1
				t.TextSize = 11
				t.Font = Enum.Font.GothamBold
				t.TextStrokeTransparency = 0.4
				t.Parent = g
				Names.tags[plr] = g
			end
			local role = (plr == mur and "MURDERER") or (plr == she and "SHERIFF") or "INNOCENT"
			local col = (plr == mur and T.bad) or (plr == she and T.info) or T.good
			local dist = myRoot and math.floor((head.Position - myRoot.Position).Magnitude) or 0
			local l = g:FindFirstChild("L")
			if l then
				l.Text = plr.Name .. "\n" .. role .. "  ·  " .. dist .. "m"
				l.TextColor3 = col
			end
		end
	end
end
local function clearNames()
	for _, g in pairs(Names.tags) do pcall(function() g:Destroy() end) end
	table.clear(Names.tags)
end

-- tracers (needs executor Drawing API)
local function clearTracers()
	for _, l in pairs(Tracers.lines) do pcall(function() l:Remove() end) end
	table.clear(Tracers.lines)
end
track(RunService.RenderStepped:Connect(function()
	if not Tracers.on or type(Drawing) ~= "table" then return end
	local cam = Workspace.CurrentCamera
	if not cam then return end
	local vp = cam.ViewportSize
	for plr, l in pairs(Tracers.lines) do
		if plr.Parent == nil then pcall(function() l:Remove() end) Tracers.lines[plr] = nil end
	end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= Player then
			local r = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
			local l = Tracers.lines[plr]
			if not l then
				l = Drawing.new("Line")
				l.Thickness = 1.5
				l.Transparency = 1
				Tracers.lines[plr] = l
			end
			if r then
				local p, onScreen = cam:WorldToViewportPoint(r.Position)
				l.Visible = onScreen
				if onScreen then
					l.From = Vector2.new(vp.X / 2, vp.Y)
					l.To = Vector2.new(p.X, p.Y)
					l.Color = (plr == MM2.mur and T.bad) or (plr == MM2.she and T.info) or T.good
				end
			else
				l.Visible = false
			end
		end
	end
end))

-- x-ray: local transparency on map parts, re-applied when the map changes
function Xray.restore()
	for p in pairs(Xray.parts) do
		if p.Parent then p.LocalTransparencyModifier = 0 end
	end
	table.clear(Xray.parts)
	Xray.map = nil
end
function Xray.apply()
	local m = MM2.map()
	if m == Xray.map then return end
	Xray.restore()
	Xray.map = m
	if not m then return end
	for _, p in ipairs(m:GetDescendants()) do
		if p:IsA("BasePart") and p.Transparency < 0.6 then
			Xray.parts[p] = true
			p.LocalTransparencyModifier = 0.6
		end
	end
end

function Vis.fpsBoost()
	pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
	Lighting.GlobalShadows = false
	for _, e in ipairs(Lighting:GetChildren()) do
		if e:IsA("PostEffect") then e.Enabled = false end
		if e:IsA("Atmosphere") then e.Density = 0 end
	end
	for _, d in ipairs(Workspace:GetDescendants()) do
		if d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Smoke") or d:IsA("Fire") then
			d.Enabled = false
		end
	end
end

------------------------------------------------------------------
-- Features: misc (queue self, waypoint, rejoin, server hop)
------------------------------------------------------------------
local Misc = { wp = nil }

local function queueSelf()
	local q = (type(queue_on_teleport) == "function" and queue_on_teleport)
		or (syn and type(syn.queue_on_teleport) == "function" and syn.queue_on_teleport)
	if not q then return end
	local inject = [[
		task.defer(function()
			if not game:IsLoaded() then game.Loaded:Wait() end
			local names = {"apex_hub.lua","ApexHub.lua","auto hop.lua","auto_hop.lua"}
			for _, n in ipairs(names) do
				if type(isfile)=="function" and isfile(n) then
					local fn = loadstring(readfile(n))
					if fn then task.spawn(fn) return end
				end
			end
		end)
	]]
	pcall(q, inject)
end

function Misc.serverHop()
	local url = "https://games.roblox.com/v1/games/" .. game.PlaceId
		.. "/servers/Public?sortOrder=Asc&excludeFullGames=true&limit=100"
	local req = (syn and syn.request) or request or http_request or (http and http.request)
	local body
	if req then
		local ok, res = pcall(req, { Url = url, Method = "GET" })
		body = ok and res and res.Body or nil
	else
		local ok, b = pcall(game.HttpGet, game, url)
		body = ok and b or nil
	end
	if not body then return false, "http failed" end
	local ok, data = pcall(HttpService.JSONDecode, HttpService, body)
	if not (ok and type(data) == "table" and data.data) then return false, "bad response" end
	local list = {}
	for _, s in ipairs(data.data) do
		if s.id ~= game.JobId and s.playing and s.maxPlayers and s.playing < s.maxPlayers - 1 then
			table.insert(list, s.id)
		end
	end
	if #list == 0 then return false, "no servers" end
	queueSelf()
	pcall(function()
		TeleportService:TeleportToPlaceInstance(game.PlaceId, list[math.random(#list)], Player)
	end)
	return true, "hopping"
end

gui.Destroying:Connect(function()
	for _, c in ipairs(Conns) do pcall(function() c:Disconnect() end) end
	Fly.set(false)
	Move.setSpeed(false)
	Move.setJump(false)
	Vis.setFb(false)
	Vis.setFov(false)
	Vis.setSpec(false)
	MM2.clearEsp()
	MM2.clearGunEsp()
	Farm.set(false)
	Xray.on = false
	Xray.restore()
	Tracers.on = false
	clearTracers()
	Names.on = false
	clearNames()
	clearCoinEsp()
	pcall(function() RunService:UnbindFromRenderStep("ApexCamLock") end)
end)

------------------------------------------------------------------
-- Pages
------------------------------------------------------------------
-- PLAYER ----------------------------------------------------------
local pPlayer = newPage("PLAYER")
UI.toggle(pPlayer, "FLY", false, function(v) Fly.set(v) end)
UI.stepper(pPlayer, "FLY SPEED",
	function() return Cfg.flySpeed end,
	function(v) Cfg.flySpeed = v end, 10, 10, 300)
UI.toggle(pPlayer, "NOCLIP", false, function(v) Move.noclip = v end)
UI.toggle(pPlayer, "WALKSPEED", false, function(v) Move.setSpeed(v) end)
UI.stepper(pPlayer, "SPEED VALUE",
	function() return Cfg.walkSpeed end,
	function(v) Cfg.walkSpeed = v end, 4, 16, 200)
UI.toggle(pPlayer, "JUMP POWER", false, function(v) Move.setJump(v) end)
UI.stepper(pPlayer, "JUMP VALUE",
	function() return Cfg.jumpPower end,
	function(v) Cfg.jumpPower = v end, 10, 50, 300)
UI.toggle(pPlayer, "INFINITE JUMP", false, function(v) Move.infJump = v end)
UI.toggle(pPlayer, "CLICK TP  (CTRL + CLICK)", false, function(v) Move.clickTp = v end)

-- MM2 -------------------------------------------------------------
local pMM2 = newPage("MM2")
local roleInfo = UI.info(pMM2, 44)
UI.button(pMM2, "SHOOT MURDERER", T.bad, function(b)
	task.spawn(function()
		local ok, msg = MM2.shoot()
		UI.flash(b, ok and "SHOT ✓" or string.upper(msg))
	end)
end)
UI.button(pMM2, "GRAB GUN", T.info, function(b)
	task.spawn(function()
		local ok, msg = MM2.grabGun()
		UI.flash(b, ok and "GRABBED ✓" or string.upper(msg))
	end)
end)
UI.toggle(pMM2, "ROLE ESP", false, function(v)
	MM2.esp = v
	if not v then MM2.clearEsp() end
end)
UI.toggle(pMM2, "GUN DROP ESP", false, function(v)
	MM2.gunEsp = v
	if not v then MM2.clearGunEsp() end
end)
UI.toggle(pMM2, "GUN DROP ALERT", false, function(v) MM2.gunAlert = v end)
UI.toggle(pMM2, "AUTO SHOOT (SHERIFF)", false, function(v) MM2.autoShoot = v end)
UI.toggle(pMM2, "AUTO GRAB GUN", false, function(v) MM2.autoGrab = v end)
UI.section(pMM2, "MURDERER")
UI.button(pMM2, "KILL ALL", T.bad, function(b)
	task.spawn(function()
		local ok, msg = MM2.killAll()
		UI.flash(b, string.upper(msg))
	end)
end)
UI.toggle(pMM2, "KILL AURA", false, function(v) MM2.aura = v end)
UI.stepper(pMM2, "AURA RANGE",
	function() return Cfg.auraRange end,
	function(v) Cfg.auraRange = v end, 2, 6, 30)
UI.section(pMM2, "AIM / TELEPORT")
UI.toggle(pMM2, "CAMERA LOCK", false, function(v) MM2.camLock = v end)
UI.button(pMM2, "TP TO MAP", T.panel, function(b)
	local ok, msg = MM2.tpMap()
	UI.flash(b, ok and "TP ✓" or string.upper(msg))
end)
UI.button(pMM2, "TP TO LOBBY", T.panel, function(b)
	local ok, msg = MM2.tpLobby()
	UI.flash(b, ok and "TP ✓" or string.upper(msg))
end)

-- FARM ------------------------------------------------------------
local pFarm = newPage("FARM")
local farmInfo = UI.info(pFarm, 44)
UI.toggle(pFarm, "AUTO FARM COINS", false, function(v) Farm.set(v) end)
UI.stepper(pFarm, "FARM SPEED",
	function() return Cfg.farmSpeed end,
	function(v) Cfg.farmSpeed = v end, 2, 10, 60)
UI.toggle(pFarm, "COIN ESP", false, function(v)
	Farm.esp = v
	if not v then clearCoinEsp() end
end)
UI.button(pFarm, "RESET COUNTER", T.panel, function(b)
	Farm.count = 0
	UI.flash(b, "RESET ✓")
end)

-- FLING -----------------------------------------------------------
local pFling = newPage("FLING")
UI.button(pFling, "FLING SHERIFF", T.info, function(b)
	task.spawn(function()
		local ok, msg = Fling.role("sheriff")
		UI.flash(b, ok and string.upper(msg) or string.upper(msg))
	end)
end)
UI.button(pFling, "FLING MURDERER", T.bad, function(b)
	task.spawn(function()
		local ok, msg = Fling.role("murderer")
		UI.flash(b, string.upper(msg))
	end)
end)
UI.button(pFling, "FLING ALL", T.warn, function(b)
	task.spawn(function()
		local ok, msg = Fling.all()
		UI.flash(b, string.upper(msg))
	end)
end)
UI.stepper(pFling, "FLING TIME (S)",
	function() return Cfg.flingTime end,
	function(v) Cfg.flingTime = v end, 0.5, 1, 6)
UI.toggle(pFling, "ANTI-FLING", false, function(v) Fling.anti = v end)

UI.section(pFling, "TARGET")
UI.cycler(pFling)
UI.button(pFling, "FLING TARGET", T.accent, function(b)
	task.spawn(function()
		local ok, msg = Fling.run(Target.plr)
		UI.flash(b, string.upper(msg))
	end)
end)
UI.button(pFling, "TP TO TARGET", T.panel, function(b)
	local root = getRoot()
	local tRoot = Target.plr and Target.plr.Character and Target.plr.Character:FindFirstChild("HumanoidRootPart")
	if root and tRoot then
		root.CFrame = tRoot.CFrame * CFrame.new(0, 0, 3)
		UI.flash(b, "TP ✓")
	else
		UI.flash(b, "NO TARGET")
	end
end)
local specToggle
specToggle = UI.toggle(pFling, "SPECTATE TARGET", false, function(v)
	local ok = Vis.setSpec(v)
	if v and not ok then specToggle.set(false) end
end)

-- VISUALS ---------------------------------------------------------
local pVis = newPage("VISUALS")
UI.toggle(pVis, "FULLBRIGHT", false, function(v) Vis.setFb(v) end)
UI.toggle(pVis, "FOV CHANGER", false, function(v) Vis.setFov(v) end)
UI.stepper(pVis, "FOV VALUE",
	function() return Cfg.fov end,
	function(v) Cfg.fov = v end, 5, 70, 120)
UI.toggle(pVis, "NAME ESP (ROLE + DIST)", false, function(v)
	Names.on = v
	if not v then clearNames() end
end)
local tracerToggle
tracerToggle = UI.toggle(pVis, "TRACERS", false, function(v)
	if v and type(Drawing) ~= "table" then
		tracerToggle.set(false)
		setStatus("NO DRAWING API", T.warn)
		return
	end
	Tracers.on = v
	if not v then clearTracers() end
end)
UI.toggle(pVis, "X-RAY MAP", false, function(v)
	Xray.on = v
	if v then pcall(Xray.apply) else Xray.restore() end
end)
UI.button(pVis, "FPS BOOST", T.info, function(b)
	Vis.fpsBoost()
	UI.flash(b, "BOOSTED ✓")
end)

-- MISC ------------------------------------------------------------
local pMisc = newPage("MISC")
UI.toggle(pMisc, "ANTI-AFK", false, function(v) afkOn = v end)
UI.button(pMisc, "SET WAYPOINT", T.panel, function(b)
	local root = getRoot()
	if root then
		Misc.wp = root.CFrame
		UI.flash(b, "SAVED ✓")
	end
end)
UI.button(pMisc, "TP TO WAYPOINT", T.panel, function(b)
	local root = getRoot()
	if root and Misc.wp then
		root.CFrame = Misc.wp
		UI.flash(b, "TP ✓")
	else
		UI.flash(b, "NO WAYPOINT")
	end
end)
UI.button(pMisc, "SERVER HOP", T.info, function(b)
	task.spawn(function()
		local ok, msg = Misc.serverHop()
		UI.flash(b, string.upper(msg))
	end)
end)
UI.button(pMisc, "REJOIN", T.info, function()
	queueSelf()
	pcall(function() TeleportService:Teleport(game.PlaceId, Player) end)
end)
UI.button(pMisc, "RESET CHARACTER", T.warn, function()
	local h = getHum()
	if h then h.Health = 0 end
end)
UI.button(pMisc, "SAVE CONFIG", T.accent, function(b)
	saveCfg()
	UI.flash(b, "SAVED ✓")
end)
UI.button(pMisc, "DESTROY HUB", T.bad, function() gui:Destroy() end)

showTab("PLAYER")

------------------------------------------------------------------
-- Loop
------------------------------------------------------------------
task.spawn(function()
	local lastShot, dropSeen = 0, false
	while gui.Parent do
		local mur, she = MM2.roles()
		roleInfo.Text = "MURDERER  ·  " .. (mur and mur.Name or "—")
			.. "\nSHERIFF  ·  " .. (she and she.Name or "—")

		MM2.mur, MM2.she = mur, she
		if MM2.esp then pcall(updateEsp, mur, she) end
		if Names.on then pcall(updateNames, mur, she) end
		if Farm.esp then pcall(updateCoinEsp) end
		if Xray.on then pcall(Xray.apply) end
		local curMap = MM2.map()
		farmInfo.Text = "COINS  ·  " .. Farm.count .. "\nMAP  ·  " .. (curMap and curMap.Name or "—")

		local drop = MM2.gunDrop()
		if MM2.gunEsp and drop then
			if not gunHL or gunHL.Parent ~= drop then
				MM2.clearGunEsp()
				gunHL = Instance.new("Highlight")
				gunHL.FillColor = T.gold
				gunHL.OutlineColor = T.gold
				gunHL.FillTransparency = 0.4
				gunHL.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				gunHL.Parent = drop
			end
		elseif gunHL then
			MM2.clearGunEsp()
		end
		if drop and not dropSeen and MM2.gunAlert then
			setStatus("GUN DROPPED!", T.gold)
			task.delay(4, function() setStatus("READY", T.good) end)
		end
		dropSeen = drop ~= nil

		if MM2.autoShoot and (os.clock() - lastShot) > 2.5
			and mur and MM2.hasTool(Player, "Gun") then
			lastShot = os.clock()
			pcall(MM2.shoot)
		end
		if MM2.autoGrab and drop and not MM2.hasTool(Player, "Gun") then
			pcall(MM2.grabGun)
		end
		task.wait(0.4)
	end
end)
