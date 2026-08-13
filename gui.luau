-- gui.luau
-- Grok AI Chat GUI for Roblox Executors

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- ============ CONFIG ============
local Config = getgenv().GrokConfig or {}
local API_KEY = Config.API_KEY or "YOUR_XAI_API_KEY_HERE"
local MODEL = Config.MODEL or "grok-4.6"
local API_URL = Config.API_URL or "https://api.x.ai/v1/chat/completions"
local SYSTEM_PROMPT = [[You are Grok, a helpful and maximally truthful AI built by xAI. 
You are specialized in Roblox Lua scripting, fixing bugs, optimizing code, and explaining concepts clearly.
When the user asks to fix code, reply with a short explanation + the full fixed code inside a ```lua code block.
Always keep answers concise and useful for mobile users.]]
-- ================================

local conversation = {
	{role = "system", content = SYSTEM_PROMPT}
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GrokAIChat"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

-- Main Frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0.92, 0, 0.78, 0)
Main.Position = UDim2.new(0.04, 0, 0.11, 0)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 18)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(55, 55, 70)
MainStroke.Thickness = 1.5
MainStroke.Parent = Main

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 18)
TitleCorner.Parent = TitleBar

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 20)
TitleFix.Position = UDim2.new(0, 0, 1, -20)
TitleFix.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -110, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Grok AI"
Title.TextColor3 = Color3.fromRGB(240, 240, 250)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -48, 0.5, -20)
CloseBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 45)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 110, 110)
CloseBtn.TextSize = 26
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- Chat ScrollingFrame
local ChatFrame = Instance.new("ScrollingFrame")
ChatFrame.Name = "ChatFrame"
ChatFrame.Size = UDim2.new(1, -24, 1, -132)
ChatFrame.Position = UDim2.new(0, 12, 0, 58)
ChatFrame.BackgroundTransparency = 1
ChatFrame.BorderSizePixel = 0
ChatFrame.ScrollBarThickness = 4
ChatFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 110)
ChatFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ChatFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ChatFrame.Parent = Main

local ChatLayout = Instance.new("UIListLayout")
ChatLayout.SortOrder = Enum.SortOrder.LayoutOrder
ChatLayout.Padding = UDim.new(0, 12)
ChatLayout.Parent = ChatFrame

local ChatPadding = Instance.new("UIPadding")
ChatPadding.PaddingTop = UDim.new(0, 6)
ChatPadding.PaddingBottom = UDim.new(0, 10)
ChatPadding.Parent = ChatFrame

-- Input Bar
local InputBar = Instance.new("Frame")
InputBar.Name = "InputBar"
InputBar.Size = UDim2.new(1, -24, 0, 60)
InputBar.Position = UDim2.new(0, 12, 1, -72)
InputBar.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
InputBar.BorderSizePixel = 0
InputBar.Parent = Main

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 14)
InputCorner.Parent = InputBar

local TextBox = Instance.new("TextBox")
TextBox.Name = "MessageBox"
TextBox.Size = UDim2.new(1, -92, 1, -16)
TextBox.Position = UDim2.new(0, 12, 0, 8)
TextBox.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
TextBox.BorderSizePixel = 0
TextBox.Text = ""
TextBox.PlaceholderText = "Ask Grok anything..."
TextBox.PlaceholderColor3 = Color3.fromRGB(130, 130, 150)
TextBox.TextColor3 = Color3.fromRGB(235, 235, 245)
TextBox.TextSize = 16
TextBox.Font = Enum.Font.Gotham
TextBox.TextXAlignment = Enum.TextXAlignment.Left
TextBox.TextWrapped = true
TextBox.ClearTextOnFocus = false
TextBox.Parent = InputBar

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 10)
BoxCorner.Parent = TextBox

local BoxPadding = Instance.new("UIPadding")
BoxPadding.PaddingLeft = UDim.new(0, 12)
BoxPadding.PaddingRight = UDim.new(0, 8)
BoxPadding.Parent = TextBox

local SendBtn = Instance.new("TextButton")
SendBtn.Name = "SendButton"
SendBtn.Size = UDim2.new(0, 70, 0, 44)
SendBtn.Position = UDim2.new(1, -80, 0.5, -22)
SendBtn.BackgroundColor3 = Color3.fromRGB(70, 120, 255)
SendBtn.Text = "Send"
SendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SendBtn.TextSize = 16
SendBtn.Font = Enum.Font.GothamBold
SendBtn.Parent = InputBar

local SendCorner = Instance.new("UICorner")
SendCorner.CornerRadius = UDim.new(0, 10)
SendCorner.Parent = SendBtn

-- Dragging
local dragging, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Message helpers
local function scrollToBottom()
	task.wait()
	ChatFrame.CanvasPosition = Vector2.new(0, ChatFrame.AbsoluteCanvasSize.Y)
end

local function createBubble(text, isUser)
	local msg = Instance.new("Frame")
	msg.Size = UDim2.new(1, 0, 0, 0)
	msg.AutomaticSize = Enum.AutomaticSize.Y
	msg.BackgroundTransparency = 1
	msg.Parent = ChatFrame

	local bubble = Instance.new("Frame")
	bubble.Size = UDim2.new(0.88, 0, 0, 0)
	bubble.AutomaticSize = Enum.AutomaticSize.Y
	bubble.BackgroundColor3 = isUser and Color3.fromRGB(55, 95, 210) or Color3.fromRGB(35, 35, 45)
	bubble.BorderSizePixel = 0
	bubble.Parent = msg

	if isUser then
		bubble.Position = UDim2.new(0.12, 0, 0, 0)
	end

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 14)
	corner.Parent = bubble

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 0, 0)
	label.Position = UDim2.new(0, 10, 0, 10)
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(235, 235, 245)
	label.TextSize = 15
	label.Font = Enum.Font.Gotham
	label.TextWrapped = true
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.Parent = bubble

	local pad = Instance.new("UIPadding")
	pad.PaddingBottom = UDim.new(0, 12)
	pad.Parent = bubble

	scrollToBottom()
	return msg
end

local function createCodeBlock(code)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 0)
	container.AutomaticSize = Enum.AutomaticSize.Y
	container.BackgroundTransparency = 1
	container.Parent = ChatFrame

	local bubble = Instance.new("Frame")
	bubble.Size = UDim2.new(0.94, 0, 0, 0)
	bubble.AutomaticSize = Enum.AutomaticSize.Y
	bubble.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
	bubble.BorderSizePixel = 0
	bubble.Parent = container

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = bubble

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(65, 65, 85)
	stroke.Thickness = 1
	stroke.Parent = bubble

	local header = Instance.new("Frame")
	header.Size = UDim2.new(1, 0, 0, 38)
	header.BackgroundColor3 = Color3.fromRGB(34, 34, 44)
	header.BorderSizePixel = 0
	header.Parent = bubble

	local headerCorner = Instance.new("UICorner")
	headerCorner.CornerRadius = UDim.new(0, 12)
	headerCorner.Parent = header

	local headerFix = Instance.new("Frame")
	headerFix.Size = UDim2.new(1, 0, 0, 14)
	headerFix.Position = UDim2.new(0, 0, 1, -14)
	headerFix.BackgroundColor3 = Color3.fromRGB(34, 34, 44)
	headerFix.BorderSizePixel = 0
	headerFix.Parent = header

	local codeTitle = Instance.new("TextLabel")
	codeTitle.Size = UDim2.new(1, -90, 1, 0)
	codeTitle.Position = UDim2.new(0, 14, 0, 0)
	codeTitle.BackgroundTransparency = 1
	codeTitle.Text = "Code"
	codeTitle.TextColor3 = Color3.fromRGB(160, 160, 185)
	codeTitle.TextSize = 13
	codeTitle.Font = Enum.Font.GothamMedium
	codeTitle.TextXAlignment = Enum.TextXAlignment.Left
	codeTitle.Parent = header

	local copyBtn = Instance.new("TextButton")
	copyBtn.Size = UDim2.new(0, 72, 0, 28)
	copyBtn.Position = UDim2.new(1, -82, 0.5, -14)
	copyBtn.BackgroundColor3 = Color3.fromRGB(60, 110, 230)
	copyBtn.Text = "Copy"
	copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	copyBtn.TextSize = 13
	copyBtn.Font = Enum.Font.GothamBold
	copyBtn.Parent = header

	local copyCorner = Instance.new("UICorner")
	copyCorner.CornerRadius = UDim.new(0, 8)
	copyCorner.Parent = copyBtn

	copyBtn.MouseButton1Click:Connect(function()
		if setclipboard then
			setclipboard(code)
			copyBtn.Text = "Copied!"
			copyBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 90)
			task.delay(1.4, function()
				if copyBtn and copyBtn.Parent then
					copyBtn.Text = "Copy"
					copyBtn.BackgroundColor3 = Color3.fromRGB(60, 110, 230)
				end
			end)
		else
			copyBtn.Text = "No clip"
			task.delay(1.2, function()
				if copyBtn and copyBtn.Parent then
					copyBtn.Text = "Copy"
				end
			end)
		end
	end)

	local codeLabel = Instance.new("TextLabel")
	codeLabel.Size = UDim2.new(1, -20, 0, 0)
	codeLabel.Position = UDim2.new(0, 10, 0, 44)
	codeLabel.AutomaticSize = Enum.AutomaticSize.Y
	codeLabel.BackgroundTransparency = 1
	codeLabel.Text = code
	codeLabel.TextColor3 = Color3.fromRGB(190, 215, 255)
	codeLabel.TextSize = 13
	codeLabel.Font = Enum.Font.Code
	codeLabel.TextWrapped = true
	codeLabel.TextXAlignment = Enum.TextXAlignment.Left
	codeLabel.TextYAlignment = Enum.TextYAlignment.Top
	codeLabel.Parent = bubble

	local pad = Instance.new("UIPadding")
	pad.PaddingBottom = UDim.new(0, 14)
	pad.Parent = bubble

	scrollToBottom()
end

-- Call AI API
local function askGrok(userMessage)
	table.insert(conversation, {role = "user", content = userMessage})

	local body = {
		model = MODEL,
		messages = conversation,
		stream = false,
		temperature = 0.6
	}

	local success, response = pcall(function()
		return HttpService:RequestAsync({
			Url = API_URL,
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json",
				["Authorization"] = "Bearer " .. API_KEY
			},
			Body = HttpService:JSONEncode(body)
		})
	end)

	if not success then
		return nil, "Request failed: " .. tostring(response)
	end

	if not response.Success then
		return nil, "API Error " .. response.StatusCode .. ": " .. (response.Body or "")
	end

	local data = HttpService:JSONDecode(response.Body)
	local content = data.choices and data.choices[1] and data.choices[1].message and data.choices[1].message.content

	if content then
		table.insert(conversation, {role = "assistant", content = content})
		return content, nil
	else
		return nil, "Invalid response from AI"
	end
end

-- Parse response for code blocks
local function displayAIResponse(text)
	local remaining = text
	local patterns = {"```lua", "```Luau", "```"}

	while true do
		local startIdx, endIdx
		for _, p in ipairs(patterns) do
			local s, e = string.find(remaining, p, 1, true)
			if s and (not startIdx or s < startIdx) then
				startIdx = s
				endIdx = e
			end
		end

		if not startIdx then
			if remaining:match("%S") then
				createBubble(remaining:gsub("^%s+", ""):gsub("%s+$", ""), false)
			end
			break
		end

		local before = remaining:sub(1, startIdx - 1):gsub("^%s+", ""):gsub("%s+$", "")
		if before ~= "" then
			createBubble(before, false)
		end

		local afterStart = endIdx + 1
		local closeIdx = string.find(remaining, "```", afterStart, true)
		if closeIdx then
			local code = remaining:sub(afterStart, closeIdx - 1):gsub("^%s*\n", ""):gsub("\n%s*$", "")
			if code ~= "" then
				createCodeBlock(code)
			end
			remaining = remaining:sub(closeIdx + 3)
		else
			local code = remaining:sub(afterStart):gsub("^%s*\n", "")
			createCodeBlock(code)
			break
		end
	end
end

-- Send
local isSending = false

local function sendMessage()
	if isSending then return end
	local text = TextBox.Text
	if text == "" or text:match("^%s*$") then return end

	isSending = true
	TextBox.Text = ""
	SendBtn.Text = "..."
	SendBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)

	createBubble(text, true)

	local thinking = createBubble("Thinking...", false)

	task.spawn(function()
		local reply, err = askGrok(text)

		if thinking and thinking.Parent then
			thinking:Destroy()
		end

		if reply then
			displayAIResponse(reply)
		else
			createBubble("Error: " .. (err or "Unknown"), false)
		end

		isSending = false
		SendBtn.Text = "Send"
		SendBtn.BackgroundColor3 = Color3.fromRGB(70, 120, 255)
	end)
end

SendBtn.MouseButton1Click:Connect(sendMessage)
TextBox.FocusLost:Connect(function(enter)
	if enter then sendMessage() end
end)

-- Welcome
task.wait(0.2)
createBubble("Hey! I'm Grok.\n\nAsk me to fix scripts, explain code, or anything Roblox related.\nJust type and hit Send.", false)
