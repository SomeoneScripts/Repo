local Players = game:GetService("Players")
local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Someone = {
	Icons = loadstring(readfile("Projects/Library/Someone/Icons.lua"))(),
}

function Someone:ResolveConfigs(Options)
	if typeof(Options) == "string" then
		return Options
	end
	local Configs = {}
	for name, value in Options do
		Configs[name:lower()] = value
	end
	return Configs
end

function Someone:GetIcon(Value)
	if value then
	    if typeof(Value) == "string" then
	        if Value:match("^rbxassetid://%d+$") then
	            return Value
	        end
	        if self.Icons[Value:lower()] then
	            return self.Icons[Value:lower()]
	        end
	        if Value:find("^https?://") then
	            local Root = "Someone Library"
	            local Folder = Root .. "/Assets"
	            if not isfolder(Root) then makefolder(Root) end
	            if not isfolder(Folder) then makefolder(Folder) end
	            local SafeName = Value:gsub("https?://", ""):gsub("[^%w%-_%.]", "_")
	            local FileName = Folder .. "/" .. SafeName .. ".png"
	            if not isfile(FileName) then
	                local Bytes = game:HttpGet(Value)
	                writefile(FileName, Bytes)
	            end
	            local Icon = getcustomasset(FileName)
	            if Icon then
	                return Icon
	            end
	        end
	        return Value
	    elseif typeof(Value) == "number" then
	        return "rbxassetid://" .. Value
	    end
	end
end

function New(Class, Props)
    local Inst = Instance.new(Class)
    for k, v in Props do
        Inst[k] = v
    end
    return Inst
end

local SomeoneLibrary = New("ScreenGui", {DisplayOrder = 1, IgnoreGuiInset = true, Name = "Someone Library", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = gethui()})
local GuiFind = SomeoneLibrary.Parent:FindFirstChild(SomeoneLibrary.Name)
if GuiFind ~= SomeoneLibrary then
	GuiFind:Destroy()
end

