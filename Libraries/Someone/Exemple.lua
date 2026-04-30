local Library = loadstring(readfile("Projects/Library/Someone/Source.lua"))()

local Window = Library:AddWindow({
	Title = "Main Window",
	SubTitle = "by Someone",
})

Window:AddMinimizer({
	Size = UDim2.fromOffset(50, 50),
	Position = UDim2.fromOffset(100, 60),
	CornerRadius = UDim.new(0, 4),
	Icon = "rbxassetid://6026643035"
})

local Tab = Window:AddTab({
	Name = "Main Tab",
	Icon = "mouse",
})

local Section = Tab:AddSection("Section")

local P = Tab:AddParagraph({
	Title = "Paragraph Title",
	Description = "Paragraph Description",
})

Tab:AddButton({
	Name = "Button Title",
	Description = "Button Description",
	Callback = function()
		print("Button")
	end
})

Tab:AddToggle({
	Name = "Toggle Example",
	Description = "Toggle Description",
	Default = true,
	Callback = function(Value)
		print("Toggle")
	end
})

Tab:AddSlider({
	Name = "Slider Title",
	Description = "Slider Description",
	Min = 0,
	Max = 100,
	Default = 50,
	Increase = 10,
	Callback = function(Value)
		print("Slider")
	end
})

Tab:AddDropdown({
	Name = "Dropdown Title",
	Description = "Dropdown Description",
	Options = {"A", "B", "C"},
	Default = "A",
	Multi = true,
	Search = true,
	Callback = function(Value)
		print("Dropdown")
	end
})

Tab:AddColorpicker({
	Title = "Colorpicker Title",
	Description = "Colorpicker Description",
	Default = Color3.fromRGB(255, 0, 0),
	Callback = function(Value)
		print("Colorpicker")
	end
})

Tab:AddDiscord({
	Invite = "SUNvuPyUaC"
})
