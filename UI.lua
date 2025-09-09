-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

-- Variables
local localPlayer = Players.LocalPlayer
local localMouse = localPlayer:GetMouse()

local Storage = {InputBegan = {}, InputEnded = {}, InputMoved = {}}

local ui = {
	Color = {
		Add = function(c1, c2)
			if typeof(c1) ~= "Color3" or typeof(c2) ~= "Color3" then
				warn("Invalid Color3 values passed to Add function")
				return Color3.fromRGB(255, 255, 255)
			end
			return Color3.fromRGB(
				math.min(c1.R * 255 + c2.R * 255, 255),
				math.min(c1.G * 255 + c2.G * 255, 255),
				math.min(c1.B * 255 + c2.B * 255, 255)
			)
		end,
		Sub = function(c1, c2)
			if typeof(c1) ~= "Color3" or typeof(c2) ~= "Color3" then
				warn("Invalid Color3 values passed to Sub function")
				return Color3.fromRGB(0, 0, 0)
			end
			return Color3.fromRGB(
				math.max(c1.R * 255 - c2.R * 255, 0),
				math.max(c1.G * 255 - c2.G * 255, 0),
				math.max(c1.B * 255 - c2.B * 255, 0)
			)
		end,
		ToFormat = function(c)
			if typeof(c) ~= "Color3" then
				warn("Invalid Color3 value passed to ToFormat function")
				return "rgb(0, 0, 0)"
			end
			return ("rgb(%d, %d, %d)"):format(
				math.floor(c.R * 255),
				math.floor(c.G * 255),
				math.floor(c.B * 255)
			)
		end
	}
}

-- Functions
ui.Create = function(class, properties, radius)
	local instance = Instance.new(class)
	for i, v in pairs(properties) do
		if i ~= "Parent" then
			if typeof(v) == "Instance" then
				v.Parent = instance
			else
				instance[i] = v
			end
		end
	end
	if radius then
		local uicorner = Instance.new("UICorner")
		uicorner.CornerRadius = radius
		uicorner.Parent = instance
	end
	return instance
end

ui.MakeDraggable = function(obj, dragObj, smoothness)
	local startPos = nil
	local dragging = false
	Storage.InputBegan[dragObj] = dragObj.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			startPos = Vector2.new(localMouse.X - obj.AbsolutePosition.X, localMouse.Y - obj.AbsolutePosition.Y)
		end
	end)
	Storage.InputEnded[dragObj] = dragObj.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	Storage.InputMoved[dragObj] = localMouse.Move:Connect(function()
		if dragging then
			TweenService:Create(obj, TweenInfo.new(math.clamp(smoothness, 0, 1), Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				Position = UDim2.new(0, localMouse.X - startPos.X, 0, localMouse.Y - startPos.Y)
			}):Play()
		end
	end)
end

ui.UnMakeDraggable = function(dragObj)
	if Storage.InputBegan[dragObj] then Storage.InputBegan[dragObj]:Disconnect() end
	if Storage.InputEnded[dragObj] then Storage.InputEnded[dragObj]:Disconnect() end
	if Storage.InputMoved[dragObj] then Storage.InputMoved[dragObj]:Disconnect() end

	Storage.InputBegan[dragObj] = nil
	Storage.InputEnded[dragObj] = nil
	Storage.InputMoved[dragObj] = nil
end

-- Main
return ui