function Someone:AddWindow(Configs)
	local Configs = Someone:ResolveConfigs(Configs)
	
	local WTitle = Configs.title or Configs.name or "Someone Library"
	local WSubTitle = Configs.subtitle or Configs.description or "by Someone"
	
	local WindowFrame = New("Frame", {BackgroundColor3 = Color3.fromRGB(25, 25, 25), BorderSizePixel = 0, ClipsDescendants = true, Draggable = true, Name = "Window Frame", Position = UDim2.new(0, 200, 0, 65), Size = UDim2.new(0, 500, 0, 350), ZIndex = 10, Parent = SomeoneLibrary})
	New("UICorner", {CornerRadius = UDim.new(0, 4), Parent = WindowFrame})
	
	local AllContentsFrame = New("Frame", {BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Name = "All Contents Frame", Size = UDim2.new(1, 0, 1, 0), Parent = WindowFrame})
	New("UIPadding", {PaddingBottom = UDim.new(0, 5), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5), PaddingTop = UDim.new(0, 5), Parent = AllContentsFrame})
	
	local TopFrame = New("Frame", {BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Name = "Top Frame", Size = UDim2.new(1, 0, 0.12, 0), Parent = AllContentsFrame})
	local CloseButton = New("ImageButton", {Active = true, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Image = "rbxassetid://10747384394", Name = "Close Button", Position = UDim2.new(1, -35, 0, 5), ScaleType = Enum.ScaleType.Tile, Size = UDim2.new(0, 30, 1, -10), Parent = TopFrame})
	local WindowTitle = New("TextLabel", {AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1, BorderSizePixel = 0, Font = Enum.Font.GothamBlack, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal), Name = "Window Title", Position = UDim2.new(0, 10, 0, 5), RichText = true, Size = UDim2.new(0, 0, 0, 30), Text = WTitle, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = TopFrame})
	local WindowSubTitle = New("TextLabel", {AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = Color3.fromRGB(180, 180, 180), BackgroundTransparency = 1, BorderSizePixel = 0, Font = Enum.Font.GothamBold, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal), Name = "Window SubTitle", Position = UDim2.new(1, 5, 1, -16), RichText = true, Size = UDim2.new(0, 0, 0, 5), Text = WSubTitle, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 9, Parent = WindowTitle})
	New("UISizeConstraint", {MaxSize = Vector2.new(200, 30), Parent = WindowTitle})
	
	local TabsFrame = New("ScrollingFrame", {Active = true, AutomaticCanvasSize = Enum.AutomaticSize.Y, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1, BorderSizePixel = 0, BottomImage = "rbxassetid://6889812791", CanvasSize = UDim2.new(0, 0, 0, 0), MidImage = "rbxassetid://6889812721", Name = "Tabs Frame", Position = UDim2.new(0, 0, 0.12, 5), ScrollBarImageColor3 = Color3.fromRGB(0, 255, 0), ScrollBarThickness = 2, ScrollingDirection = Enum.ScrollingDirection.Y, Size = UDim2.new(0.2, 0, 1, -46), TopImage = "rbxassetid://6276641225", Parent = AllContentsFrame})
	New("UIListLayout", {HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = UDim.new(0, 5), Parent = TabsFrame})
	New("UIPadding", {PaddingBottom = UDim.new(0, 5), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5), PaddingTop = UDim.new(0, 5), Parent = TabsFrame})
	
	local TabsContentsFrame = New("Frame", {BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1, ClipsDescendants = true, Name = "Tabs Contents Frame", Position = UDim2.new(0.2, 5, 0.12, 5), Size = UDim2.new(1, -103, 1, -46), Parent = AllContentsFrame})
	
	local Dropdowns = New("Folder", {Name = "Dropdowns", Parent = SomeoneLibrary})
	local OutsideButton = New("TextButton", {Active = false, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1, BorderSizePixel = 0, Name = "Outside Button", RichText = true, Size = UDim2.new(1, 0, 1, 0), Text = "", TextColor3 = Color3.fromRGB(255, 255, 255), Parent = SomeoneLibrary})
	local Colorpickers = New("Folder", {Name = "Colorpickers", Parent = SomeoneLibrary})
	
	local Window = {}
	Window.Frame = WindowFrame
	local Count = 0
	function Window:GetNextTab()
		Count += 1
		return Count
	end
	
	function Window:AddMinimizer(Configs)
		local Configs = Configs and Someone:ResolveConfigs(Configs)
		local MSize = Configs.size or UDim2.new(0, 45, 0, 45)
		local MPosition = Configs.position or UDim2.new(0, 100, 0, 60)
		local MCorner = Configs.cornerradius or UDim.new(0, 4)
		local MIcon = Configs.icon or ""
		
		local MinimizerButton = New("ImageButton", {BackgroundColor3 = Color3.fromRGB(20, 20, 20), BorderSizePixel = 0, ClipsDescendants = true, Image = Someone:GetIcon(MIcon), Name = "Minimizer Button", Position = MPosition, ScaleType = Enum.ScaleType.Crop, Size = MSize, Parent = SomeoneLibrary})
		New("UICorner", {CornerRadius = MCorner, Parent = MinimizerButton})
		MinimizerButton.MouseButton1Click:Connect(function() Window.Frame.Visible = not Window.Frame.Visible end)
	end
	
	function Window:AddTab(Configs)
		local Configs = Someone:ResolveConfigs(Configs)
		local TTitle = Configs.title or Configs.name or "Tab"
		local TIcon = Someone:GetIcon(Configs.icon or "")
		
		local TabButton = New("TextButton", {BackgroundColor3 = Color3.fromRGB(35, 35, 35), BorderSizePixel = 0, ClipsDescendants = true, Name = ("Tab Button %d [ %s ]"):format(Window:GetNextTab(), TTitle), RichText = true, Size = UDim2.new(1, 0, 0.1, 0), Text = "", TextColor3 = Color3.fromRGB(255, 255, 255), Parent = TabsFrame})
		local TabIcon = New("ImageLabel", {BackgroundTransparency = 1, BorderSizePixel = 0, Image = TIcon, Name = "Tab Icon", Position = UDim2.new(0, 13, 0, 7), Size = UDim2.new(0, 16, 0, 16), Parent = TabButton})
		local TabTitle = New("TextLabel", {BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Font = Enum.Font.GothamBold, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal), Name = "Tab Title", Position = UDim2.new(0, 34, 0, 7), RichText = true, Size = UDim2.new(0, 50, 0, 16), Text = TTitle, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, Parent = TabButton})
		New("UICorner", {CornerRadius = UDim.new(0, 4), Parent = TabButton})
		local Indicator = New("Frame", {BackgroundColor3 = Color3.fromRGB(0, 255, 0), BorderSizePixel = 0, ClipsDescendants = true, Name = "Indicator", Position = UDim2.new(0, 5, 0, 5), Size = UDim2.new(0, 3, 1, -10), Visible = false, Parent = TabButton})
		New("UICorner", {CornerRadius = UDim.new(0, 4), Parent = Indicator})
		
		local CurrentTabContent = New("ScrollingFrame", {Active = true, AutomaticCanvasSize = Enum.AutomaticSize.Y, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1, BorderSizePixel = 0, BottomImage = "rbxassetid://6889812791", CanvasSize = UDim2.new(0, 0, 0, 0), MidImage = "rbxassetid://6889812721", Name = ("Current Tab Content [ %s ]"):format(TTitle), ScrollBarImageColor3 = Color3.fromRGB(0, 255, 0), ScrollBarThickness = 2, ScrollingDirection = Enum.ScrollingDirection.Y, Size = UDim2.new(1, 0, 1, 0), TopImage = "rbxassetid://6276641225", Visible = false, Parent = TabsContentsFrame})
		New("UIListLayout", {HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder, Parent = CurrentTabContent})
		
		local Tab = {}
		
		local Count = 0
		function Tab:GetNextOrder()
			Count += 1
			return Count
		end
		
		function Tab:AddSection(Configs)
			local Configs = Someone:ResolveConfigs(Configs)
			local STitle = Configs.title or Configs.name or ""
			
			local SectionFrame = New("Frame", {BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, LayoutOrder = Tab:GetNextOrder(), Name = "Section Frame", Size = UDim2.new(1, -10, 0, 20), Parent = CurrentTabContent})
			local SectionTitle = New("TextLabel", {AutoLocalize = false, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Font = Enum.Font.GothamBold, Name = "Section Title", RichText = true, Size = UDim2.new(1, 0, 1, 0), Text = STitle, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = SectionFrame})
			
			local Section = {}
			
			function Section:SetTitle(Text)
				SectionTitle.Title = Text
			end
			
			function Section:SetVisible(Value)
				SectionFrame.Title = Value
			end
			
			function Section:Destroy()
				SectionFrame:Destroy()
			end
			
			return Section
		end
		
		function Tab:AddParagraph(Configs)
			local Configs = Someone:ResolveConfigs(Configs)
			local PName = Configs.title or Configs.name or "Paragraph"
			local PDesc = Configs.description or Configs.content or ""
			
			local ParagraphFrame = New("Frame", {AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Color3.fromRGB(35, 35, 35), BorderSizePixel = 0, ClipsDescendants = true, LayoutOrder = Tab:GetNextOrder(), Name = "Paragraph Frame", Size = UDim2.new(1, -10, 0, 30), Parent = CurrentTabContent})
			local ParagraphTitle = New("TextLabel", {AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Font = Enum.Font.GothamMedium, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal), Name = "Paragraph Title", Position = UDim2.new(0, 5, 0, 3), RichText = true, Size = UDim2.new(0, 0, 0, 12), Text = PName, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 10, TextTruncate = Enum.TextTruncate.SplitWord, TextXAlignment = Enum.TextXAlignment.Left, Parent = ParagraphFrame})
			local ParagraphDescription = New("TextLabel", {AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Font = Enum.Font.Gotham, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal), Name = "Paragraph Description", Position = UDim2.new(0, 5, 0, 18), RichText = true, Size = UDim2.new(0, 0, 0, 10), Text = PDesc, TextColor3 = Color3.fromRGB(180, 180, 180), TextTruncate = Enum.TextTruncate.SplitWord, Parent = ParagraphFrame})
			New("UICorner", {CornerRadius = UDim.new(0, 4), Parent = ParagraphFrame})
			
			local Paragraph = {}
			
			function Paragraph:SetTitle(Text)
				ParagraphTitle.Text = Text
			end
			
			function Paragraph:SetDesc(Text)
				ParagraphDescription.Text = Text
			end
			
			function Paragraph:SetVisible(Value)
				ParagraphFrame.Visible = Value
			end
			
			function Paragraph:Destroy()
				ParagraphFrame:Destroy()
			end
			
		end
		
		function Tab:AddButton(Configs)
			local Configs = Someone:ResolveConfigs(Configs)
			local TTitle = Configs.title or Configs.name or "Button"
			local TDesc = Configs.description or Configs.content or ""
			local TCallback = Configs.callback or function() end
			
			local ButtonFrame = New("Frame", {AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Color3.fromRGB(35, 35, 35), BorderSizePixel = 0, ClipsDescendants = true, LayoutOrder = Tab:GetNextOrder(), Name = "Button Frame", Size = UDim2.new(1, -10, 0, 30), Parent = CurrentTabContent})
			New("UICorner", {CornerRadius = UDim.new(0, 4), Parent = ButtonFrame})
			local ButtonTitle = New("TextLabel", {AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Font = Enum.Font.GothamMedium, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal), Name = "Button Title", Position = UDim2.new(0, 5, 0, 3), RichText = true, Size = UDim2.new(0, 0, 0, 12), Text = TTitle, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 10, TextTruncate = Enum.TextTruncate.SplitWord, TextXAlignment = Enum.TextXAlignment.Left, Parent = ButtonFrame})
			local ButtonDescription = New("TextLabel", {AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Font = Enum.Font.Gotham, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal), Name = "Button Description", Position = UDim2.new(0, 5, 0, 18), RichText = true, Size = UDim2.new(0, 0, 0, 10), Text = TDesc, TextColor3 = Color3.fromRGB(180, 180, 180), TextTruncate = Enum.TextTruncate.SplitWord, Parent = ButtonFrame})
			local ButtonImage = New("ImageLabel", {Active = true, BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Image = "rbxassetid://10734898355", Name = "Button Image", Position = UDim2.new(1, -25, 0, 5), Rotation = 90, Size = UDim2.new(0, 20, 1, -10), Parent = ButtonFrame})
			
			local ClickButton = New("ImageButton", {BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Name = "Click Button", Size = UDim2.new(1, 0, 1, 0), ZIndex = 3, Parent = ButtonFrame})
			
			local Button = {}
			
			function Button:SetTitle(Text)
				ButtonTitle.Text = Text
			end
			function Button:SetDesc(Text)
				ButtonDescription.Text = Text
			end
			function Button:SetVisible(Value)
				ButtonFrame.Visible = Value
			end
			function Button:Destroy()
				ButtonFrame:Destroy()
			end
			ClickButton.MouseButton1Click:Connect(function()
				TCallback()
				ButtonImage.ImageColor3 = Color3.fromRGB(0, 255, 0)
				task.wait(0.15)
				ButtonImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
			end)
			return Button
		end
		
		function Tab:AddToggle(Configs)
		    local Configs = Someone:ResolveConfigs(Configs)
		    local TName = Configs.title or Configs.name or "Toggle"
		    local TDesc = Configs.description or ""
		    local TDefault = Configs.default or false
		    local TCallback = Configs.callback or function() end
		
		    local ToggleFrame = New("Frame", {AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Color3.fromRGB(35, 35, 35), BorderSizePixel = 0, ClipsDescendants = true, LayoutOrder = Tab:GetNextOrder(), Name = "Toggle Frame", Size = UDim2.new(1, -10, 0, 30), Parent = CurrentTabContent})
		    local ToggleTitle = New("TextLabel", {AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Font = Enum.Font.GothamMedium, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal), Name = "Toggle Title", Position = UDim2.new(0, 5, 0, 3), RichText = true, Size = UDim2.new(0, 0, 0, 12), Text = TName, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 10, TextTruncate = Enum.TextTruncate.SplitWord, TextXAlignment = Enum.TextXAlignment.Left, Parent = ToggleFrame})
		    local ToggleDescription = New("TextLabel", {AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Font = Enum.Font.Gotham, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal), Name = "Toggle Description", Position = UDim2.new(0, 5, 0, 18), RichText = true, Size = UDim2.new(0, 0, 0, 10), Text = TDesc, TextColor3 = Color3.fromRGB(180, 180, 180), TextTruncate = Enum.TextTruncate.SplitWord, Parent = ToggleFrame})
		    New("UICorner", {CornerRadius = UDim.new(0, 4), Parent = ToggleFrame})
		    local ClickFrame = New("Frame", {BackgroundColor3 = Color3.fromRGB(25, 25, 25), BorderSizePixel = 0, Name = "Click Frame", Position = UDim2.new(1, -45, 0, 5), Size = UDim2.new(0, 40, 0, 20), Parent = ToggleFrame})
		    New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ClickFrame})
		    local BollFrame = New("Frame", {Active = false, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, Name = "Boll Frame", Position = UDim2.new(0, 2, 0, 2), Size = UDim2.new(0, 16, 1, -4), Parent = ClickFrame})
		    New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = BollFrame})
		    
		    local Toggle = {CurrentValue = TDefault}
		    local function Update(Internal)
		        local TargetPos = Toggle.CurrentValue and UDim2.new(0, 22, 0, 2) or UDim2.new(0, 2, 0, 2)
		        local TargetColor = Toggle.CurrentValue and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(25, 25, 25)
		        TweenService:Create(BollFrame, TweenInfo.new(0.2), {Position = TargetPos}):Play()
		        TweenService:Create(ClickFrame, TweenInfo.new(0.2), {BackgroundColor3 = TargetColor}):Play()
		        if not Internal then
		            TCallback(Toggle.CurrentValue)
		        end
		    end
		    ToggleFrame.InputBegan:Connect(function(Input)
		        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
		            Toggle.CurrentValue = not Toggle.CurrentValue
		            Update()
		        end
		    end)
		    function Toggle:SetTitle(Text)
		        ToggleTitle.Text = Text
		    end
		    function Toggle:SetDesc(Text)
		        ToggleDescription.Text = Text
		    end
		    function Toggle:SetValue(Value)
		        Toggle.CurrentValue = Value
		        Update(true)
		    end
		    function Toggle:SetVisible(Value)
		        ToggleFrame.Visible = Value
		    end
		    function Toggle:Destroy()
		        ToggleFrame:Destroy()
		    end
		    if TDefault then
		        Update(true)
		    end
		    return Toggle
		end
		
		function Tab:AddSlider(Configs)
		    local Configs = Someone:ResolveConfigs(Configs)
		    local SName = Configs.title or Configs.name or "Slider"
		    local SDesc = Configs.description or ""
		    local SMin = Configs.min or 0
		    local SMax = Configs.max or 100
		    local SDef = Configs.default or SMin
		    local SInc = Configs.increase or 1
		    local SCallback = Configs.callback or function() end
		
		    local SliderFrame = New("Frame", {AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Color3.fromRGB(35, 35, 35), BorderSizePixel = 0, ClipsDescendants = true, LayoutOrder = Tab:GetNextOrder(), Name = "Slider Frame", Size = UDim2.new(1, -10, 0, 30), Parent = CurrentTabContent})
		    local SliderTitle = New("TextLabel", {AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Font = Enum.Font.GothamMedium, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal), Name = "Slider Title", Position = UDim2.new(0, 5, 0, 3), RichText = true, Size = UDim2.new(0, 0, 0, 12), Text = SName, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 10, TextTruncate = Enum.TextTruncate.SplitWord, TextXAlignment = Enum.TextXAlignment.Left, Parent = SliderFrame})
		    local SliderDescription = New("TextLabel", {AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Font = Enum.Font.Gotham, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal), Name = "Slider Description", Position = UDim2.new(0, 5, 0, 18), RichText = true, Size = UDim2.new(0, 0, 0, 10), Text = SDesc, TextColor3 = Color3.fromRGB(180, 180, 180), TextTruncate = Enum.TextTruncate.SplitWord, Parent = SliderFrame})
		    New("UICorner", {CornerRadius = UDim.new(0, 4), Parent = SliderFrame})
		    local IncreaserFrame = New("Frame", {Active = true, BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Name = "Increaser Frame", Position = UDim2.new(1, -125, 0, 5), Size = UDim2.new(0, 120, 1, -10), Parent = SliderFrame})
		    local ValueInput = New("TextBox", {BackgroundTransparency = 1, BorderSizePixel = 0, ClearTextOnFocus = false, ClipsDescendants = true, Font = Enum.Font.Gotham, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal), Name = "Value Input", RichText = true, Size = UDim2.new(0, 20, 0, 20), Text = tostring(SDef), TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 10, Parent = IncreaserFrame})
		    local BarFrame = New("Frame", {Active = true, BackgroundColor3 = Color3.fromRGB(25, 25, 25), BorderSizePixel = 0, Name = "Bar Frame", Position = UDim2.new(0, 25, 0, 5), Size = UDim2.new(1, -30, 0, 10), Parent = IncreaserFrame})
		    local FillBar = New("Frame", {Active = false, BackgroundColor3 = Color3.fromRGB(0, 255, 0), BorderSizePixel = 0, ClipsDescendants = true, Name = "Fill Bar", Size = UDim2.new(0, 0, 1, 0), ZIndex = 0, Parent = BarFrame})
		    local BollControlFrame = New("Frame", {Active = false, BackgroundColor3 = Color3.fromRGB(255, 255, 255), ClipsDescendants = true, Name = "Boll Control Frame", Position = UDim2.new(0, 0, 0, -2), Size = UDim2.new(0, 6, 0, 14), Parent = BarFrame})
		    New("UICorner", {CornerRadius = UDim.new(0, 3), Parent = BollControlFrame})
		    New("UICorner", {CornerRadius = UDim.new(0, 4), Parent = FillBar})
		    New("UICorner", {CornerRadius = UDim.new(0, 4), Parent = BarFrame})
		
		    local Slider = {Value = SDef, Connection = nil}
		    local function Update(Value, Internal)
		        local Clamped = math.clamp(Value, SMin, SMax)
		        local Stepped = math.floor(Clamped / SInc + 0.5) * SInc
		        Slider.Value = Stepped
		        local Percentage = (Slider.Value - SMin) / (SMax - SMin)
		        ValueInput.Text = tostring(Slider.Value)
		        local TargetPos = UDim2.new(math.clamp(Percentage, 0, 0.94), 0, 0, -2)
		        local TargetSize = UDim2.new(Percentage, 0, 1, 0)
		        TweenService:Create(BollControlFrame, TweenInfo.new(0.1), {Position = TargetPos}):Play()
		        TweenService:Create(FillBar, TweenInfo.new(0.1), {Size = TargetSize}):Play()
		        if not Internal then
		            SCallback(Slider.Value)
		        end
		    end
		    local function HandleInput(Input)
		        local SizeX = BarFrame.AbsoluteSize.X
		        local PositionX = math.clamp((Input.Position.X - BarFrame.AbsolutePosition.X) / SizeX, 0, 1)
		        local NewValue = SMin + (PositionX * (SMax - SMin))
		        Update(NewValue)
		    end
		    BarFrame.InputBegan:Connect(function(Input)
		        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
		            HandleInput(Input)
		            Slider.Connection = UserInputService.InputChanged:Connect(function(Move)
		                if Move.UserInputType == Enum.UserInputType.MouseMovement or Move.UserInputType == Enum.UserInputType.Touch then
		                    HandleInput(Move)
		                end
		            end)
		        end
		    end)
		    UserInputService.InputEnded:Connect(function(Input)
		        if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) and Slider.Connection then
		            Slider.Connection:Disconnect()
		            Slider.Connection = nil
		        end
		    end)
		    ValueInput.FocusLost:Connect(function()
		        local Num = tonumber(ValueInput.Text)
		        if Num then
		            Update(Num)
		        else
		            ValueInput.Text = tostring(Slider.Value)
		        end
		    end)
		    function Slider:SetTitle(Text)
		        SliderTitle.Text = Text
		    end
		    function Slider:SetDesc(Text)
		        SliderDescription.Text = Text
		    end
		    function Slider:SetVisible(Value)
		        SliderFrame.Visible = Value
		    end
		    function Slider:Destroy()
		        SliderFrame:Destroy()
		    end
		    function Slider:SetValue(Value)
		        Update(Value, true)
		    end
		    Update(SDef, true)
		    return Slider
		end
		
		function Tab:AddDropdown(Configs)
		    local Configs = Someone:ResolveConfigs(Configs)
		    local DTitle = Configs.title or Configs.name or "Dropdown Title"
		    local DDesc = Configs.description or "Dropdown Description"
		    local DOptions = Configs.options or {}
		    local DDefault = Configs.default
		    local DMulti = Configs.multi or false
		    local DSearch = Configs.search or false
		    local DCallback = Configs.callback or function() end
		
		    local DropdownFrame = New("Frame", {AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Color3.fromRGB(35, 35, 35), BorderSizePixel = 0, ClipsDescendants = true, LayoutOrder = Tab:GetNextOrder(), Name = "Dropdown Frame", Size = UDim2.new(1, -10, 0, 30), Parent = CurrentTabContent})
		    local DropdownTitle = New("TextLabel", {AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Font = Enum.Font.GothamMedium, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal), Name = "Dropdown Title", Position = UDim2.new(0, 5, 0, 3), RichText = true, Size = UDim2.new(0, 0, 0, 12), Text = DTitle, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 10, TextTruncate = Enum.TextTruncate.SplitWord, TextXAlignment = Enum.TextXAlignment.Left, Parent = DropdownFrame})
		    local DropdownDescription = New("TextLabel", {AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Font = Enum.Font.Gotham, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal), Name = "Dropdown Description", Position = UDim2.new(0, 5, 0, 18), RichText = true, Size = UDim2.new(0, 0, 0, 10), Text = DDesc, TextColor3 = Color3.fromRGB(180, 180, 180), TextTruncate = Enum.TextTruncate.SplitWord, Parent = DropdownFrame})
		    New("UICorner", {CornerRadius = UDim.new(0, 4), Parent = DropdownFrame})
		    local OptionsButton = New("TextButton", {BackgroundColor3 = Color3.fromRGB(45, 45, 45), BorderSizePixel = 0, ClipsDescendants = true, Font = Enum.Font.GothamMedium, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal), Name = "Options Button", Position = UDim2.new(1, -65, 0, 7), RichText = true, Size = UDim2.new(0, 60, 1, -16), Text = "...", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 10, Parent = DropdownFrame})
		    New("UICorner", {CornerRadius = UDim.new(0, 4), Parent = OptionsButton})
		    local DropdownOutsideFrame = New("Frame", {BackgroundColor3 = Color3.fromRGB(25, 25, 25), BorderSizePixel = 0, ClipsDescendants = true, Name = "Dropdown Outside Frame", Position = UDim2.new(0, WindowFrame.AbsolutePosition.X + WindowFrame.AbsoluteSize.X + 5, 0, WindowFrame.Position.Y.Offset), Size = UDim2.new(0, 100, 0, 0), Visible = false, ZIndex = 10, Parent = Dropdowns})
		    New("UIPadding", {Parent = DropdownOutsideFrame})
		    New("UICorner", {CornerRadius = UDim.new(0, 4), Parent = DropdownOutsideFrame})
		    local DropdownOptionsFrame = New("ScrollingFrame", {AutomaticCanvasSize = Enum.AutomaticSize.Y, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1, BorderSizePixel = 0, BottomImage = "rbxassetid://6889812791", CanvasSize = UDim2.new(0, 0, 0, 0), MidImage = "rbxassetid://6889812721", Name = "Dropdown Options Frame", Position = UDim2.new(0, 0, 0, 25), ScrollBarImageColor3 = Color3.fromRGB(0, 255, 0), ScrollBarThickness = 2, ScrollingDirection = Enum.ScrollingDirection.Y, Size = UDim2.new(1, 0, 0, 125), TopImage = "rbxassetid://6276641225", Parent = DropdownOutsideFrame})
		    New("UIListLayout", {HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder, Parent = DropdownOptionsFrame})
		    local DropdownSearch = New("TextBox", {BackgroundColor3 = Color3.fromRGB(35, 35, 35), BorderSizePixel = 0, ClearTextOnFocus = false, ClipsDescendants = true, CursorPosition = -1, Font = Enum.Font.Gotham, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal), Name = "Dropdown Search", OverlayNativeInput = true, PlaceholderText = "Search...", RichText = true, Size = UDim2.new(1, 0, 0, 20), Text = "", TextColor3 = Color3.fromRGB(255, 255, 255), TextWrapped = true, Visible = DSearch, Parent = DropdownOutsideFrame})
		    New("UICorner", {CornerRadius = UDim.new(0, 4), Parent = DropdownSearch})
		
		    local Dropdown = {Selected = {}, Options = {}}
		    local function UpdateValue()
		        if DMulti then
		            OptionsButton.Text = #Dropdown.Selected > 0 and table.concat(Dropdown.Selected, ", ") or "..."
		            DCallback(Dropdown.Selected)
		        else
		            OptionsButton.Text = Dropdown.Selected[1] or "..."
		            DCallback(Dropdown.Selected[1])
		        end
		    end
		
		    local function Toggle(State)
		        if State then
		            DropdownOutsideFrame.Visible = true
		            OutsideButton.Visible = true
		            DropdownOutsideFrame.Position = UDim2.new(0, WindowFrame.AbsolutePosition.X + WindowFrame.AbsoluteSize.X + 5, 0, WindowFrame.Position.Y.Offset)
		            game:GetService("TweenService"):Create(DropdownOutsideFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 100, 0, 145)}):Play()
		        else
		            OutsideButton.Visible = false
		            local Tween = game:GetService("TweenService"):Create(DropdownOutsideFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 100, 0, 0)})
		            Tween:Play()
		            Tween.Completed:Connect(function()
		                if not OutsideButton.Visible then
		                    DropdownOutsideFrame.Visible = false
		                end
		            end)
		        end
		    end
		    local function AddOptionUI(Name)
		        local OptionButton = New("TextButton", {BackgroundColor3 = Color3.fromRGB(35, 35, 35), Font = Enum.Font.GothamMedium, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal), Name = "Option Button", Size = UDim2.new(1, -10, 0, 25), Text = Name, TextColor3 = table.find(Dropdown.Selected, Name) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255), TextSize = 10, TextWrapped = true, Parent = DropdownOptionsFrame})
		        New("UICorner", {CornerRadius = UDim.new(0, 4), Parent = OptionButton})
		        
		        OptionButton.MouseButton1Click:Connect(function()
		            if DMulti then
		                local Pos = table.find(Dropdown.Selected, Name)
		                if Pos then
		                    table.remove(Dropdown.Selected, Pos)
		                    OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		                else
		                    table.insert(Dropdown.Selected, Name)
		                    OptionButton.TextColor3 = Color3.fromRGB(0, 255, 0)
		                end
		            else
		                for _, v in pairs(DropdownOptionsFrame:GetChildren()) do
		                    if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(255, 255, 255) end
		                end
		                Dropdown.Selected = {Name}
		                OptionButton.TextColor3 = Color3.fromRGB(0, 255, 0)
		                Toggle(false)
		            end
		            UpdateValue()
		        end)
		    end
		
		    function Dropdown:SetOptions(Tab)
		        for _, v in pairs(DropdownOptionsFrame:GetChildren()) do
		            if v:IsA("TextButton") then v:Destroy() end
		        end
		        Dropdown.Options = Tab
		        for _, v in pairs(Tab) do AddOptionUI(v) end
		    end
		
		    function Dropdown:AddOption(Name)
		        table.insert(Dropdown.Options, Name)
		        AddOptionUI(Name)
		    end
		    function Dropdown:RemoveOption(Name)
		        local Found = table.find(Dropdown.Options, Name)
		        if Found then table.remove(Dropdown.Options, Found) end
		        for _, v in pairs(DropdownOptionsFrame:GetChildren()) do
		            if v:IsA("TextButton") and v.Text == Name then v:Destroy() end
		        end
		    end
		    DropdownSearch:GetPropertyChangedSignal("Text"):Connect(function()
		        local Search = DropdownSearch.Text:lower()
		        for _, v in pairs(DropdownOptionsFrame:GetChildren()) do
		            if v:IsA("TextButton") then
		                v.Visible = v.Text:lower():find(Search) and true or false
		            end
		        end
		    end)
		    OptionsButton.MouseButton1Click:Connect(function()
		        Toggle(not DropdownOutsideFrame.Visible or DropdownOutsideFrame.Size.Y.Offset == 0)
		    end)
		    OutsideButton.MouseButton1Click:Connect(function()
		        Toggle(false)
		    end)
		    function Dropdown:SetTitle(Text) DropdownTitle.Text = Text end
		    function Dropdown:SetDesc(Text) DropdownDescription.Text = Text end
		    function Dropdown:SetVisible(Value) DropdownFrame.Visible = Value end
		    function Dropdown:Destroy() 
		        DropdownFrame:Destroy() 
		        DropdownOutsideFrame:Destroy()
		    end
		    if DDefault then
		        if type(DDefault) == "table" then
		            Dropdown.Selected = DDefault
		        else
		            Dropdown.Selected = {DDefault}
		        end
		    end
		    Dropdown:SetOptions(DOptions)
		    UpdateValue()
		    return Dropdown
		end
		
		function Tab:AddColorpicker(Configs)
		    local Configs = Someone:ResolveConfigs(Configs)
		    local CTitle = Configs.title or Configs.name or "Color Title"
		    local CDesc = Configs.description or "Color Description"
		    local CDefault = Configs.default or Color3.fromRGB(255, 0, 0)
		    local CCallback = Configs.callback or function() end
		
		    local ColorpickerFrame = New("Frame", {AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Color3.fromRGB(35, 35, 35), BorderSizePixel = 0, ClipsDescendants = true, LayoutOrder = Tab:GetNextOrder(), Name = "Colorpicker Frame", Size = UDim2.new(1, -10, 0, 30), Parent = CurrentTabContent})
		    local ColorpickerTitle = New("TextLabel", {AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Font = Enum.Font.GothamMedium, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal), Name = "Colorpicker Title", Position = UDim2.new(0, 5, 0, 3), RichText = true, Size = UDim2.new(0, 0, 0, 12), Text = CTitle, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 10, TextTruncate = Enum.TextTruncate.SplitWord, TextXAlignment = Enum.TextXAlignment.Left, Parent = ColorpickerFrame})
		    local ColorpickerDescription = New("TextLabel", {AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Font = Enum.Font.Gotham, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal), Name = "Colorpicker Description", Position = UDim2.new(0, 5, 0, 18), RichText = true, Size = UDim2.new(0, 0, 0, 10), Text = CDesc, TextColor3 = Color3.fromRGB(180, 180, 180), TextTruncate = Enum.TextTruncate.SplitWord, Parent = ColorpickerFrame})
		    New("UICorner", {CornerRadius = UDim.new(0, 4), Parent = ColorpickerFrame})
		    local ColorButton = New("TextButton", {BackgroundColor3 = CDefault, BorderSizePixel = 0, ClipsDescendants = true, Name = "Color Button", Position = UDim2.new(1, -30, 0, 3), RichText = true, Size = UDim2.new(0, 24, 1, -6), Text = "", Parent = ColorpickerFrame})
		    New("UICorner", {CornerRadius = UDim.new(0, 4), Parent = ColorButton})
		    local ColorpickerOutside = New("Frame", {BackgroundColor3 = Color3.fromRGB(35, 35, 35), BorderSizePixel = 0, ClipsDescendants = true, Name = "Colorpicker Outside", Position = UDim2.new(0, WindowFrame.AbsolutePosition.X + WindowFrame.AbsoluteSize.X + 5, 0, WindowFrame.Position.Y.Offset), Size = UDim2.new(0, 165, 0, 0), Visible = false, ZIndex = 10, Parent = Colorpickers})
		    New("UICorner", {CornerRadius = UDim.new(0, 4), Parent = ColorpickerOutside})
		    local Colorbox = New("ImageLabel", {Active = true, BackgroundColor3 = Color3.fromHSV(Color3.toHSV(CDefault)), BorderSizePixel = 0, ClipsDescendants = true, Image = "rbxassetid://11415645739", Name = "Colorbox", Position = UDim2.new(0, 5, 0, 5), Size = UDim2.new(0, 130, 0, 130), Parent = ColorpickerOutside})
		    local Indicator = New("Frame", {Active = true, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, Name = "Indicator", Size = UDim2.new(0, 10, 0, 10), Parent = Colorbox})
		    New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Indicator})
		    New("UIStroke", {ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = Indicator})
		    local ColorSelectFrame = New("Frame", {Active = true, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, ClipsDescendants = true, Name = "Color Select Frame", Position = UDim2.new(0, 140, 0, 5), Size = UDim2.new(0, 20, 1, -10), Parent = ColorpickerOutside})
		    New("UIGradient", {Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(0.14, Color3.fromRGB(255, 0, 255)), ColorSequenceKeypoint.new(0.28, Color3.fromRGB(0, 0, 255)), ColorSequenceKeypoint.new(0.42, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.56, Color3.fromRGB(0, 255, 0)), ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 255, 0)), ColorSequenceKeypoint.new(0.85, Color3.fromRGB(255, 127, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))}, Rotation = 90, Parent = ColorSelectFrame})
		    local FillFrame = New("Frame", {Active = true, BackgroundColor3 = Color3.fromRGB(255, 255, 255), ClipsDescendants = true, Name = "Fill Frame", Position = UDim2.new(0, -2, 0, 0), Size = UDim2.new(1, 4, 0, 2), Parent = ColorSelectFrame})
		    New("UIStroke", {ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = FillFrame})
		    New("UICorner", {Parent = FillFrame})
		
		    local Colorpicker = {Value = CDefault}
		    local H, S, V = Color3.toHSV(CDefault)
		    local DraggingHue = false
		    local DraggingBox = false
		
		    local function UpdateColor()
		        local FinalColor = Color3.fromHSV(H, S, V)
		        ColorButton.BackgroundColor3 = FinalColor
		        Colorbox.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
		        Indicator.Position = UDim2.new(math.clamp(S, 0, 1), -5, 1 - math.clamp(V, 0, 1), -5)
		        FillFrame.Position = UDim2.new(0, -2, math.clamp(H, 0, 1), -1)
		        Colorpicker.Value = FinalColor
		        CCallback(FinalColor)
		    end
		    local function Toggle(State)
		        if State then
		            ColorpickerOutside.Visible = true
		            OutsideButton.Visible = true
		            ColorpickerOutside.Position = UDim2.new(0, WindowFrame.AbsolutePosition.X + WindowFrame.AbsoluteSize.X + 5, 0, WindowFrame.Position.Y.Offset)
		            TweenService:Create(ColorpickerOutside, TweenInfo.new(0.2), {Size = UDim2.new(0, 165, 0, 140)}):Play()
		        else
		            OutsideButton.Visible = false
		            local Tween = TweenService:Create(ColorpickerOutside, TweenInfo.new(0.2), {Size = UDim2.new(0, 165, 0, 0)})
		            Tween:Play()
		            Tween.Completed:Connect(function()
		                if not OutsideButton.Visible then ColorpickerOutside.Visible = false end
		            end)
		        end
		    end
		    local function InputHandler(Input)
		        if DraggingHue then
		            local Pos = Input.Position.Y - ColorSelectFrame.AbsolutePosition.Y
		            H = math.clamp(Pos / ColorSelectFrame.AbsoluteSize.Y, 0, 1)
		            UpdateColor()
		        elseif DraggingBox then
		            local PosX = Input.Position.X - Colorbox.AbsolutePosition.X
		            local PosY = Input.Position.Y - Colorbox.AbsolutePosition.Y
		            S = math.clamp(PosX / Colorbox.AbsoluteSize.X, 0, 1)
		            V = 1 - math.clamp(PosY / Colorbox.AbsoluteSize.Y, 0, 1)
		            UpdateColor()
		        end
		    end
		
		    ColorSelectFrame.InputBegan:Connect(function(Input)
		        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
		            DraggingHue = true
		            InputHandler(Input)
		        end
		    end)
		    Colorbox.InputBegan:Connect(function(Input)
		        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
		            DraggingBox = true
		            InputHandler(Input)
		        end
		    end)
		    UserInputService.InputChanged:Connect(function(Input)
		        if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
		            InputHandler(Input)
		        end
		    end)
		    UserInputService.InputEnded:Connect(function(Input)
		        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
		            DraggingHue = false
		            DraggingBox = false
		        end
		    end)
		    ColorButton.MouseButton1Click:Connect(function()
		        Toggle(not ColorpickerOutside.Visible or ColorpickerOutside.Size.Y.Offset == 0)
		    end)
		    OutsideButton.MouseButton1Click:Connect(function()
		        Toggle(false)
		    end)
		    function Colorpicker:SetColor(NewColor)
		        H, S, V = Color3.toHSV(NewColor)
		        UpdateColor()
		    end
		    function Colorpicker:SetTitle(Text)
				ColorpickerTitle.Text = Text
			end
		    function Colorpicker:SetDesc(Text)
				ColorpickerDescription.Text = Text
			end
		    function Colorpicker:SetVisible(Value)
				ColorpickerFrame.Visible = Value
			end
		    function Colorpicker:Destroy()
		        ColorpickerFrame:Destroy()
		        ColorpickerOutside:Destroy()
		    end
		    UpdateColor()
		    return Colorpicker
		end
		
		function Tab:AddDiscord(Configs)
		    local Configs = Someone:ResolveConfigs(Configs)
		    local DInvite = Configs.invite or ""
		
		    task.spawn(function()
		        local Success, Response = pcall(function()
		            return game:HttpGet("https://discord.com/api/v10/invites/" .. DInvite .. "?with_counts=true")
		        end)
		        if Success and Response then
		            local Data = HttpService:JSONDecode(Response)
		            local Guild = Data.guild or {}
		            local Inviter = Data.inviter
		            local Online = Data.approximate_presence_count or 0
		            local Total = Data.approximate_member_count or 0
		
		            local DiscordFrame = New("Frame", {Active = true, BackgroundColor3 = Guild.banner_color and Color3.fromHex(Guild.banner_color) or Color3.fromRGB(35, 35, 35), BorderSizePixel = 0, ClipsDescendants = true, LayoutOrder = Tab:GetNextOrder(), Name = "Discord Frame", Size = UDim2.new(1, -10, 0, 130), Parent = CurrentTabContent})
		            New("UICorner", {CornerRadius = UDim.new(0, 4), Parent = DiscordFrame})
		            local ServerIcon = New("ImageLabel", {BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1, Name = "Server Icon", Position = UDim2.new(0, 10, 0, 30), Size = UDim2.new(0, 70, 0, 70), Image = (Guild.id and Guild.icon) and Someone:GetIcon("https://cdn.discordapp.com/icons/" .. Guild.id .. "/" .. Guild.icon .. ".png?size=1024") or "", Parent = DiscordFrame})
		            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ServerIcon})
		            if Inviter and Inviter.id and Inviter.avatar then
		                local InviterIcon = New("ImageLabel", {BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1, BorderSizePixel = 0, Name = "Inviter Icon", Position = UDim2.new(0, 10, 0, 5), Size = UDim2.new(0, 15, 0, 15), Image = Someone:GetIcon("https://cdn.discordapp.com/avatars/" .. Inviter.id .. "/" .. Inviter.avatar .. ".png?size=1024"), Parent = DiscordFrame, Visible = true})
		                New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = InviterIcon})
		                local InviterTitle = New("TextLabel", {BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Font = Enum.Font.GothamMedium, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal), Name = "Inviter Title", Position = UDim2.new(0, 30, 0, 5), RichText = true, Size = UDim2.new(0, 200, 0, 15), Text = "Invited By " .. (Inviter.global_name or "Unknown") .. "(@" .. (Inviter.username or "unknown") .. ")", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, Parent = DiscordFrame, Visible = true})
		            end
		            local ServerName = New("TextLabel", {BackgroundTransparency = 1, BorderSizePixel = 0, Font = Enum.Font.GothamBlack, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal), Name = "Server Name", Position = UDim2.new(0, 85, 0, 35), RichText = true, Size = UDim2.new(0, 285, 0, 20), Text = Guild.name or "", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 18, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, Parent = DiscordFrame})
		            local ServerDescription = New("TextLabel", {BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Font = Enum.Font.Gotham, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal), Name = "Server Description", Position = UDim2.new(0, 85, 0, 60), RichText = true, Size = UDim2.new(0, 285, 0, 40), Text = Guild.description or "", TextColor3 = Color3.fromRGB(180, 180, 180), TextSize = 12, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, Parent = DiscordFrame})
		            local ServerData = New("TextLabel", {BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Font = Enum.Font.Gotham, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal), Name = "Server Data", Position = UDim2.new(0, 260, 0, 5), RichText = true, Size = UDim2.new(0, 110, 0, 15), Text = "Online: " .. Online .. " | Members: " .. Total, TextColor3 = Color3.fromRGB(255, 255, 255), TextXAlignment = Enum.TextXAlignment.Left, Parent = DiscordFrame})
		            local JoinButton = New("TextButton", {BackgroundColor3 = Color3.fromRGB(0, 255, 0), BorderSizePixel = 0, Font = Enum.Font.Gotham, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal), Name = "Join Button", Position = UDim2.new(1, -80, 1, -40), RichText = true, Size = UDim2.new(0, 70, 0, 30), Text = "Copy Invite", TextColor3 = Color3.fromRGB(0, 0, 0), TextSize = 10, Parent = DiscordFrame})
		            New("UICorner", {CornerRadius = UDim.new(0, 4), Parent = JoinButton})
		
		            JoinButton.MouseButton1Click:Connect(function()
		                setclipboard("https://discord.gg/" .. DInvite)
		            end)
		        end
		    end)
		end
		
		TabButton.MouseButton1Click:Connect(function()
		    for _, v in pairs(TabButton.Parent:GetChildren()) do
		        if v:IsA("TextButton") then
		            local Indicator = v:FindFirstChild("Indicator")
		            if Indicator then Indicator.Visible = false end
		        end
		    end
		    for _, v in pairs(CurrentTabContent.Parent:GetChildren()) do
		        if v:IsA("ScrollingFrame") or v:IsA("Frame") then
		            v.Visible = false
		        end
		    end
		    Indicator.Visible = true
		    CurrentTabContent.Visible = true
		end)
		
		return Tab
	end
	
	CloseButton.MouseButton1Click:Connect(function()
		SomeoneLibrary:Destroy()
	end)
	
	return Window
end

return Someone
