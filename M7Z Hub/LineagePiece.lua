local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local CONFIG = {
 MinSpeed = 10,
 MaxSpeed = 300,
 DefaultSpeed = 80,
 BgColor = Color3.fromRGB(15, 15, 18),
 PanelColor = Color3.fromRGB(24, 24, 28),
 BorderColor = Color3.fromRGB(45, 45, 52),
 TextColor = Color3.fromRGB(235, 235, 235),
 SubTextColor = Color3.fromRGB(150, 150, 155),
 RedColor = Color3.fromRGB(220, 40, 40),
 GreenColor = Color3.fromRGB(60, 200, 120),
}

local State = {
 Active = false,
 Speed = CONFIG.DefaultSpeed,
 CollectedCount = 0,
 Connections = {},
 Processing = {},
}

local function newInstance(cls, props)
 local obj = Instance.new(cls)
 for k, v in pairs(props or {}) do obj[k] = v end
 return obj
end

local function tween(obj, props, duration)
 local t = TweenService:Create(obj, TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
 t:Play()
 return t
end

if CoreGui:FindFirstChild("M7ZHubUI") then
 CoreGui.M7ZHubUI:Destroy()
end

local ScreenGui = newInstance("ScreenGui", {
 Name = "M7ZHubUI",
 ResetOnSpawn = false,
 IgnoreGuiInset = true,
 ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
 Parent = (gethui and gethui()) or CoreGui,
})

local MainWindow = newInstance("Frame", {
 Name = "MainWindow",
 Size = UDim2.new(0, 280, 0, 250),
 Position = UDim2.new(0.5, -140, 0.35, -125),
 BackgroundColor3 = CONFIG.BgColor,
 BorderSizePixel = 0,
 Active = true,
 Parent = ScreenGui,
})
newInstance("UICorner", { CornerRadius = UDim.new(0, 14), Parent = MainWindow })
newInstance("UIStroke", { Color = CONFIG.BorderColor, Thickness = 1, Parent = MainWindow })

local TitleBar = newInstance("Frame", {
 Name = "TitleBar",
 Size = UDim2.new(1, 0, 0, 42),
 BackgroundColor3 = CONFIG.PanelColor,
 BorderSizePixel = 0,
 Parent = MainWindow,
})
newInstance("UICorner", { CornerRadius = UDim.new(0, 14), Parent = TitleBar })
newInstance("Frame", {
 Size = UDim2.new(1, 0, 0, 14),
 Position = UDim2.new(0, 0, 1, -14),
 BackgroundColor3 = CONFIG.PanelColor,
 BorderSizePixel = 0,
 Parent = TitleBar,
})

local Logo = newInstance("Frame", {
 Name = "Logo",
 Size = UDim2.new(0, 56, 0, 28),
 Position = UDim2.new(0, 10, 0.5, -14),
 BackgroundColor3 = Color3.fromRGB(0, 0, 0),
 BorderSizePixel = 0,
 Parent = TitleBar,
})
newInstance("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Logo })
newInstance("UIStroke", { Color = CONFIG.BorderColor, Thickness = 1, Parent = Logo })
newInstance("TextLabel", {
 Size = UDim2.new(0.33, 0, 1, 0), BackgroundTransparency = 1, Text = "M",
 TextColor3 = Color3.fromRGB(255,255,255), TextScaled = true,
 Font = Enum.Font.GothamBold, Parent = Logo,
})
newInstance("TextLabel", {
 Size = UDim2.new(0.34, 0, 1, 0), Position = UDim2.new(0.33, 0, 0, 0),
 BackgroundTransparency = 1, Text = "7", TextColor3 = CONFIG.RedColor,
 TextScaled = true, Font = Enum.Font.GothamBold, Parent = Logo,
})
newInstance("TextLabel", {
 Size = UDim2.new(0.33, 0, 1, 0), Position = UDim2.new(0.67, 0, 0, 0),
 BackgroundTransparency = 1, Text = "Z", TextColor3 = Color3.fromRGB(255,255,255),
 TextScaled = true, Font = Enum.Font.GothamBold, Parent = Logo,
})

newInstance("TextLabel", {
 Size = UDim2.new(1, -160, 1, 0), Position = UDim2.new(0, 72, 0, 0),
 BackgroundTransparency = 1, Text = "M7Z Hub", TextColor3 = CONFIG.TextColor,
 TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamMedium,
 TextSize = 13, Parent = TitleBar,
})

local function createTitleButton(text, textColor, xOffset)
 local btn = newInstance("TextButton", {
  Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(1, xOffset, 0.5, -14),
  BackgroundColor3 = CONFIG.BgColor, BorderSizePixel = 0, Text = text,
  TextColor3 = textColor, Font = Enum.Font.GothamBold, TextSize = 16,
  AutoButtonColor = false, Parent = TitleBar,
 })
 newInstance("UICorner", { CornerRadius = UDim.new(0, 8), Parent = btn })
 return btn
end

local ConfigBtn = createTitleButton("⚙", CONFIG.TextColor, -100)
local MinBtn = createTitleButton("–", CONFIG.TextColor, -68)
local CloseBtn = createTitleButton("X", CONFIG.RedColor, -36)

local function setHover(btn, hoverColor)
 btn.MouseEnter:Connect(function() tween(btn, {BackgroundColor3 = hoverColor}, 0.15) end)
 btn.MouseLeave:Connect(function() tween(btn, {BackgroundColor3 = CONFIG.BgColor}, 0.15) end)
end
setHover(ConfigBtn, Color3.fromRGB(50, 50, 58))
setHover(MinBtn, Color3.fromRGB(40, 40, 45))
setHover(CloseBtn, Color3.fromRGB(80, 20, 20))

local Content = newInstance("Frame", {
 Name = "Content", Size = UDim2.new(1, -20, 1, -60),
 Position = UDim2.new(0, 10, 0, 50), BackgroundTransparency = 1, Parent = MainWindow,
})

local ToggleBtn = newInstance("TextButton", {
 Name = "ToggleBtn", Size = UDim2.new(1, 0, 0, 44),
 BackgroundColor3 = CONFIG.PanelColor, BorderSizePixel = 0, Text = "ATIVAR",
 TextColor3 = CONFIG.TextColor, Font = Enum.Font.GothamBold, TextSize = 15,
 AutoButtonColor = false, Parent = Content,
})
newInstance("UICorner", { CornerRadius = UDim.new(0, 10), Parent = ToggleBtn })
newInstance("UIStroke", { Color = CONFIG.BorderColor, Thickness = 1, Parent = ToggleBtn })

local SpeedLabel = newInstance("TextLabel", {
 Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, 58),
 BackgroundTransparency = 1, Text = string.format("Velocidade: %d", CONFIG.DefaultSpeed),
 TextColor3 = CONFIG.SubTextColor, Font = Enum.Font.Gotham, TextSize = 13,
 TextXAlignment = Enum.TextXAlignment.Left, Parent = Content,
})

local SliderTrack = newInstance("Frame", {
 Name = "SliderTrack", Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 0, 88),
 BackgroundColor3 = CONFIG.PanelColor, BorderSizePixel = 0, Parent = Content,
})
newInstance("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SliderTrack })

local SliderFill = newInstance("Frame", {
 Size = UDim2.new(0.25, 0, 1, 0), BackgroundColor3 = CONFIG.RedColor,
 BorderSizePixel = 0, Parent = SliderTrack,
})
newInstance("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SliderFill })

local SliderKnob = newInstance("Frame", {
 Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(0.25, -11, 0.5, -11),
 BackgroundColor3 = CONFIG.TextColor, BorderSizePixel = 0, Parent = SliderTrack,
})
newInstance("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SliderKnob })
newInstance("UIStroke", { Color = CONFIG.RedColor, Thickness = 2, Parent = SliderKnob })

local SliderTouch = newInstance("TextButton", {
 Size = UDim2.new(1, 0, 0, 34), Position = UDim2.new(0, 0, 0, -12),
 BackgroundTransparency = 1, Text = "", Parent = SliderTrack,
})

local StatusLabel = newInstance("TextLabel", {
 Size = UDim2.new(1, 0, 0, 16), Position = UDim2.new(0, 0, 1, -16),
 BackgroundTransparency = 1, Text = "Inativo", TextColor3 = CONFIG.SubTextColor,
 Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
 Parent = Content,
})

local InfoLabel = newInstance("TextLabel", {
 Size = UDim2.new(1, 0, 0, 16), Position = UDim2.new(0, 0, 1, -34),
 BackgroundTransparency = 1, Text = "Coletados: 0", TextColor3 = CONFIG.GreenColor,
 Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
 Parent = Content,
})

do
 local dragging, dragStart, startPos
 TitleBar.InputBegan:Connect(function(input)
  if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
   dragging = true; dragStart = input.Position; startPos = MainWindow.Position
  end
 end)
 UserInputService.InputChanged:Connect(function(input)
  if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
   local delta = input.Position - dragStart
   MainWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
  end
 end)
 UserInputService.InputEnded:Connect(function(input)
  if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
 end)
end

do
 local dragging = false
 local function updateSlider(input)
  local posX = input.Position.X - SliderTrack.AbsolutePosition.X
  local pct = math.clamp(posX / SliderTrack.AbsoluteSize.X, 0, 1)
  local val = math.floor(CONFIG.MinSpeed + (CONFIG.MaxSpeed - CONFIG.MinSpeed) * pct)
  SliderFill.Size = UDim2.new(pct, 0, 1, 0)
  SliderKnob.Position = UDim2.new(pct, -11, 0.5, -11)
  SpeedLabel.Text = string.format("Velocidade: %d", val)
  State.Speed = val
 end
 SliderTouch.InputBegan:Connect(function(input)
  if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; updateSlider(input) end
 end)
 UserInputService.InputChanged:Connect(function(input)
  if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end
 end)
 UserInputService.InputEnded:Connect(function(input)
  if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
 end)
 local initPct = (CONFIG.DefaultSpeed - CONFIG.MinSpeed) / (CONFIG.MaxSpeed - CONFIG.MinSpeed)
 SliderFill.Size = UDim2.new(initPct, 0, 1, 0)
 SliderKnob.Position = UDim2.new(initPct, -11, 0.5, -11)
end

local MiniBtn, ReopenBtn
local function createMiniBtn()
 MiniBtn = newInstance("TextButton", {
  Name = "MiniBtn", Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0, 20, 0.5, -25),
  BackgroundColor3 = Color3.fromRGB(0, 0, 0), BorderSizePixel = 0, Text = "M7",
  TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 18,
  AutoButtonColor = false, Parent = ScreenGui, Visible = false,
 })
 newInstance("UICorner", { CornerRadius = UDim.new(1, 0), Parent = MiniBtn })
 newInstance("UIStroke", { Color = CONFIG.RedColor, Thickness = 2, Parent = MiniBtn })
 MiniBtn.MouseButton1Click:Connect(function()
  MainWindow.Visible = true; MiniBtn.Visible = false
  tween(MainWindow, {Size = UDim2.new(0, 280, 0, 250)}, 0.2)
 end)
end
createMiniBtn()

MinBtn.MouseButton1Click:Connect(function()
 tween(MainWindow, {Size = UDim2.new(0, 280, 0, 0)}, 0.2)
 task.wait(0.2)
 MainWindow.Visible = false; MiniBtn.Visible = true
end)

local function createReopenBtn()
 ReopenBtn = newInstance("TextButton", {
  Name = "ReopenBtn", Size = UDim2.new(0, 40, 0, 40), Position = UDim2.new(0, 20, 0.4, 0),
  BackgroundColor3 = Color3.fromRGB(0, 0, 0), BorderSizePixel = 0, Text = "M7",
  TextColor3 = CONFIG.RedColor, Font = Enum.Font.GothamBold, TextSize = 14,
  AutoButtonColor = false, Parent = ScreenGui, Visible = false,
 })
 newInstance("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ReopenBtn })
 newInstance("UIStroke", { Color = CONFIG.RedColor, Thickness = 2, Parent = ReopenBtn })
 ReopenBtn.MouseButton1Click:Connect(function()
  MainWindow.Visible = true; ReopenBtn.Visible = false
  if MiniBtn then MiniBtn.Visible = false end
 end)
end
createReopenBtn()

CloseBtn.MouseButton1Click:Connect(function()
 MainWindow.Visible = false
 if MiniBtn then MiniBtn.Visible = false end
 ReopenBtn.Visible = true
end)

local seedFolder = Workspace:WaitForChild("Seed")

local function processSeed(seed)
 if not State.Active or State.Processing[seed] then return end
 State.Processing[seed] = true

 local prompt = seed:FindFirstChildOfClass("ProximityPrompt") or seed:WaitForChild("ProximityPrompt", 2)
 if prompt and State.Active then
  local char = LocalPlayer.Character
  local hrp = char and char:FindFirstChild("HumanoidRootPart")
  if hrp then
   StatusLabel.Text = "Indo ate a Semente..."
   StatusLabel.TextColor3 = CONFIG.GreenColor

   local bodyVelocity = Instance.new("BodyVelocity")
   bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
   bodyVelocity.Velocity = Vector3.zero
   bodyVelocity.Parent = hrp

   local destination = seed:GetPivot().Position
   local distance = (destination - hrp.Position).Magnitude
   local tweenInfo = TweenInfo.new(distance / State.Speed, Enum.EasingStyle.Linear)
   local t = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(destination)})
   t:Play()
   t.Completed:Wait()
   bodyVelocity:Destroy()
  end

  if State.Active then
   StatusLabel.Text = "Coletando Semente..."
   fireproximityprompt(prompt)
   State.CollectedCount = State.CollectedCount + 1
   InfoLabel.Text = "Coletados: " .. tostring(State.CollectedCount)
   task.wait(2.5)
  end
 end

 State.Processing[seed] = nil
 if State.Active then
  StatusLabel.Text = "Procurando..."
  StatusLabel.TextColor3 = CONFIG.GreenColor
 end
end

local function startFarming()
 StatusLabel.Text = "Procurando..."
 StatusLabel.TextColor3 = CONFIG.GreenColor

 for _, seed in seedFolder:GetChildren() do
  task.spawn(processSeed, seed)
 end

 local c = seedFolder.ChildAdded:Connect(function(seed)
  task.spawn(processSeed, seed)
 end)
 table.insert(State.Connections, c)
end

local function stopFarming()
 for _, conn in ipairs(State.Connections) do
  pcall(function() conn:Disconnect() end)
 end
 State.Connections = {}
 StatusLabel.Text = "Inativo"
 StatusLabel.TextColor3 = CONFIG.SubTextColor
end

ToggleBtn.MouseButton1Click:Connect(function()
 State.Active = not State.Active
 if State.Active then
  ToggleBtn.Text = "DESATIVAR"
  tween(ToggleBtn, {BackgroundColor3 = Color3.fromRGB(60, 20, 20)}, 0.2)
  startFarming()
 else
  ToggleBtn.Text = "ATIVAR"
  tween(ToggleBtn, {BackgroundColor3 = CONFIG.PanelColor}, 0.2)
  stopFarming()
 end
end)
