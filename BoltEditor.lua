local player = game.Players.LocalPlayer

-- GUI base
local gui = Instance.new("ScreenGui")
gui.Name = "TabEditor"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 600, 0, 450)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 25)
header.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
header.BorderSizePixel = 0
header.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "script viewer "
title.Font = Enum.Font.SourceSansSemibold
title.TextSize = 18
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = header

local uicornerClose = Instance.new("UICorner")
uicornerClose.CornerRadius = UDim.new(0, 6)
uicornerClose.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- 🧩 Scroll de pestañas
local tabScroll = Instance.new("ScrollingFrame")
tabScroll.Size = UDim2.new(1, 0, 0, 30)
tabScroll.Position = UDim2.new(0, 0, 0, 25)
tabScroll.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
tabScroll.BorderSizePixel = 0
tabScroll.ScrollBarThickness = 6
tabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
tabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
tabScroll.ScrollingDirection = Enum.ScrollingDirection.X
tabScroll.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 6)
tabLayout.Parent = tabScroll

local editorScroll = Instance.new("ScrollingFrame")
editorScroll.Size = UDim2.new(1, -10, 1, -65)
editorScroll.Position = UDim2.new(0, 5, 0, 55)
editorScroll.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
editorScroll.BorderSizePixel = 0
editorScroll.ScrollBarThickness = 8
editorScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
editorScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
editorScroll.ClipsDescendants = true
editorScroll.Parent = mainFrame

local tabs = {}
local currentTab = nil

local function generarNumerosLineas(texto)
	local lineas = select(2, texto:gsub("\n", "\n")) + 1
	local contenido = ""
	for i = 1, lineas do
		contenido ..= i .. "\n"
	end
	return contenido
end

local function setActiveTab(tabId)
	for id, data in pairs(tabs) do
		data.tabButton.BackgroundColor3 = id == tabId and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(60, 60, 60)
		data.frame.Visible = id == tabId
	end
	currentTab = tabId
end

local function crearPestania(nombre)
	local count = 0
	for _ in pairs(tabs) do count += 1 end
	nombre = nombre or ("Script " .. tostring(count + 1))

	local id = tostring(math.random(100000, 999999))

	local tabBtn = Instance.new("Frame")
	tabBtn.Size = UDim2.new(0, 120, 1, 0)
	tabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	tabBtn.BorderSizePixel = 0
	tabBtn.Name = "Tab_" .. id
	tabBtn.Parent = tabScroll

	local uicornerTab = Instance.new("UICorner")
	uicornerTab.CornerRadius = UDim.new(0, 6)
	uicornerTab.Parent = tabBtn

	local text = Instance.new("TextButton")
	text.Size = UDim2.new(1, -25, 1, 0)
	text.Position = UDim2.new(0, 0, 0, 0)
	text.Text = nombre
	text.Font = Enum.Font.SourceSans
	text.TextSize = 16
	text.TextColor3 = Color3.new(1, 1, 1)
	text.BackgroundTransparency = 1
	text.Parent = tabBtn

	local close = Instance.new("TextButton")
	close.Size = UDim2.new(0, 20, 0, 20)
	close.Position = UDim2.new(1, -20, 0.5, -10)
	close.Text = "x"
	close.Font = Enum.Font.SourceSansBold
	close.TextSize = 16
	close.TextColor3 = Color3.new(1, 1, 1)
	close.BackgroundTransparency = 1
	close.Parent = tabBtn

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 0) -- Alto inicial 0, crecerá con contenido
	frame.BackgroundTransparency = 1
	frame.Visible = false
	frame.Parent = editorScroll

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, -50, 0, 0) -- Alto 0 inicial
	box.Position = UDim2.new(0, 50, 0, 0)
	box.BackgroundColor3 = Color3.fromRGB(54, 57, 78)
	box.TextColor3 = Color3.fromRGB(236, 240, 241)
	box.Font = Enum.Font.Code
	box.TextSize = 18
	box.MultiLine = true
	box.ClearTextOnFocus = false
	box.TextWrapped = false
	box.TextXAlignment = Enum.TextXAlignment.Left
	box.TextYAlignment = Enum.TextYAlignment.Top
	box.AutomaticSize = Enum.AutomaticSize.Y
	box.Text = "-- Tu código aquí"
	box.Parent = frame

	local uicornerBox = Instance.new("UICorner")
	uicornerBox.CornerRadius = UDim.new(0, 6)
	uicornerBox.Parent = box

	local lineNums = Instance.new("TextLabel")
	lineNums.Size = UDim2.new(0, 40, 0, 0)
	lineNums.Position = UDim2.new(0, 0, 0, 0)
	lineNums.BackgroundColor3 = Color3.fromRGB(47, 49, 66)
	lineNums.TextColor3 = Color3.fromRGB(189, 195, 199)
	lineNums.Font = Enum.Font.Code
	lineNums.TextSize = 18
	lineNums.TextXAlignment = Enum.TextXAlignment.Center
	lineNums.TextYAlignment = Enum.TextYAlignment.Top
	lineNums.Text = "1"
	lineNums.AutomaticSize = Enum.AutomaticSize.Y
	lineNums.Parent = frame

	local function updateLines()
		local count = select(2, box.Text:gsub("\n", "")) + 1
		local text = ""
		for i = 1, count do
			text ..= i .. "\n"
		end
		lineNums.Text = text
		local contentHeight = box.TextBounds.Y + 10
		frame.Size = UDim2.new(1, 0, 0, contentHeight)
		box.Size = UDim2.new(1, -50, 0, contentHeight)
		lineNums.Size = UDim2.new(0, 40, 0, contentHeight)
		editorScroll.CanvasSize = UDim2.new(0, 0, 0, math.max(contentHeight, editorScroll.AbsoluteSize.Y))
	end

	box:GetPropertyChangedSignal("Text"):Connect(updateLines)
	updateLines()

	tabs[id] = {
		tabButton = tabBtn,
		frame = frame,
		textBox = box,
		numLabel = lineNums,
	}

	text.MouseButton1Click:Connect(function()
		setActiveTab(id)
	end)

	close.MouseButton1Click:Connect(function()
		tabBtn:Destroy()
		frame:Destroy()
		tabs[id] = nil

		if currentTab == id then
			for k in pairs(tabs) do
				setActiveTab(k)
				break
			end
		end
	end)

	setActiveTab(id)
end

local addTabBtn = Instance.new("TextButton")
addTabBtn.Size = UDim2.new(0, 30, 1, 0)
addTabBtn.Text = "+"
addTabBtn.Font = Enum.Font.SourceSansBold
addTabBtn.TextSize = 22
addTabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
addTabBtn.TextColor3 = Color3.new(1, 1, 1)
addTabBtn.BorderSizePixel = 0
addTabBtn.Parent = tabScroll

local uicornerAdd = Instance.new("UICorner")
uicornerAdd.CornerRadius = UDim.new(0, 6)
uicornerAdd.Parent = addTabBtn

addTabBtn.MouseButton1Click:Connect(function()
	crearPestania()
end)

crearPestania("Script 1")
