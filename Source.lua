-- Library

local Library = {
	Theme = {
		Accent = Color3.fromRGB(0, 255, 0),
		TopbarColor = Color3.fromRGB(20, 20, 20),
		SidebarColor = Color3.fromRGB(15, 15, 15),
		BackgroundColor = Color3.fromRGB(10, 10, 10),
		SectionColor = Color3.fromRGB(20, 20, 20),
		TextColor = Color3.fromRGB(255, 255, 255),
	},
	Sound = {
		ID = 89087762338808,
	},
	Notif = {
		Active = {},
		Queue = {},
		IsBusy = false,
	},
	Settings = {
		ConfigPath = nil,
		MaxNotifLines = 5,
		MaxNotifStacking = 12,
		Acrylic = false,
		AcrylicBody = Instance.new("Folder"),
	},
}

-- Services

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RDS = game:GetService("ReplicatedStorage")
local RBXAS = game:GetService("RbxAnalyticsService")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local TXS = game:GetService("TextService")
local HS = game:GetService("HttpService")
local MPS = game:GetService("MarketplaceService")
local VG = game:GetService("CoreGui") -- RS:IsStudio() and game:GetService("CoreGui") or Players.LocalPlayer:WaitForChild("PlayerGui")

-- Info

local DeviceId = "Unknown"
local HardwareId = "Unknown"

--[[if not RS:IsStudio() then
	if UIS:GetPlatform() then
		if UIS:GetPlatform() == Enum.Platform.UWP or
			Enum.Platform.Windows or
			Enum.Platform.Linux or
			Enum.Platform.OSX then
			DeviceId = "PC"
		elseif UIS:GetPlatform() == Enum.Platform.IOS or
			Enum.Platform.Android or
			Enum.Platform.Ouya then
			DeviceId = "Mobile"
		end
	end
	if RBXAS:GetClientId() then
		HardwareId = RBXAS:GetClientId()
	end
end]]

-- Variables

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

--local SelfModules = {UI = RS:IsStudio() and require(script.Parent:FindFirstChild("UI.lua")) or loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularSVyixiu/UI-Library/refs/heads/main/UI.lua")())}
local SelfModules = {UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularSVyixiu/newUI-Library/refs/heads/main/UI.lua"))()}
local Storage = { Connections = {ForAuth = {}}, Tween = { Cosmetic = {} } }

local ListenForInput = false
local SelectedButtonTab = nil

-- Misc Functions

local function tween(...)
	local args = {...}

	if typeof(args[2]) ~= "string" then
		table.insert(args, 2, "")
	end

	local tween = TS:Create(args[1], TweenInfo.new(args[3] + 0.05, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), args[4])

	if args[2] == "Cosmetic" then
		Storage.Tween.Cosmetic[args[1]] = tween

		task.spawn(function()
			task.wait(args[3])

			if Storage.Tween.Cosmetic[tween] then
				Storage.Tween.Cosmetic[tween] = nil
			end
		end)
	end

	tween:Play()
end

local ScreenGui = SelfModules.UI.Create("ScreenGui", {
	Name = "Vynixius UI Library",
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	DisplayOrder = 999,
	ResetOnSpawn = false,
})

-- Functions

function Library:Destroy()
	if ScreenGui.Parent then
		ScreenGui:Destroy()
	end
end

function Library:GetScreenGui()
	if ScreenGui then
		return ScreenGui
	end
end

function Library:Sound(id)
	if id ~= nil then
		-- Remove any spaces
		local newId = tostring(id):gsub("%s", "")

		-- Convert to number
		local numericId = tonumber(newId)

		if numericId then
			Library.Sound.ID = numericId
		else
			warn("Invalid Sound ID: must be a number")
		end
	end
end


function Library:FormatText(text1, text2, color)
	return string.format("%s <font color='%s'><b>%s</b></font>", text1, SelfModules.UI.Color.ToFormat(color), text2)
end

function Library:Arraylist()
	local Arraylist = {
		Type = "Arraylist",
		List = {},
	}

	Arraylist.Frame = SelfModules.UI.Create("Frame", {
		Name = "Arraylist",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 10, 0, 10),
		Size = UDim2.new(1, -20, 1, -20),
		SelfModules.UI.Create("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 2)
		})
	})

	Arraylist.Frame.Parent = ScreenGui

	function Arraylist:Add(name, options)
		if Arraylist.List[name] == nil then
			local ArrayItem = SelfModules.UI.Create("Frame", {
				Name = name,
				BackgroundColor3 = Library.Theme.TopbarColor,
				BackgroundTransparency = options.Background and options.Transparency or options.Background and 0.35 or 1,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0, 0, 0, 0),

				SelfModules.UI.Create("UIStroke", {
					Name = "Stroke",
					Thickness = 1.7,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Transparency = 0.8,
					Enabled = true
				}),

				SelfModules.UI.Create("Frame", {
					Name = "Line",
					BackgroundColor3 = options.Color or Library.Theme.TextColor,
					Position = UDim2.new(1, 0, 0, 0),
					Size = UDim2.new(0.1, 0, 1, 0),

					SelfModules.UI.Create("Frame", {
						Name = "Fill",
						Size = UDim2.new(0.5, 0, 1, 0),
						BackgroundColor3 = options.Color or Library.Theme.TextColor,
						BorderSizePixel = 0,
					}),

					SelfModules.UI.Create("ImageLabel", {
						Name = "Glow",
						BackgroundTransparency = 1,
						Position = UDim2.new(0, -8, 0, -8),
						Size = UDim2.new(1, 16, 1, 16),
						Image = "rbxassetid://10822615828",
						ImageTransparency = 0.65,
						ImageColor3 = options.Color or Library.Theme.TextColor,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(99, 99, 99, 99),
						ZIndex = 2,
					}),
				}, UDim.new(0, 5)),

				SelfModules.UI.Create("Frame", {
					Name = "Frame2",
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(1, 0, 1, 0),
					ClipsDescendants = true,

					SelfModules.UI.Create("TextLabel", {
						Name = "Label",
						BackgroundTransparency = 1,
						Position = UDim2.new(0, -8, 0, 0),
						Size = UDim2.new(1, 0, 1, 0),
						Font = Enum.Font.SourceSans,
						Text = options.Text or "",
						RichText = options.RichText or false,
						TextColor3 = options.TextColor or Color3.fromRGB(255, 255, 255),
						TextSize = 16,
						TextXAlignment = Enum.TextXAlignment.Right,
					})
				})
			}, UDim.new(0, 3))

			local textSize = TXS:GetTextSize(ArrayItem.Frame2.Label.ContentText, ArrayItem.Frame2.Label.TextSize, ArrayItem.Frame2.Label.Font, Vector2.new(0, 25)).X + 16
			tween(ArrayItem, 0.5, { Size = UDim2.new(0, textSize, 0, 25) })
			ArrayItem.Parent = Arraylist.Frame
			Arraylist.List[name] = ArrayItem

			-- Sort and update LayoutOrder
			local sortedItems = {}
			for itemName, item in pairs(Arraylist.List) do
				table.insert(sortedItems, item)
			end

			table.sort(sortedItems, function(a, b)
				return a.Frame2.Label.TextBounds.X > b.Frame2.Label.TextBounds.X
			end)

			for index, item in ipairs(sortedItems) do
				item.LayoutOrder = index
			end
		end
	end

	function Arraylist:Edit(name, options)
		local ArrayItem = Arraylist.List[name]
		if ArrayItem then
			if options.Text then
				ArrayItem.Frame2.Label.Text = options.Text
			end
			if options.RichText ~= nil then
				ArrayItem.Frame2.Label.RichText = options.RichText
			end
			if options.Background ~= nil then
				ArrayItem.BackgroundTransparency = options.Background and options.Transparency or options.Background and 0.35 or 1
			end
			if options.Color then
				ArrayItem.Line.Glow.ImageColor3 = options.Color
			end
			if options.TextColor then
				ArrayItem.Frame2.Label.TextColor3 = options.TextColor
			end
			local textSize = TXS:GetTextSize(ArrayItem.Frame2.Label.ContentText, ArrayItem.Frame2.Label.TextSize, ArrayItem.Frame2.Label.Font, Vector2.new(0, 25)).X + 16
			ArrayItem.Size = UDim2.new(0, textSize, 0, 25)
			local sortedItems = {}
			for itemName, item in pairs(Arraylist.List) do
				table.insert(sortedItems, item)
			end

			table.sort(sortedItems, function(a, b)
				return a.Frame2.Label.TextBounds.X > b.Frame2.Label.TextBounds.X
			end)

			for index, item in ipairs(sortedItems) do
				item.LayoutOrder = index
			end
		end
	end

	function Arraylist:Remove(name)
		if  Arraylist.List[name] ~= nil then
			local removingitem = Arraylist.List[name]
			Arraylist.List[name] = nil
			game:GetService("Debris"):AddItem(removingitem, 0.5)
			tween(removingitem, 0.5, { Size = UDim2.new(0, 0, 0, 0) })
		end
	end

	return Arraylist
end

function Library:Notify(options, callback)
	if Library.Notif.IsBusy == true then
		Library.Notif.Queue[#Library.Notif.Queue + 1] = { options, callback }
		return
	end	

	Library.Notif.IsBusy = true

	local Notification = {
		Type = "Notification",
		Selection = nil,
		Callback = callback,
	}

	Notification.Frame = SelfModules.UI.Create("Frame", {
		Name = "Notification",
		BackgroundTransparency = 1,
		ClipsDescendants = false,
		Position = UDim2.new(0, 10, 1, -66),
		Size = UDim2.new(0, 320, 0, 42 + Library.Settings.MaxNotifLines * 14),

		SelfModules.UI.Create("Frame", {
			Name = "Topbar",
			BackgroundColor3 = Library.Theme.TopbarColor,
			Size = UDim2.new(1, 0, 0, 28),

			SelfModules.UI.Create("Frame", {
				Name = "Filling",
				BackgroundColor3 = Library.Theme.TopbarColor,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.new(1, 0, 0.5, 0),
			}),

			SelfModules.UI.Create("TextLabel", {
				Name = "Title",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 7, 0.5, -8),
				Size = UDim2.new(1, -54, 0, 16),
				Font = Enum.Font.SourceSansBold,
				Text = options.title or "Notification",
				TextColor3 = Library.Theme.TextColor,
				TextSize = 16,
				TextXAlignment = Enum.TextXAlignment.Left,
			}),

			SelfModules.UI.Create("ImageButton", {
				Name = "Yes",
				AnchorPoint = Vector2.new(1, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -24, 0.5, -10),
				Size = UDim2.new(0, 20, 0, 20),
				Image = "http://www.roblox.com/asset/?id=7919581359",
				ImageColor3 = Library.Theme.TextColor,
			}),

			SelfModules.UI.Create("ImageButton", {
				Name = "No",
				AnchorPoint = Vector2.new(1, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -2, 0.5, -10),
				Size = UDim2.new(0, 20, 0, 20),
				Image = "http://www.roblox.com/asset/?id=7919583990",
				ImageColor3 = Library.Theme.TextColor,
			}),
		}, UDim.new(0,5)),

		SelfModules.UI.Create("Frame", {
			Name = "Background",
			BackgroundColor3 = Library.Theme.BackgroundColor,
			Position = UDim2.new(0, 0, 0, 28),
			Size = UDim2.new(1, 0, 1, -28),

			SelfModules.UI.Create("TextLabel", {
				Name = "Description",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 7, 0, 7),
				Size = UDim2.new(1, -14, 1, -14),
				Font = Enum.Font.SourceSans,
				Text = options.text,
				TextColor3 = Library.Theme.TextColor,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
			}),

			SelfModules.UI.Create("Frame", {
				Name = "Filling",
				BackgroundColor3 = Library.Theme.BackgroundColor,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 5),
			}),
		}, UDim.new(0, 5)),
	})

	if options.color ~= nil then
		local indicator = SelfModules.UI.Create("Frame", {
			Name = "Indicator",
			BackgroundColor3 = options.color,
			Size = UDim2.new(0, 4, 1, 0),

			SelfModules.UI.Create("ImageLabel", {
				Name = "Glow",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, -13, 0, -13),
				Size = UDim2.new(1, 26, 1, 26),
				Image = "rbxassetid://10822615828",
				ImageColor3 = Library.Theme.Accent,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(99, 99, 99, 99),
				ImageTransparency = 0.9,
				SliceScale = 0.2,
				ZIndex = -1,
			}),

			SelfModules.UI.Create("Frame", {
				Name = "Filling",
				BackgroundColor3 = options.color,
				BorderSizePixel = 0,
				Position = UDim2.new(0.5, 0, 0, 0),
				Size = UDim2.new(0.5, 0, 1, 0),
			}),
		}, UDim.new(0, 3))

		Notification.Frame.Topbar.Title.Position = UDim2.new(0, 11, 0.5, -8)
		Notification.Frame.Topbar.Title.Size = UDim2.new(1, -60, 0, 16)
		Notification.Frame.Background.Description.Position = UDim2.new(0, 11, 0, 7)
		Notification.Frame.Background.Description.Size = UDim2.new(1, -18, 1, -14)
		indicator.Parent = Notification.Frame
	end

	-- Functions

	function Notification:GetHeight()
		local desc = self.Frame.Background.Description

		return 42 + math.round(TXS:GetTextSize(desc.Text, 14, Enum.Font.SourceSans, Vector2.new(desc.AbsoluteSize.X, Library.Settings.MaxNotifStacking * 14)).Y + 0.5)
	end

	function Notification:Select(bool)
		tween(self.Frame.Topbar[bool and "Yes" or "No"], 0.1, { ImageColor3 = bool and Color3.fromRGB(75, 255, 75) or Color3.fromRGB(255, 75, 75) })
		tween(self.Frame, 0.5, { Position = UDim2.new(0, -320, 0, self.Frame.AbsolutePosition.Y) })

		local notifIdx = table.find(Library.Notif.Active, self)

		if notifIdx then
			table.remove(Library.Notif.Active, notifIdx)
			task.delay(0.5, self.Frame.Destroy, self.Frame)
		end

		pcall(task.spawn, self.Callback, bool)
	end

	-- Scripts

	if options.sound ~= 0 or options.sound ~= nil then
		local SoundInstance = Instance.new("Sound")
		SoundInstance.SoundId = "rbxassetid://" .. options.sound
		SoundInstance.Parent = ScreenGui
		SoundInstance:Play()
		SoundInstance.Ended:Connect(function()
			SoundInstance:Destroy()
		end)
	end

	Library.Notif.Active[#Library.Notif.Active + 1] = Notification
	Storage.Connections[Notification] = {}
	Notification.Frame.Size = UDim2.new(0, 320, 0, Notification:GetHeight())
	Notification.Frame.Position = UDim2.new(0, -320, 1, -Notification:GetHeight() - 10)
	Notification.Frame.Parent = ScreenGui

	if #Library.Notif.Active > Library.Settings.MaxNotifStacking then
		Library.Notif.Active[1]:Select(false)
	end

	for i, v in next, Library.Notif.Active do
		if v ~= Notification then
			tween(v.Frame, 0.5, { Position = v.Frame.Position - UDim2.new(0, 0, 0, Notification:GetHeight() + 10) })
		end
	end

	tween(Notification.Frame, 0.5, { Position = UDim2.new(0, 10, 1, -Notification:GetHeight() - 10) })

	task.spawn(function()
		task.wait(0.5)

		Storage.Connections[Notification].Yes = Notification.Frame.Topbar.Yes.Activated:Connect(function()
			Notification:Select(true)
		end)

		Storage.Connections[Notification].No = Notification.Frame.Topbar.No.Activated:Connect(function()
			Notification:Select(false)
		end)

		Library.Notif.IsBusy = false

		if #Library.Notif.Queue > 0 then
			local notif = Library.Notif.Queue[1]
			table.remove(Library.Notif.Queue, 1)

			Library:Notify(notif[1], notif[2])
		end
	end)

	task.spawn(function()
		task.wait(options.duration or 10)

		if Notification.Frame.Parent ~= nil then
			Notification:Select(false)
		end
	end)

	return Notification
end

function Library:AddWindow(options)
	assert(options, "No options data assigned to Window")

	local Window = {
		Name = options.title[1].. " ".. options.title[2],
		Type = "Window",
		Tabs = {},
		Sidebar = { List = {}, Toggled = false },
		Key = options.key or Enum.KeyCode.RightControl,
		Toggled = options.default ~= false,
		Acrylic = nil,
	}

	-- Custom theme setup

	if options.theme ~= nil then
		for i, v in next, options.theme do
			for i2, _ in next, Library.Theme do
				if string.lower(i) == string.lower(i2) and typeof(v) == "Color3" then
					Library.Theme[i2] = v
				end
			end
		end
	end

	-- Window construction

	_G.AcrylicPartOfWindow = false

	Window.Frame = SelfModules.UI.Create("CanvasGroup", {
		Name = "Window",
		BackgroundTransparency = 0,
		Size = UDim2.new(0, 460, 0, 497),
		Position = UDim2.new(1, -490, 1, -527),
		BackgroundColor3 = Library.Theme.TopbarColor,
		Visible = options.default ~= false,
		
		SelfModules.UI.Create("UIStroke", {
			Name = "Stroke",
			Thickness = 2.5,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Transparency = 0.8,
			Enabled = options.default ~= false
		}),

		SelfModules.UI.Create("CanvasGroup", {
			Name = "Topbar",
			BackgroundColor3 = Library.Theme.TopbarColor,
			Size = UDim2.new(1, 0, 0, 40),
			ZIndex = 3,
			Visible = true,
			
			SelfModules.UI.Create("Frame", {
				Name = "Filling",
				BackgroundColor3 = Library.Theme.TopbarColor,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.new(1, 0, 0.5, 0),
				BackgroundTransparency = 1,
			}),

			SelfModules.UI.Create("Frame", {
				Name = "Titles",
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,

				SelfModules.UI.Create("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),

				SelfModules.UI.Create("UIPadding", {
					PaddingLeft = UDim.new(0, 10)
				}),

				SelfModules.UI.Create("TextLabel", {
					Name = "Label1",
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 0, 0, 22),
					Font = Enum.Font.SourceSansBold,
					TextXAlignment = Enum.TextXAlignment.Left,
					Text = options.title[1],
					RichText = true,
					TextColor3 = Library.Theme.TextColor,
					TextSize = 22,
					TextWrapped = true,
					LayoutOrder = 0,
				}),

				SelfModules.UI.Create("Frame", {
					Name = "Label2",
					BorderSizePixel = 0,
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(0, 0, 0, 0),
					BackgroundTransparency = 1,

					SelfModules.UI.Create("TextLabel", {
						Name = "Label",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 0,
						BackgroundColor3 = Library.Theme.Accent,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						Size = UDim2.new(1, 0, 1, 0),
						Font = Enum.Font.SourceSansSemibold,
						TextXAlignment = Enum.TextXAlignment.Center,
						Text = options.title[2],
						RichText = true,
						TextColor3 = Library.Theme.TextColor,
						TextSize = 20,
						TextWrapped = true,
						LayoutOrder = 1,
						ZIndex = 2,
					}, UDim.new(0, 5)),

					SelfModules.UI.Create("ImageLabel", {
						Name = "Glow",
						BackgroundTransparency = 1,
						Position = UDim2.new(0, -13, 0, -13),
						Size = UDim2.new(1, 26, 1, 26),
						Image = "rbxassetid://10822615828",
						ImageColor3 = Library.Theme.Accent,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(99, 99, 99, 99),
						ImageTransparency = 0.9,
						SliceScale = 0.2,
					}),
				}),
			}),
		}, UDim.new(0, 5)),

		SelfModules.UI.Create("Frame", {
			Name = "Background",
			BackgroundColor3 = Library.Theme.BackgroundColor,
			Position = UDim2.new(0, 30, 0, 40),
			Size = UDim2.new(1, -30, 1, -40),
			ZIndex = 3,
			Visible = false,

			SelfModules.UI.Create("Frame", {
				Name = "Filling",
				BackgroundColor3 = Library.Theme.BackgroundColor,
				BorderSizePixel = 0,
				Size = UDim2.new(0, 5, 1, 0),
			}),

			SelfModules.UI.Create("Frame", {
				Name = "Tabs",
				BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.BackgroundColor, Color3.fromRGB(15, 15, 15)),
				Position = UDim2.new(0, 3, 0, 3),
				Size = UDim2.new(1, -6, 1, -6),

				SelfModules.UI.Create("Frame", {
					Name = "Holder",
					BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.BackgroundColor, Color3.fromRGB(5, 5, 5)),
					Position = UDim2.new(0, 1, 0, 1),
					Size = UDim2.new(1, -2, 1, -2),
					ClipsDescendants = true,
				}, UDim.new(0, 5)),
			}, UDim.new(0, 5)),
		}, UDim.new(0, 5)),

		SelfModules.UI.Create("Frame", {
			Name = "Sidebar",
			BackgroundColor3 = Library.Theme.SidebarColor,
			Position = UDim2.new(0, 0, 0, 40),
			Size = UDim2.new(0, 30, 1, -40),
			ZIndex = 3,
			Visible = false,
			ClipsDescendants = true,
			
			SelfModules.UI.Create("TextBox", {
				Name = "SearchBox",
				BackgroundTransparency = 1,
				ClearTextOnFocus = false,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 10, 0, 4),
				Size = UDim2.new(0, 88, 0, 23),
				PlaceholderColor3 = SelfModules.UI.Color.Add(Library.Theme.SidebarColor, Color3.fromRGB(10, 10, 10)),
				PlaceholderText = "Search",
				TextColor3 = Library.Theme.TextColor,
				Font = Enum.Font.SourceSansSemibold,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextSize = 16,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Text = "",
				ClipsDescendants = true,
				Visible = false,
			}),

			SelfModules.UI.Create("Frame", {
				Name = "Filling",
				BackgroundColor3 = Library.Theme.SidebarColor,
				BorderSizePixel = 0,
				Position = UDim2.new(1, -5, 0, 0),
				Size = UDim2.new(0, 5, 1, 0),
			}),

			SelfModules.UI.Create("Frame", {
				Name = "Border",
				BackgroundColor3 = Library.Theme.BackgroundColor,
				BorderSizePixel = 0,
				Position = UDim2.new(1, 0, 0, 0),
				Selectable = true,
				Size = UDim2.new(0, 5, 1, 0),
				ZIndex = 2,
				BackgroundTransparency = Library.Settings.Acrylic == true and 1 or 0,
			}),

			SelfModules.UI.Create("Frame", {
				Name = "Line",
				BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SidebarColor, Color3.fromRGB(10, 10, 10)),
				BorderSizePixel = 0,
				Position = UDim2.new(0, 5, 0, 29),
				Size = UDim2.new(1, -10, 0, 2),
				BackgroundTransparency = Library.Settings.Acrylic == true and 1 or 0,
			}),

			SelfModules.UI.Create("ScrollingFrame", {
				Name = "List",
				Active = true,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = false,
				Position = UDim2.new(0, 5, 0, 35),
				Size = UDim2.new(1, -10, 1, -40),
				CanvasSize = UDim2.new(0, 0, 0, 0),
				ScrollBarThickness = 5,

				SelfModules.UI.Create("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					Padding = UDim.new(0, 5),
				}),
			}),

			SelfModules.UI.Create("ImageLabel", {
				Name = "Indicator1",
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -23, 0, 8),
				Size = UDim2.new(0, 16, 0, 15),
				ScaleType = Enum.ScaleType.Crop,
				Image = "rbxassetid://11295285432",
				ImageColor3 = Library.Theme.TextColor,
			}),

			SelfModules.UI.Create("ImageLabel", {
				Name = "Indicator2",
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -23, 0, 8),
				Size = UDim2.new(0, 16, 0, 15),
				ScaleType = Enum.ScaleType.Crop,
				Image = "rbxassetid://11295291707",
				ImageTransparency = 1,
				ImageColor3 = Library.Theme.Accent,
			}),
		}, UDim.new(0, 5))
	}, UDim.new(0, 5))

	-- Window Toggle Function
	local WasCalled = false
	local WindowPending = false
	local currentMethod = "Normal"

	function Window:Toggle(bool)
		if WasCalled then return end
		if WindowPending then return end

		WasCalled = true
		self.Toggled = bool
		
		local Sound = Instance.new("Sound", game:GetService("SoundService"))
		Sound.PlayOnRemove = true
		Sound.PlaybackSpeed = bool == false and 1.5 or 0.75
		Sound.Volume = 1
		Sound.SoundId = "rbxassetid://".."89087762338808"

		repeat wait() until Sound.IsLoaded == true

		Sound:Remove()
		
		tween(Window.Frame, 0.25, { Size = bool == true and Window.Frame.Size - UDim2.new(0, 10, 0, 10) or Window.Frame.Size + UDim2.new(0, 10, 0, 10), Position = bool == true and Window.Frame.Position + UDim2.new(0, 5, 0, 5) or Window.Frame.Position - UDim2.new(0, 5, 0, 5), GroupTransparency = bool == false and 0 or 1})
		tween(Window.Frame.Stroke, 0.25, { Transparency = bool == false and 0.8 or 1})
		WasCalled = false
	end	

	RS.Heartbeat:Connect(function()
		Window.Frame.Visible = Window.Frame.GroupTransparency ~= 1

	end)

	function Window:SetKey(keycode)
		self.Key = keycode
	end

	function Window:GetKey()
		return self.Key
	end

	local function setAccent(accent)
		Library.Theme.Accent = accent
		Window.Frame.Topbar.Titles.Label2.Label.BackgroundColor3 = accent
		Window.Frame.Topbar.Titles.Label2.Glow.ImageColor3 = accent
		Window.Frame.Sidebar.Indicator2.ImageColor3 = accent

		tween(Window.Frame.Topbar.Titles.Label2.Label, 0.5, { TextColor3 = accent.R >= 0.75 and accent.G >= 0.75 and accent.B >= 0.75 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255) })

		for _, tab in next, Window.Tabs do

			for _, section in next, tab.Sections do
				for _, item in next, section.List do
					local flag = item.Flag or item.Name

					-- Handle flag overlay color change
					if tab.Flags[flag] == true then
						local overlay

						for _, v in next, item.Frame:GetDescendants() do
							if v.Name == "Overlay" then
								overlay = v
								--break
							end
						end

						if overlay then
							local tween = Storage.Tween.Cosmetic[overlay]

							if tween then
								tween:Cancel()
								tween = nil
							end

							tween(overlay, 0.5, { ImageColor3 = accent.R >= 0.75 and accent.G >= 0.75 and accent.B >= 0.75 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255) })
							overlay.BackgroundColor3 = SelfModules.UI.Color.Add(accent, Color3.fromRGB(15, 15, 15))
							if overlay.Glow then
								overlay.Glow.ImageColor3 = SelfModules.UI.Color.Add(accent, Color3.fromRGB(15, 15, 15))
							end
						end
					end

					-- Handle rainbow overlay color change
					if item.Rainbow == true then
						local overlay = nil

						for _, v in next, item.Frame:GetDescendants() do
							if v.Name == "Overlay" then
								overlay = v
								break
							end
						end

						if overlay then
							tween(overlay, 0.5, { ImageColor3 = accent.R >= 0.75 and accent.G >= 0.75 and accent.B >= 0.75 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255) })
							overlay.BackgroundColor3 = SelfModules.UI.Color.Add(accent, Color3.fromRGB(15, 15, 15))
							if overlay.Glow ~= nil then
								overlay.Glow.ImageColor3 = SelfModules.UI.Color.Add(accent, Color3.fromRGB(15, 15, 15))
							end
						end
					end

					-- Handle Slider type items
					if item.Type == "Slider" then
						item.Frame.Holder.Slider.Bar.Fill.BackgroundColor3 = SelfModules.UI.Color.Sub(accent, Color3.fromRGB(10, 10, 10))
						item.Frame.Holder.Slider.Bar.Fill.Glow.ImageColor3 = SelfModules.UI.Color.Sub(accent, Color3.fromRGB(10, 10, 10))
						item.Frame.Holder.Slider.Point.BackgroundColor3 = accent
					end

					-- Handle SubSection type items
					if item.Type == "SubSection" then
						for _, item2 in next, item.List do
							local flag2 = item2.Flag or item2.Name

							-- Handle flag2 overlay color change
							if tab.Flags[flag2] == true then
								local overlay = nil

								for _, v in next, item2.Frame:GetDescendants() do
									if v.Name == "Overlay" then
										overlay = v
										break
									end
								end

								if overlay then
									local tween = Storage.Tween.Cosmetic[overlay]

									if tween then
										tween:Cancel()
										tween = nil
									end

									tween(overlay, 0.5, { ImageColor3 = accent.R >= 0.75 and accent.G >= 0.75 and accent.B >= 0.75 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255) })
									overlay.BackgroundColor3 = SelfModules.UI.Color.Add(accent, Color3.fromRGB(15, 15, 15))
									if overlay.Glow ~= nil then
										overlay.Glow.ImageColor3 = SelfModules.UI.Color.Add(accent, Color3.fromRGB(15, 15, 15))
									end
								end
							end

							-- Handle rainbow overlay color change
							if item2.Rainbow == true then
								local overlay = nil

								for _, v in next, item2.Frame:GetDescendants() do
									if v.Name == "Overlay" then
										overlay = v
										break
									end
								end

								if overlay then
									tween(overlay, 0.5, { ImageColor3 = accent.R >= 0.75 and accent.G >= 0.75 and accent.B >= 0.75 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255) })
									overlay.BackgroundColor3 = SelfModules.UI.Color.Add(accent, Color3.fromRGB(15, 15, 15))
									if overlay.Glow ~= nil then
										overlay.Glow.ImageColor3 = SelfModules.UI.Color.Add(accent, Color3.fromRGB(15, 15, 15))
									end
								end
							end

							-- Handle Slider type items in SubSection
							if item2.Type == "Slider" then
								item2.Frame.Holder.Slider.Bar.Fill.BackgroundColor3 = SelfModules.UI.Color.Sub(accent, Color3.fromRGB(10, 10, 10))
								item2.Frame.Holder.Slider.Bar.Fill.Glow.ImageColor3 = SelfModules.UI.Color.Sub(accent, Color3.fromRGB(10, 10, 10))
								item2.Frame.Holder.Slider.Point.BackgroundColor3 = accent
							end
						end
					end
				end
			end
		end
	end

	function Window:SetAccent(accent)
		if Storage.Connections.WindowRainbow ~= nil then
			Storage.Connections.WindowRainbow:Disconnect()
		end

		if typeof(accent) == "string" and string.lower(accent) == "rainbow" then
			Storage.Connections.WindowRainbow = RS.Heartbeat:Connect(function()
				setAccent(Color3.fromHSV(tick() % 5 / 5, 1, 1))
			end)

		elseif typeof(accent) == "Color3" then
			setAccent(accent)
		end
	end

	local function toggleSidebar(bool)
		Window.Sidebar.Toggled = bool
		Window.Sidebar.Frame.SearchBox.Visible = bool
		
		if bool == false then
			Window.Sidebar.Frame.SearchBox.Text = ""
		end

		task.spawn(function()
			task.wait(bool and 0 or 0.5)
			Window.Sidebar.Frame.Border.Visible = bool
		end)

		TS:Create(Window.Sidebar.Frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.new(0, bool and 130 or 30, 1, -40) }):Play()
		TS:Create(Window.Frame.Background, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.new(1, bool and -130 or -30,1, -40), Position = UDim2.new(0, bool and 130 or 30, 0, 40) }):Play()
		tween(Window.Sidebar.Frame.Indicator1, 0.25, { ImageTransparency = bool and 1 or 0 })
		tween(Window.Sidebar.Frame.Indicator2, 0.25, { Rotation = bool and 45 or 0, ImageTransparency = bool and 0 or 1 })

		for i, v in next, Window.Sidebar.List do
			TS:Create(v.Frame.Button.Label, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { TextTransparency = bool and 0 or 1 }):Play()
			TS:Create(v.Frame.Button, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { BackgroundTransparency = bool and 0 or 1 }):Play()
			TS:Create(v.Frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { BackgroundTransparency = bool and 0 or 1 }):Play()
			TS:Create(v.Frame.Glow, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { ImageTransparency = bool and 0.7 or 1 }):Play()
			--TS:Create(v.Frame.Glow, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { ImageTransparency = bool and 0.85 or 1 })
			wait()
		end
	end

	local function loadup()
		local Sound = Instance.new("Sound", game:GetService("SoundService"))
		Sound.PlayOnRemove = true
		Sound.PlaybackSpeed = 1.25
		Sound.Volume = 1
		Sound.SoundId = "rbxassetid://89087762338808"

		repeat wait() until Sound.IsLoaded == true

		Sound:Remove()
		Window.Frame.Background.Visible = true
		Window.Frame.Topbar.Visible = true
		Window.Frame.Sidebar.Visible = true
		Window.Frame.Stroke.Enabled = true
	end

	-- Scripts

	local Size1 = TXS:GetTextSize(Window.Frame.Topbar.Titles.Label1.Text, 22, Enum.Font.SourceSansBold, Vector2.new(0, 22))
	local Size2 = TXS:GetTextSize(Window.Frame.Topbar.Titles.Label2.Label.Text, 20, Enum.Font.SourceSansSemibold, Vector2.new(0, 20))
	Window.Frame.Topbar.Titles.Label1.Size = UDim2.new(0, Size1.X + 5, 0, Size1.Y)
	Window.Frame.Topbar.Titles.Label2.Size = UDim2.new(0, Size2.X + 10, 0, Size2.Y + 5)

	Window.Key = options.key or Window.Key
	Storage.Connections[Window] = {}
	SelfModules.UI.MakeDraggable(Window.Frame, Window.Frame.Topbar, 0.0975)
	Window.Sidebar.Frame = Window.Frame.Sidebar
	Window.Frame.Parent = ScreenGui

	UIS.InputBegan:Connect(function(input, gameProcessed)
		if not gameProcessed and input.KeyCode == Window.Key and not ListenForInput then
			Window:Toggle(not Window.Toggled)
		end
	end)
	
	Window.Sidebar.Frame.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
		for _, tab in pairs(Window.Sidebar.Frame.List:GetChildren()) do
			if tab:IsA("Frame") then
				if string.find(tab.Name:lower(), Window.Sidebar.Frame.SearchBox.Text:lower()) then
					tab.Visible = true
				else
					tab.Visible = false
				end
			end
		end
	end)

	Window.Sidebar.Frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and Mouse.Y - Window.Sidebar.Frame.AbsolutePosition.Y <= 25 then
			toggleSidebar(not Window.Sidebar.Toggled)
		end
	end)

	-- Tab

	function Window:AddTab(name, options)
		options = options or {}

		local Tab = {
			Name = name,
			Type = "Tab",
			Sections = {},
			Flags = {},
			Button = {
				Name = name,
				Selected = false,
			},
		}
		
		if options.icon ~= (nil or "") then
			local TabIcon = SelfModules.UI.Create("ImageLabel", {
				Name = name,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 16, 0, 16),
				Position = UDim2.new(0, 433, 0, 12),
				Image = options.icon,
				ImageColor3 = Library.Theme.Accent,
				ImageTransparency = 1,
			})
			
			if options.default ~= nil then
				if options.default == true then
					TabIcon.ImageTransparency = 0
			elseif options.default == false then
					TabIcon.ImageTransparency = 1
				end
			end
			
			TabIcon.Parent = Window.Frame.Topbar
			print(TabIcon.Parent.Name)
		end

		Tab.Frame = SelfModules.UI.Create("ScrollingFrame", {
			Name = "Tab",
			Active = true,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 5, 0, 5),
			Size = UDim2.new(1, -10, 1, -10),
			ScrollBarImageColor3 = SelfModules.UI.Color.Add(Library.Theme.BackgroundColor, Color3.fromRGB(15, 15, 15)),
			ScrollBarThickness = 5,
			Visible = false,

			SelfModules.UI.Create("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 5),
			}),
		})

		Tab.Button.Frame = SelfModules.UI.Create("Frame", {
			Name = name,
			BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SidebarColor, Color3.fromRGB(15, 15, 15)),
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 120, 0, 32),
			
			SelfModules.UI.Create("ImageLabel", {
				Name = "Glow",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, -8, 0, -8),
				Size = UDim2.new(1, 16, 1, 16),
				Image = "rbxassetid://10822615828",
				ImageColor3 = SelfModules.UI.Color.Add(Library.Theme.SidebarColor, Color3.fromRGB(15, 15, 15)),
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(99, 99, 99, 99),
				ImageTransparency = 1,
				SliceScale = 0.15,
			}),

			SelfModules.UI.Create("TextButton", {
				Name = "Button",
				AutoButtonColor = false,
				BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SidebarColor, Color3.fromRGB(5, 5, 5)),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 1, 0, 1),
				Size = UDim2.new(1, -2, 1, -2),
				Text = "",
				TextTransparency = 1,
				TextSize = 0,

				SelfModules.UI.Create("TextLabel", {
					Name = "Label",
					Font = Enum.Font.SourceSansSemibold,
					Text = name,
					TextColor3 = Library.Theme.TextColor,
					TextTransparency = 1,
					TextSize = 16,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = true,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -4, 1, -50),
					Position = UDim2.new(0, 6, 0, 25),
				}),
			}, UDim.new(0, 5)),
		}, UDim.new(0, 5))

		-- Functions

		function Tab:Show()
			for i, v in next, Window.Tabs do
				local bool = v == self

				if bool == true then
					SelectedButtonTab = v.Button
				end

				v.Frame.Visible = bool
				v.Button.Selected = bool

				tween(v.Button.Frame.Button, 0.2, { BackgroundColor3 = bool and Library.Theme.Accent or SelfModules.UI.Color.Add(Library.Theme.SidebarColor, Color3.fromRGB(5, 5, 5)) })
				tween(v.Button.Frame, 0.2, { BackgroundColor3 = bool and SelfModules.UI.Color.Sub(Library.Theme.Accent, Color3.fromRGB(45, 45, 45)) or SelfModules.UI.Color.Add(Library.Theme.SidebarColor, Color3.fromRGB(15, 15, 15)) })
				tween(v.Button.Frame.Glow, 0.2, { ImageColor3 = bool and Library.Theme.Accent or SelfModules.UI.Color.Add(Library.Theme.SidebarColor, Color3.fromRGB(15, 15, 15)) })
				if Window.Frame.Topbar[v.Name] ~= nil then
					tween(Window.Frame.Topbar[v.Name], 0.2, { ImageTransparency = bool and 0 or 1 })
				end
			end

			toggleSidebar(false)
		end

		function Tab:Hide()
			self.Frame.Visible = false
		end

		function Tab:GetHeight()
			local height = 0

			for i, v in next, self.Sections do
				height = height + v:GetHeight() + (i < #self.Sections and 5 or 0)
			end

			return height
		end

		function Tab:UpdateHeight()
			Tab.Frame.CanvasSize = UDim2.new(0, 0, 0, Tab:GetHeight())
		end

		-- Scripts

		Window.Tabs[#Window.Tabs + 1] = Tab
		Window.Sidebar.List[#Window.Sidebar.List + 1] = Tab.Button
		Tab.Frame.Parent = Window.Frame.Background.Tabs.Holder
		Tab.Frame.CanvasSize = UDim2.new(0, 0, 0, Tab.Frame.AbsoluteSize.Y + 1)
		Tab.Button.Frame.Parent = Window.Frame.Sidebar.List

		Tab.Frame.ChildAdded:Connect(function(c)
			if c.ClassName == "Frame" then
				Tab:UpdateHeight()
			end
		end)

		Tab.Frame.ChildRemoved:Connect(function(c)
			if c.ClassName == "Frame" then
				Tab:UpdateHeight()
			end
		end)

		Tab.Button.Frame.Button.MouseEnter:Connect(function()
			tween(Tab.Button.Frame.Button.Label, 0.1, { Position = UDim2.new(0, 12, 0, 25) })
			if Tab.Button.Selected == false then
				tween(Tab.Button.Frame.Button, 0.1, { BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SidebarColor, Color3.fromRGB(15, 15, 15)) })
				tween(Tab.Button.Frame, 0.1, { BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SidebarColor, Color3.fromRGB(25, 25, 25)) })
			end
		end)

		Tab.Button.Frame.Button.MouseLeave:Connect(function()
			tween(Tab.Button.Frame.Button.Label, 0.1, { Position = UDim2.new(0, 6, 0, 25) })
			if Tab.Button.Selected == false then
				tween(Tab.Button.Frame.Button, 0.1, { BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SidebarColor, Color3.fromRGB(5, 5, 5)) })
				tween(Tab.Button.Frame, 0.1, { BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SidebarColor, Color3.fromRGB(15, 15, 15)) })
			end
		end)

		Tab.Button.Frame.Button.Activated:Connect(function()
			if Tab.Button.Selected == false then
				Tab:Show()
			end
		end)

		if options.default == true then
			Tab:Show()
		end

		-- Section

		function Tab:AddSection(name, options)
			options = options or {}

			local Section = {
				Name = name,
				Type = "Section",
				Toggled = options.default == true,
				List = {},
			}



			Section.Frame = SelfModules.UI.Create("Frame", {
				Name = "Section",
				BackgroundColor3 = Library.Theme.SectionColor,
				ClipsDescendants = true,
				Size = UDim2.new(1, -10, 0, 40),

				SelfModules.UI.Create("Frame", {
					Name = "Line",
					BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
					BorderSizePixel = 0,
					Position = UDim2.new(0, 5, 0, 30),
					Size = UDim2.new(1, -10, 0, 2),

				}),

				SelfModules.UI.Create("TextLabel", {
					Name = "Header",
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 5, 0, 8),
					Size = UDim2.new(1, -40, 0, 14),
					Font = Enum.Font.SourceSans,
					Text = name,
					TextColor3 = Library.Theme.TextColor,
					TextSize = 14,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
				}),

				SelfModules.UI.Create("Frame", {
					Name = "List",
					BackgroundTransparency = 1,
					ClipsDescendants = true,
					Position = UDim2.new(0, 5, 0, 40),
					Size = UDim2.new(1, -10, 1, -40),

					SelfModules.UI.Create("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, 5),
					}),

					SelfModules.UI.Create("UIPadding", {
						PaddingBottom = UDim.new(0, 1),
						PaddingLeft = UDim.new(0, 1),
						PaddingRight = UDim.new(0, 1),
						PaddingTop = UDim.new(0, 1),
					}),
				}),

				SelfModules.UI.Create("TextLabel", {
					Name = "Indicator",
					BackgroundTransparency = 1,
					Position = UDim2.new(1, -30, 0, 0),
					Size = UDim2.new(0, 30, 0, 30),
					Font = Enum.Font.SourceSansBold,
					Text = "+",
					TextColor3 = Library.Theme.TextColor,
					TextSize = 20,
				})
			}, UDim.new(0, 5))

			-- Functions

			local function toggleSection(bool)
				Section.Toggled = bool

				tween(Section.Frame, 0.5, { Size = UDim2.new(1, -10, 0, Section:GetHeight()) })
				tween(Section.Frame.Indicator, 0.5, { Rotation = bool and 45 or 0 })

				tween(Tab.Frame, 0.5, { CanvasSize = UDim2.new(0, 0, 0, Tab:GetHeight()) })
			end

			function Section:GetHeight()
				local height = 40

				if Section.Toggled == true then
					for i, v in next, self.List do
						height = height + (v.GetHeight ~= nil and v:GetHeight() or v.Frame.AbsoluteSize.Y) + 5
					end
				end

				return height
			end

			function Section:UpdateHeight()
				if Section.Toggled == true then
					Section.Frame.Size = UDim2.new(1, -10, 0, Section:GetHeight())
					Section.Frame.Indicator.Rotation = 45

					Tab:UpdateHeight()
				end
			end

			function Section:SetName(text)
				Section.Frame.Header.Text = text
			end

			function Section:GetName()
				return Section.Frame.Header.Text
			end

			-- Scripts

			Tab.Sections[#Tab.Sections + 1] = Section
			Section.Frame.Parent = Tab.Frame

			Section.Frame.List.ChildAdded:Connect(function(c)
				if c.ClassName == "Frame" then
					Section:UpdateHeight()
				end
			end)

			Section.Frame.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 and #Section.List > 0 and Window.Sidebar.Frame.AbsoluteSize.X <= 35 and Mouse.Y - Section.Frame.AbsolutePosition.Y <= 30 then
					toggleSection(not Section.Toggled)
				end
			end)

			function Section:AddButton(name1, callback1, options)
				-- options = { Dual = true/false, Name2 = "Button 2 Name", Callback2 = function() end }
				options = options or {}
				local isDual = options.Dual == true

				local Button = {
					Type = "Button",
					Callback1 = callback1,
					Callback2 = options.Callback2,
				}

				Button.Frame = SelfModules.UI.Create("Frame", {
					Name = "ButtonFrame",
					BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
					Size = UDim2.new(1, 2, 0, 32),
				}, UDim.new(0, 5))

				local holderFrame = SelfModules.UI.Create("Frame", {
					Name = "Holder",
					BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
					Size = UDim2.new(1, -2, 1, -2),
					Position = UDim2.new(0, 1, 0, 1),
				}, UDim.new(0, 5))
				holderFrame.Parent = Button.Frame

				local function createTextButton(btnName, callback, posScale, sizeScale)
					local btn = SelfModules.UI.Create("TextButton", {
						Name = btnName,
						BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
						Position = posScale,
						Size = sizeScale,
						AutoButtonColor = false,
						Font = Enum.Font.SourceSans,
						Text = btnName,
						TextColor3 = Library.Theme.TextColor,
						TextSize = 14,
						TextWrapped = true,
					}, UDim.new(0, 5))

					btn.Parent = holderFrame

					btn.MouseButton1Down:Connect(function()
						tween(btn, 0.5, { TextSize = 12 })
					end)

					btn.MouseButton1Up:Connect(function()
						tween(btn, 0.1, { TextSize = 14 })
						task.spawn(function()
							local Visual = SelfModules.UI.Create("Frame", {
								Name = "Visual",
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 0.9,
								Position = UDim2.new(0.5, 0, 0.5, 0),
								Size = UDim2.new(0, 0, 1, 0),
							}, UDim.new(0, 5))
							Visual.Parent = btn
							tween(Visual, 0.5, { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 })
							task.wait(0.5)
							Visual:Destroy()
						end)

						pcall(task.spawn, callback)
					end)

					btn.MouseLeave:Connect(function()
						tween(btn, 0.5, { TextSize = 14 })
					end)
				end

				if isDual and options.Name2 and options.Callback2 then
					-- Dual buttons with their own names
					createTextButton(name1, callback1, UDim2.new(0, 2, 0, 2), UDim2.new(0.5, -4, 1, -4))
					createTextButton(options.Name2, options.Callback2, UDim2.new(0.5, 2, 0, 2), UDim2.new(0.5, -4, 1, -4))
				else
					-- Single button
					createTextButton(name1, callback1, UDim2.new(0, 2, 0, 2), UDim2.new(1, -4, 1, -4))
				end

				Button.Frame.Parent = Section.Frame.List
				Section.List[#Section.List + 1] = Button

				return Button
			end

			-- Toggle

			function Section:AddToggle(name, options, callback)
				local Toggle = {
					Name = name,
					Type = "Toggle",
					Flag = options.flag or name,
					Callback = callback,
					Boolean = nil,
				}

				Toggle.Frame = SelfModules.UI.Create("Frame", {
					Name = name,
					BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
					Size = UDim2.new(1, 2, 0, 32),

					SelfModules.UI.Create("Frame", {
						Name = "Holder",
						BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
						Position = UDim2.new(0, 1, 0, 1),
						Size = UDim2.new(1, -2, 1, -2),

						SelfModules.UI.Create("TextLabel", {
							Name = "Label",
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 5, 0.5, -7),
							Size = UDim2.new(1, -50, 0, 14),
							Font = Enum.Font.SourceSans,
							Text = name,
							TextColor3 = Library.Theme.TextColor,
							TextSize = 14,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Left,
						}),

						SelfModules.UI.Create("Frame", {
							Name = "Indicator",
							BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
							Position = UDim2.new(1, -42, 0, 2),
							Size = UDim2.new(0, 40, 0, 26),

							SelfModules.UI.Create("Frame", {
								Name = "Filler",
								BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
								Position = UDim2.new(0.5, 0, 0, 0),
								Size = UDim2.new(0.5, 0, 1, 0)
							}, UDim.new(0, 5)),

							SelfModules.UI.Create("ImageLabel", {
								Name = "Overlay",
								BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)),
								ImageColor3 = Library.Theme.Accent.R >= 0.75 and Library.Theme.Accent.G >= 0.75 and Library.Theme.Accent.B >= 0.75 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255),
								Position = UDim2.new(0, 2, 0, 2),
								Size = UDim2.new(0, 22, 0, 22),
								Image = "http://www.roblox.com/asset/?id=7827504335",
								ImageTransparency = 1,

								SelfModules.UI.Create("ImageLabel", {
									Name = "Glow",
									BackgroundTransparency = 1,
									Position = UDim2.new(0, -13, 0, -13),
									Size = UDim2.new(1, 26, 1, 26),
									Image = "rbxassetid://10822615828",
									ImageColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)),
									ScaleType = Enum.ScaleType.Slice,
									SliceCenter = Rect.new(99, 99, 99, 99),
									ImageTransparency = 0.5,
									SliceScale = 0.2,
								}),
							}, UDim.new(1, 0)),
						}, UDim.new(1, 0))
					}, UDim.new(0, 5)),
				}, UDim.new(0, 5))

				-- Functions

				function Toggle:Set(bool, instant)
					Tab.Flags[Toggle.Flag] = bool

					tween(Toggle.Frame.Holder.Indicator.Overlay.Glow, instant and 0 or 0.25, { ImageColor3 = bool and Library.Theme.Accent or SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)), SliceScale = bool and 0.2 or 1, ImageTransparency = bool and 0.85 or 0.5 })
					tween(Toggle.Frame.Holder.Indicator.Overlay, instant and 0 or 0.25, { ImageTransparency = bool and 0 or 1, Position = bool and UDim2.new(1, -24, 0, 2) or UDim2.new(0, 2, 0, 2) })
					tween(Toggle.Frame.Holder.Indicator.Overlay.UICorner, instant and 0 or 0.25, { CornerRadius = UDim.new(bool and 0 or 1, bool and 5 or 0) })
					tween(Toggle.Frame.Holder.Indicator.Overlay, "Cosmetic", instant and 0 or 0.25, { BackgroundColor3 = bool and SelfModules.UI.Color.Add(Library.Theme.Accent, Color3.fromRGB(5, 5, 5)) or SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)) })

					Toggle.Boolean = bool

					pcall(task.spawn, Toggle.Callback, bool)
				end

				function Toggle:Get()
					return Toggle.Boolean
				end

				-- Scripts

				Section.List[#Section.List + 1] = Toggle
				Tab.Flags[Toggle.Flag] = options.default == true
				Toggle.Frame.Parent = Section.Frame.List

				Toggle.Frame.Holder.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						Toggle:Set(not Tab.Flags[Toggle.Flag], false)
					end
				end)

				Toggle:Set(options.default == true, true)
				Toggle.Boolean = options.default == true or false

				return Toggle
			end

			-- Label

			function Section:AddLabel(name)
				local Label = {
					Name = name,
					Type = "Label",
				}

				Label.Frame = SelfModules.UI.Create("Frame", {
					Name = name,
					BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
					Size = UDim2.new(1, 2, 0, 22),

					SelfModules.UI.Create("Frame", {
						Name = "Holder",
						BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
						Position = UDim2.new(0, 1, 0, 1),
						Size = UDim2.new(1, -2, 1, -2),

						SelfModules.UI.Create("TextLabel", {
							Name = "Label",
							AnchorPoint = Vector2.new(0, 0.5),
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 2, 0.5, 0),
							Size = UDim2.new(1, -4, 0, 14),
							Font = Enum.Font.SourceSans,
							Text = name,
							TextColor3 = Library.Theme.TextColor,
							TextSize = 14,
							TextWrapped = true,
						}),
					}, UDim.new(0, 5))
				}, UDim.new(0, 5))

				-- Functions

				function Label:SetName(text)
					Label.Frame.Holder.Label.Text = text
				end

				function Label:GetName()
					return Label.Frame.Holder.Label.Text
				end

				-- Scripts

				Section.List[#Section.List + 1] = Label
				Label.Label = Label.Frame.Holder.Label
				Label.Frame.Parent = Section.Frame.List

				return Label
			end

			-- DualLabel

			function Section:AddDualLabel(options)
				options = options or {}

				local DualLabel = {
					Name = options[1].. " ".. options[2],
					Type = "DualLabel",
				}

				DualLabel.Frame = SelfModules.UI.Create("Frame", {
					Name = options[1].. " ".. options[2],
					BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
					Size = UDim2.new(1, 2, 0, 22),

					SelfModules.UI.Create("Frame", {
						Name = "Holder",
						BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
						Position = UDim2.new(0, 1, 0, 1),
						Size = UDim2.new(1, -2, 1, -2),

						SelfModules.UI.Create("TextLabel", {
							Name = "Label1",
							AnchorPoint = Vector2.new(0, 0.5),
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 5, 0.5, 0),
							Size = UDim2.new(0.5, -5, 0, 14),
							Font = Enum.Font.SourceSans,
							Text = options[1],
							TextColor3 = Library.Theme.TextColor,
							TextSize = 14,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Left,
						}),

						SelfModules.UI.Create("TextLabel", {
							Name = "Label2",
							AnchorPoint = Vector2.new(0, 0.5),
							BackgroundTransparency = 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							Size = UDim2.new(0.5, -5, 0, 14),
							Font = Enum.Font.SourceSans,
							Text = options[2],
							TextColor3 = Library.Theme.TextColor,
							TextSize = 14,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Right,
						}),
					}, UDim.new(0, 5))
				}, UDim.new(0, 5))

				-- Functions

				function DualLabel:SetLeftText(text)
					DualLabel.Frame.Holder.Label1.Text = text
				end

				function DualLabel:GetLeftText()
					return DualLabel.Frame.Holder.Label1.Text
				end

				function DualLabel:SetRightText(text)
					DualLabel.Frame.Holder.Label2.Text = text
				end

				function DualLabel:GetRightText()
					return DualLabel.Frame.Holder.Label2.Text
				end

				-- Scripts

				Section.List[#Section.List + 1] = DualLabel
				DualLabel.Label1 = DualLabel.Frame.Holder.Label1
				DualLabel.Label2 = DualLabel.Frame.Holder.Label2
				DualLabel.Frame.Parent = Section.Frame.List

				return DualLabel
			end

			-- ClipboardLabel

			function Section:AddClipboardLabel(name, callback)
				local ClipboardLabel = {
					Name = name,
					Type = "ClipboardLabel",
					Callback = callback,
				}

				ClipboardLabel.Frame = SelfModules.UI.Create("Frame", {
					Name = name,
					BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
					Size = UDim2.new(1, 2, 0, 22),

					SelfModules.UI.Create("Frame", {
						Name = "Holder",
						BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
						Position = UDim2.new(0, 1, 0, 1),
						Size = UDim2.new(1, -2, 1, -2),

						SelfModules.UI.Create("TextLabel", {
							Name = "Label",
							AnchorPoint = Vector2.new(0, 0.5),
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 2, 0.5, 0),
							Size = UDim2.new(1, -22, 0, 14),
							Font = Enum.Font.SourceSans,
							Text = name,
							TextColor3 = Library.Theme.TextColor,
							TextSize = 14,
							TextWrapped = true,
						}),

						SelfModules.UI.Create("ImageLabel", {
							Name = "Icon",
							BackgroundTransparency = 1,
							Position = UDim2.new(1, -18, 0, 2),
							Size = UDim2.new(0, 16, 0, 16),
							Image = "rbxassetid://9243581053",
						}),
					}, UDim.new(0, 5)),
				}, UDim.new(0, 5))

				-- Functions

				function ClipboardLabel:SetName(text)
					ClipboardLabel.Frame.Holder.Label.Text = text
				end

				function ClipboardLabel:GetName()
					return ClipboardLabel.Frame.Holder.Label.Text
				end

				-- Scripts

				Section.List[#Section.List + 1] = ClipboardLabel
				ClipboardLabel.Label = ClipboardLabel.Frame.Holder.Label
				ClipboardLabel.Frame.Parent = Section.Frame.List

				ClipboardLabel.Frame.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						local s, result = pcall(ClipboardLabel.Callback)

						if s then
							warn(result)
						end
					end
				end)

				return ClipboardLabel
			end

			-- Box

			function Section:AddBox(name, options, callback)
				local Box = {
					Name = name,
					Type = "Box",
					Extend = options.extend or 200,
					Callback = callback,
				}

				Box.Frame = SelfModules.UI.Create("Frame", {
					Name = name,
					BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
					Size = UDim2.new(1, 2, 0, 32),

					SelfModules.UI.Create("Frame", {
						Name = "Holder",
						BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
						Position = UDim2.new(0, 1, 0, 1),
						Size = UDim2.new(1, -2, 1, -2),

						SelfModules.UI.Create("TextLabel", {
							Name = "Label",
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 5, 0.5, -7),
							Size = UDim2.new(1, -135, 0, 14),
							Font = Enum.Font.SourceSans,
							Text = name,
							TextColor3 = Library.Theme.TextColor,
							TextSize = 14,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Left,
						}),

						SelfModules.UI.Create("Frame", {
							Name = "TextBox",
							AnchorPoint = Vector2.new(1, 0),
							BackgroundColor3 = SelfModules.UI.Color.Sub(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
							Position = UDim2.new(1, -2, 0, 2),
							Size = UDim2.new(0, 140, 1, -4),
							ZIndex = 2,

							SelfModules.UI.Create("Frame", {
								Name = "Holder",
								BackgroundColor3 = Library.Theme.SectionColor,
								Position = UDim2.new(0, 1, 0, 1),
								Size = UDim2.new(1, -2, 1, -2),
								ZIndex = 2,

								SelfModules.UI.Create("TextBox", {
									Name = "Box",
									AnchorPoint = Vector2.new(0, 0.5),
									BackgroundTransparency = 1,
									ClearTextOnFocus = options.clearonfocus ~= true,
									Position = UDim2.new(0, 28, 0.5, 0),
									Size = UDim2.new(1, -30, 1, 0),
									Font = Enum.Font.SourceSans,
									PlaceholderText = "Text",
									Text = "",
									TextColor3 = Library.Theme.TextColor,
									TextSize = 14,
									TextWrapped = true,
								}),

								SelfModules.UI.Create("TextLabel", {
									Name = "Icon",
									AnchorPoint = Vector2.new(0, 0.5),
									BackgroundTransparency = 1,
									Position = UDim2.new(0, 6, 0.5, 0),
									Size = UDim2.new(0, 14, 0, 14),
									Font = Enum.Font.SourceSansBold,
									Text = "T",
									TextColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(40, 40, 40)),
									TextSize = 18,
									TextWrapped = true,
								}),
							}, UDim.new(0, 5)),
						}, UDim.new(0, 5))
					}, UDim.new(0, 5)),
				}, UDim.new(0, 5))

				-- Functions

				local function extendBox(bool)
					tween(Box.Frame.Holder.TextBox, 0.25, { Size = UDim2.new(0, bool and math.abs(Box.Extend) or bool and 200 or 140, 1, -4) })
				end

				function Box:SetName(text)
					Box.Frame.Holder.Label.Text = text
				end

				function Box:GetName(text)
					return Box.Frame.Holder.Label.Text
				end

				function Box:SetText(text)
					Box.Frame.Holder.TextBox.Text = text
				end

				function Box:GetText()
					return Box.Frame.Holder.TextBox.Text
				end

				function Box:SetExtend(number)
					options.extend = number
				end

				function Box:GetExtend()
					return math.abs(options.extend)
				end

				-- Scripts

				Section.List[#Section.List + 1] = Box
				Box.Box = Box.Frame.Holder.TextBox.Holder.Box
				Box.Frame.Parent = Section.Frame.List

				Box.Frame.Holder.TextBox.Holder.MouseEnter:Connect(function()
					extendBox(true)
				end)

				Box.Frame.Holder.TextBox.Holder.MouseLeave:Connect(function()
					if Box.Frame.Holder.TextBox.Holder.Box:IsFocused() == false then
						extendBox(false)
					end
				end)

				Box.Frame.Holder.TextBox.Holder.Box.FocusLost:Connect(function()
					if Box.Frame.Holder.TextBox.Holder.Box.Text == "" and options.fireonempty ~= true then
						return
					end

					extendBox(false)
					pcall(task.spawn, Box.Callback, Box.Frame.Holder.TextBox.Holder.Box.Text)
				end)

				return Box
			end

			-- Bind

			function Section:AddBind(name, bind, options, callback)
				local Bind = {
					Name = name,
					Type = "Bind",
					Bind = bind,
					Flag = options.flag or name,
					Callback = callback,
					Boolean = nil,
				}

				Bind.Frame = SelfModules.UI.Create("Frame", {
					Name = name,
					BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
					Size = UDim2.new(1, 2, 0, 32),

					SelfModules.UI.Create("Frame", {
						Name = "Holder",
						BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
						Position = UDim2.new(0, 1, 0, 1),
						Size = UDim2.new(1, -2, 1, -2),

						SelfModules.UI.Create("TextLabel", {
							Name = "Label",
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 5, 0.5, -7),
							Size = UDim2.new(1, -135, 0, 14),
							Font = Enum.Font.SourceSans,
							Text = name,
							TextColor3 = Library.Theme.TextColor,
							TextSize = 14,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Left,
						}),

						SelfModules.UI.Create("Frame", {
							Name = "Bind",
							AnchorPoint = Vector2.new(1, 0),
							BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
							Position = UDim2.new(1, -2, 0, 2),
							Size = UDim2.new(0, 78, 0, 26),
							ZIndex = 2,

							SelfModules.UI.Create("TextLabel", {
								Name = "Label",
								BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
								Position = UDim2.new(0, 1, 0, 1),
								Size = UDim2.new(1, -2, 1, -2),
								Font = Enum.Font.SourceSans,
								Text = "",
								TextColor3 = Library.Theme.TextColor,
								TextSize = 14,
							}, UDim.new(0, 5)),
						}, UDim.new(0, 5)),
					}, UDim.new(0, 5)),
				}, UDim.new(0, 5))

				-- Variables

				local indicatorEntered = false
				local connections = {}

				-- Functions

				local function listenForInput()
					if connections.listen then
						connections.listen:Disconnect()
					end

					Bind.Frame.Holder.Bind.Label.Text = "..."
					ListenForInput = true

					connections.listen = UIS.InputBegan:Connect(function(input, gameProcessed)
						if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
							Bind:Set(input.KeyCode)
						end
					end)
				end

				local function cancelListen()
					if connections.listen then
						connections.listen:Disconnect(); connections.listen = nil
					end

					Bind.Frame.Holder.Bind.Label.Text = Bind.Bind.Name
					task.spawn(function() RS.RenderStepped:Wait(); ListenForInput = false end)
				end

				function Bind:Set(bind)
					Bind.Bind = bind
					Bind.Frame.Holder.Bind.Label.Text = bind.Name
					Bind.Frame.Holder.Bind.Size = UDim2.new(0, math.max(12 + math.round(TXS:GetTextSize(bind.Name, 14, Enum.Font.SourceSans, Vector2.new(9e9)).X + 0.5), 42), 0, 26)

					if connections.listen then
						cancelListen()
					end
					if options.toggleable == true then
						Bind.Frame.Holder.Indicator.Position = UDim2.new(1, -(Bind.Frame.Holder.Bind.Size.X.Offset+5), 0, 2)
					end
				end

				function Bind:Get()
					return Bind.Boolean
				end

				function Bind:SetName(text)
					Bind.Frame.Holder.Label.Text = text
				end

				function Bind:GetName()
					return Bind.Frame.Holder.Label.Text
				end

				if options.toggleable == true then
					function Bind:Toggle(bool, instant)
						Tab.Flags[Bind.Flag] = bool

						tween(Bind.Frame.Holder.Indicator.Overlay.Glow, instant and 0 or 0.25, { ImageColor3 = bool and Library.Theme.Accent or SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)), SliceScale = bool and 0.2 or 1, ImageTransparency = bool and 0.85 or 0.5 })
						tween(Bind.Frame.Holder.Indicator.Overlay, instant and 0 or 0.25, { ImageTransparency = bool and 0 or 1, Position = bool and UDim2.new(1, -24, 0, 2) or UDim2.new(0, 2, 0, 2) })
						tween(Bind.Frame.Holder.Indicator.Overlay.UICorner, instant and 0 or 0.25, { CornerRadius = UDim.new(bool and 0 or 1, bool and 5 or 0) })
						tween(Bind.Frame.Holder.Indicator.Overlay, "Cosmetic", instant and 0 or 0.25, { BackgroundColor3 = bool and SelfModules.UI.Color.Add(Library.Theme.Accent, Color3.fromRGB(15, 15, 15)) or SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)) })

						Bind.Boolean = bool

						if options.fireontoggle ~= false then
							pcall(task.spawn, Bind.Callback, Bind.Bind)
						end
					end
				end

				-- Scripts

				Section.List[#Section.List + 1] = Bind
				Bind.Frame.Parent = Section.Frame.List

				Bind.Frame.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if indicatorEntered == true then
							Bind:Toggle(not Tab.Flags[Bind.Flag], false)
						else
							listenForInput()
						end
					end
				end)

				UIS.InputBegan:Connect(function(input)
					if input.KeyCode == Bind.Bind then
						if (options.toggleable == true and Tab.Flags[Bind.Flag] == false) or ListenForInput then
							return
						end

						pcall(task.spawn, Bind.Callback, Bind.Bind)
					end
				end)

				if options.toggleable == true then
					local indicator = SelfModules.UI.Create("Frame", {
						Name = "Indicator",
						AnchorPoint = Vector2.new(1, 0),
						BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
						Position = UDim2.new(1, -(Bind.Frame.Holder.Bind.Size.X.Offset+5), 0, 2),
						Size = UDim2.new(0, 40, 0, 26),

						SelfModules.UI.Create("Frame", {
							Name = "Filler",
							BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
							Position = UDim2.new(0.5, 0, 0, 0),
							Size = UDim2.new(0.5, 0, 1, 0)
						}, UDim.new(0, 5)),

						SelfModules.UI.Create("ImageLabel", {
							Name = "Overlay",
							ImageColor3 = Library.Theme.TextColor,
							BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)),
							Position = UDim2.new(0, 2, 0, 2),
							Size = UDim2.new(0, 22, 0, 22),
							Image = "http://www.roblox.com/asset/?id=7827504335",

							SelfModules.UI.Create("ImageLabel", {
								Name = "Glow",
								BackgroundTransparency = 1,
								Position = UDim2.new(0, -13, 0, -13),
								Size = UDim2.new(1, 26, 1, 26),
								Image = "rbxassetid://10822615828",
								ImageColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)),
								ScaleType = Enum.ScaleType.Slice,
								SliceCenter = Rect.new(99, 99, 99, 99),
								ImageTransparency = 0.5,
								SliceScale = 0.2,
							}),
						}, UDim.new(1, 0)),
					}, UDim.new(1, 0))

					-- Scripts

					Tab.Flags[Bind.Flag] = options.default == true
					indicator.Parent = Bind.Frame.Holder

					Bind.Frame.Holder.Indicator.MouseEnter:Connect(function()
						indicatorEntered = true
					end)

					Bind.Frame.Holder.Indicator.MouseLeave:Connect(function()
						indicatorEntered = false
					end)

					Bind:Toggle(options.default == true, true)
					Bind.Boolean = options.default == true or false
				end

				Bind:Set(Bind.Bind)

				return Bind
			end

			-- Slider

			function Section:AddSlider(name, min, max, default, options, callback)
				local Slider = {
					Name = name,
					Type = "Slider",
					Value = default,
					Min = min,
					Max = max,
					Flag = options.flag or name,
					Cap = options.cap or false,
					Callback = callback,
				}

				Slider.Frame = SelfModules.UI.Create("Frame", {
					Name = name,
					BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
					Size = UDim2.new(1, 2, 0, 41),

					SelfModules.UI.Create("Frame", {
						Name = "Holder",
						BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
						Position = UDim2.new(0, 1, 0, 1),
						Size = UDim2.new(1, -2, 1, -2),

						SelfModules.UI.Create("TextLabel", {
							Name = "Label",
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 5, 0, 5),
							Size = UDim2.new(1, -75, 0, 14),
							Font = Enum.Font.SourceSans,
							Text = name,
							TextColor3 = Library.Theme.TextColor,
							TextSize = 14,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Left,
						}),

						SelfModules.UI.Create("Frame", {
							Name = "Slider",
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 5, 1, -15),
							Size = UDim2.new(1, -10, 0, 10),

							SelfModules.UI.Create("Frame", {
								Name = "Bar",
								BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
								ClipsDescendants = false,
								Size = UDim2.new(1, 0, 1, 0),

								SelfModules.UI.Create("Frame", {
									Name = "Fill",
									BackgroundColor3 = SelfModules.UI.Color.Sub(Library.Theme.Accent, Color3.fromRGB(10, 10, 10)),
									Size = UDim2.new(0.5, 0, 1, 0),

									SelfModules.UI.Create("ImageLabel", {
										Name = "Glow",
										BackgroundTransparency = 1,
										Position = UDim2.new(0, -12, 0, -12),
										Size = UDim2.new(1, 30, 1, 24),
										Image = "rbxassetid://10822615828",
										ImageColor3 = SelfModules.UI.Color.Sub(Library.Theme.Accent, Color3.fromRGB(10, 10, 10)),
										ScaleType = Enum.ScaleType.Slice,
										SliceCenter = Rect.new(99, 99, 99, 99),
										ImageTransparency = 0.9,
										SliceScale = 1,
									}),
								}, UDim.new(0, 5)),
							}, UDim.new(0, 5)),

							SelfModules.UI.Create("Frame", {
								Name = "Point",
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = Library.Theme.Accent,
								Position = UDim2.new(0.5, 0, 0.5, 0),
								Size = UDim2.new(0, 12, 0, 12),
							}, UDim.new(0, 5)),
						}),

						SelfModules.UI.Create("TextBox", {
							Name = "Input",
							AnchorPoint = Vector2.new(1, 0),
							BackgroundTransparency = 1,
							PlaceholderText = "...",
							Position = UDim2.new(1, -5, 0, 5),
							Size = UDim2.new(0, 60, 0, 14),
							Font = Enum.Font.SourceSans,
							Text = "",
							TextColor3 = Library.Theme.TextColor,
							TextSize = 14,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Right,
						}),
					}, UDim.new(0, 5)),
				}, UDim.new(0, 5))

				-- Variables

				local connections = {}

				-- Functions

				local function getSliderValue(val)
					if options.cap == true then
						val = math.clamp(val, Slider.Min, Slider.Max)
					else
						val = math.clamp(val, -math.huge, math.huge)
					end

					if options.rounded == true then
						val = math.floor(val)
					end

					return val
				end

				local function sliderVisual(val)
					val = getSliderValue(val)

					Slider.Frame.Holder.Input.Text = val

					local valuePercent = 1 - ((Slider.Max - val) / (Slider.Max - Slider.Min))
					local pointPadding = 1 / Slider.Frame.Holder.Slider.AbsoluteSize.X * 5
					tween(Slider.Frame.Holder.Slider.Bar.Fill, 0.25, { Size = UDim2.new(valuePercent, 0, 1, 0) })
					tween(Slider.Frame.Holder.Slider.Point, 0.25, { Position = UDim2.fromScale(math.clamp(valuePercent, pointPadding, 1 - pointPadding), 0.5) })
				end

				function Slider:Set(val)
					val = getSliderValue(val)
					Slider.Value = val
					sliderVisual(val)

					if options.toggleable == true and Tab.Flags[Slider.Flag] == false then
						return
					end

					pcall(task.spawn, Slider.Callback, val, Tab.Flags[Slider.Flag] or nil)
				end

				function Slider:Change(min, max)
					Slider.Min = min
					Slider.Max = max
					Slider:Set(getSliderValue(Slider.Value))
				end

				function Slider:SetName(text)
					Slider.Frame.Holder.Label.Text = text
				end

				function Slider:GetName(text)
					return Slider.Frame.Holder.Label.Text
				end

				if options.toggleable == true then
					function Slider:Toggle(bool, instant)
						Tab.Flags[Slider.Flag] = bool

						tween(Slider.Frame.Holder.Indicator.Overlay.Glow, instant and 0 or 0.25, { ImageColor3 = bool and Library.Theme.Accent or SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)), SliceScale = bool and 0.2 or 1, ImageTransparency = bool and 0.85 or 0.5 })
						tween(Slider.Frame.Holder.Indicator.Overlay, instant and 0 or 0.25, { ImageTransparency = bool and 0 or 1, Position = bool and UDim2.new(1, -24, 0, 2) or UDim2.new(0, 2, 0, 2) })
						tween(Slider.Frame.Holder.Indicator.Overlay.UICorner, instant and 0 or 0.25, { CornerRadius = UDim.new(bool and 0 or 1, bool and 5 or 0) })
						tween(Slider.Frame.Holder.Indicator.Overlay, "Cosmetic", instant and 0 or 0.25, { BackgroundColor3 = bool and SelfModules.UI.Color.Add(Library.Theme.Accent, Color3.fromRGB(5, 5, 5)) or SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)) })

						if options.fireontoggle ~= false then
							pcall(task.spawn, Slider.Callback, Slider.Value, bool)
						end
					end
				end

				-- Scripts

				Section.List[#Section.List + 1] = Slider
				Slider.Frame.Parent = Section.Frame.List

				Slider.Frame.Holder.Slider.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then

						connections.move = Mouse.Move:Connect(function()
							local sliderPercent = math.clamp((Mouse.X - Slider.Frame.Holder.Slider.AbsolutePosition.X) / Slider.Frame.Holder.Slider.AbsoluteSize.X, 0, 1)
							local sliderValue = math.floor((Slider.Min + sliderPercent * (Slider.Max - Slider.Min)) * 10) / 10

							if options.fireondrag ~= false then
								Slider:Set(sliderValue)
							else
								sliderVisual(sliderValue)
							end
						end)

					end
				end)

				Slider.Frame.Holder.Slider.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						connections.move:Disconnect()
						connections.move = nil

						if options.fireondrag ~= true then
							local sliderPercent = math.clamp((Mouse.X - Slider.Frame.Holder.Slider.AbsolutePosition.X) / Slider.Frame.Holder.Slider.AbsoluteSize.X, 0, 1)
							local sliderValue = math.floor((Slider.Min + sliderPercent * (Slider.Max - Slider.Min)) * 10) / 10

							Slider:Set(sliderValue)
						end
					end
				end)

				Slider.Frame.Holder.Input.FocusLost:Connect(function()
					Slider.Frame.Holder.Input.Text = string.sub(Slider.Frame.Holder.Input.Text, 1, 10)

					if tonumber(Slider.Frame.Holder.Input.Text) then
						Slider:Set(Slider.Frame.Holder.Input.Text)
					end
				end)

				if options.toggleable == true then
					local indicator = SelfModules.UI.Create("Frame", {
						Name = "Indicator",
						AnchorPoint = Vector2.new(1, 1),
						BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
						Position = UDim2.new(1, -2, 1, -2),
						Size = UDim2.new(0, 40, 0, 26),

						SelfModules.UI.Create("Frame", {
							Name = "Filler",
							BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
							Position = UDim2.new(0.5, 0, 0, 0),
							Size = UDim2.new(0.5, 0, 1, 0)
						}, UDim.new(0, 5)),

						SelfModules.UI.Create("ImageLabel", {
							Name = "Overlay",
							ImageColor3 = Library.Theme.TextColor,
							BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)),
							Position = UDim2.new(0, 2, 0, 2),
							Size = UDim2.new(0, 22, 0, 22),
							Image = "http://www.roblox.com/asset/?id=7827504335",
							SelfModules.UI.Create("ImageLabel", {
								Name = "Glow",
								BackgroundTransparency = 1,
								Position = UDim2.new(0, -13, 0, -13),
								Size = UDim2.new(1, 26, 1, 26),
								Image = "rbxassetid://10822615828",
								ImageColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)),
								ScaleType = Enum.ScaleType.Slice,
								SliceCenter = Rect.new(99, 99, 99, 99),
								ImageTransparency = 0.5,
								SliceScale = 0.2,
							}),
						}, UDim.new(1, 0)),
					}, UDim.new(1, 0))

					-- Scripts

					Tab.Flags[Slider.Flag] = options.default == true
					Slider.Frame.Size = UDim2.new(1, 2, 0, 54)
					Slider.Frame.Holder.Slider.Size = UDim2.new(1, -50, 0, 10)
					indicator.Parent = Slider.Frame.Holder

					Slider.Frame.Holder.Indicator.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							Slider:Toggle(not Tab.Flags[Slider.Flag], false)
						end
					end)

					Slider:Toggle(options.default == true, true)
				end

				Slider:Set(Slider.Value)

				return Slider
			end

			-- Selector

			function Section:AddChart(name, list, options, callback)

			end

			-- Dropdown

			function Section:AddDropdown(name, list, options, callback)
				local Dropdown = {
					Name = name,
					Type = "Dropdown",
					Toggled = false,
					Selected = options ~= nil and options.multi == true and {} or "",
					List = {},
					Callback = callback,
				}

				local ListObjects = {}

				Dropdown.Frame = SelfModules.UI.Create("Frame", {
					Name = "Dropdown",
					BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
					Size = UDim2.new(1, 2, 0, 42),

					SelfModules.UI.Create("Frame", {
						Name = "Holder",
						BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
						Position = UDim2.new(0, 1, 0, 1),
						Size = UDim2.new(1, -2, 1, -2),

						SelfModules.UI.Create("Frame", {
							Name = "Holder",
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 40),

							SelfModules.UI.Create("Frame", {
								Name = "Displays",
								BackgroundTransparency = 1,
								Position = UDim2.new(0, 5, 0, 8),
								Size = UDim2.new(1, -35, 0, 14),

								SelfModules.UI.Create("TextBox", {
									Name = "SearchBox",
									ClearTextOnFocus = false,
									TextTransparency = 1,
									BackgroundTransparency = 1,
									PlaceholderText = "Search",
									PlaceholderColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
									Font = Enum.Font.SourceSansBold,
									Text = "",
									TextSize = 14,
									TextWrapped = false,
									TextTruncate = Enum.TextTruncate.SplitWord,
									TextColor3 = Library.Theme.TextColor,
									TextXAlignment = Enum.TextXAlignment.Left,
									Size = UDim2.new(0, 0, 1, 0),
								}),

								SelfModules.UI.Create("TextLabel", {
									Name = "Label",
									BackgroundTransparency = 1,
									Size = UDim2.new(0.5, 0, 1, 0),
									Font = Enum.Font.SourceSans,
									Text = name,
									TextColor3 = Library.Theme.TextColor,
									TextSize = 14,
									TextWrapped = true,
									TextXAlignment = Enum.TextXAlignment.Left,
								}),

								SelfModules.UI.Create("TextLabel", {
									Name = "Selected",
									BackgroundTransparency = 1,
									Position = UDim2.new(0.5, 0, 0, 0),
									Size = UDim2.new(0.5, 0, 1, 0),
									Font = Enum.Font.SourceSans,
									Text = "",
									TextColor3 = Library.Theme.TextColor,
									TextSize = 14,
									TextWrapped = true,
									TextXAlignment = Enum.TextXAlignment.Right,
								}),
							}),

							SelfModules.UI.Create("ImageLabel", {
								Name = "Indicator",
								AnchorPoint = Vector2.new(1, 0),
								BackgroundTransparency = 1,
								Position = UDim2.new(1, -5, 0, 5),
								Size = UDim2.new(0, 20, 0, 20),
								Image = "rbxassetid://9243354333",
							}),

							SelfModules.UI.Create("Frame", {
								Name = "Line",
								BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
								BorderSizePixel = 0,
								Position = UDim2.new(0, 5, 0, 30),
								Size = UDim2.new(1, -10, 0, 2),
							}),
						}, UDim.new(0, 5)),

						SelfModules.UI.Create("ScrollingFrame", {
							Name = "List",
							Active = true,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Position = UDim2.new(0, 5, 0, 40),
							Size = UDim2.new(1, -10, 1, -40),
							CanvasSize = UDim2.new(0, 0, 0, 0),
							ScrollBarImageColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
							ScrollBarThickness = 5,

							SelfModules.UI.Create("UIListLayout", {
								SortOrder = Enum.SortOrder.LayoutOrder,
								Padding = UDim.new(0, 5),
							}),
						}),
					}, UDim.new(0,5)),
				}, UDim.new(0, 5))

				-- Functions

				function Dropdown:GetHeight()
					return 42 + (Dropdown.Toggled == true and math.min(#Dropdown.List, 5) * 27 or 0)
				end

				function Dropdown:UpdateHeight()
					Dropdown.Frame.Holder.List.CanvasSize = UDim2.new(0, 0, 0, #Dropdown.List * 27 - 5)

					if Dropdown.Toggled == true then
						Dropdown.Frame.Size = UDim2.new(1, 2, 0, Dropdown:GetHeight())
						Section:UpdateHeight()
					end
				end

				function Dropdown:Add(name, options, callback)
					local Item = {
						Name = name,
						Callback = callback,
					}

					Item.Frame = SelfModules.UI.Create("Frame", {
						Name = name,
						BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
						Size = UDim2.new(1, -10, 0, 22),

						SelfModules.UI.Create("TextButton", {
							Name = "Button",
							BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
							Position = UDim2.new(0, 1, 0, 1),
							Size = UDim2.new(1, -2, 1, -2),
							Font = Enum.Font.SourceSans,
							Text = name,
							TextColor3 = Library.Theme.TextColor,
							TextSize = 14,
							TextWrapped = true,
						}, UDim.new(0, 5)),
					}, UDim.new(0, 5))

					function Dropdown:SetName(text)
						Dropdown.Frame.Holder.Holder.Displays.Label = text
					end

					function Dropdown:GetName()
						return Dropdown.Frame.Holder.Holder.Displays.Label
					end

					-- Scripts

					Dropdown.List[#Dropdown.List + 1] = name
					ListObjects[#ListObjects + 1] = Item
					Item.Frame.Parent = Dropdown.Frame.Holder.List

					if Dropdown.Toggled == true then
						Dropdown:UpdateHeight()
					end

					Item.Frame.Button.Activated:Connect(function()
						if typeof(Item.Callback) == "function" then
							pcall(task.spawn, Item.Callback)
						else
							Dropdown:Select(Item.Name)
						end
					end)

					Dropdown.Frame.Holder.Holder.Displays.SearchBox.Size = UDim2.new(0, Dropdown.Frame.Holder.Holder.Displays.Label.TextBounds.X, 1, 0)

					Dropdown.Frame.Holder.Holder.Displays.SearchBox.Focused:Connect(function()
						Dropdown:Toggle(true)
						tween(Dropdown.Frame.Holder.Holder.Displays.SearchBox, 2, { Size = UDim2.new(1, -(Dropdown.Frame.Holder.Holder.Displays.Selected.TextBounds.X-1), 1, 0), TextTransparency = 0 })
						tween(Dropdown.Frame.Holder.Holder.Displays.Label, 0.5, { TextTransparency = 1 })
					end)

					Dropdown.Frame.Holder.Holder.Displays.SearchBox.FocusLost:Connect(function()
						tween(Dropdown.Frame.Holder.Holder.Displays.SearchBox, 0.5, { Size = UDim2.new(0, Dropdown.Frame.Holder.Holder.Displays.Label.TextBounds.X, 1, 0) })
						tween(Dropdown.Frame.Holder.Holder.Displays.Label, 0.5, { TextTransparency = 0 })
						Dropdown.Frame.Holder.Holder.Displays.SearchBox.Text = ""
					end)

					Dropdown.Frame.Holder.Holder.Displays.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
						local searchText = Dropdown.Frame.Holder.Holder.Displays.SearchBox.Text:lower()
						local list = Dropdown.Frame.Holder.List:GetChildren()

						for _, item in pairs(list) do
							if item:IsA("Frame") then
								if item.Name:lower():find(searchText) then
									item.Visible = true
								else
									item.Visible = false
								end
							end
						end
					end)

					return Item
				end

				function Dropdown:Remove(name, ignoreToggle)
					for i, v in next, Dropdown.List do
						if v == name then
							local item = ListObjects[i]

							if item then
								item.Frame:Destroy()
								table.remove(Dropdown.List, i)
								table.remove(ListObjects, i)

								if Dropdown.Toggled then
									Dropdown:UpdateHeight()
								end

								if #Dropdown.List == 0 and not ignoreToggle then
									Dropdown:Toggle(false)
								end
							end

							break
						end
					end
				end

				function Dropdown:ClearList()
					for _ = 1, #Dropdown.List, 1 do
						Dropdown:Remove(Dropdown.List[1], true)
					end
				end

				function Dropdown:SetList(list)
					Dropdown:ClearList()

					for _, v in next, list do
						Dropdown:Add(v)
					end
				end

				function Dropdown:Select(itemName)
					if options.multi == true then
						if table.find(Dropdown.Selected, itemName) then
							for i, v in ipairs(Dropdown.Selected) do
								if v == itemName then
									table.remove(Dropdown.Selected, i)
									break
								end
							end
						else
							table.insert(Dropdown.Selected, itemName)
						end
						Dropdown.Frame.Holder.Holder.Displays.Selected.Text = table.concat(Dropdown.Selected, ", ")
						pcall(task.spawn, Dropdown.Callback, Dropdown.Selected)
					else
						Dropdown.Selected = itemName
						Dropdown.Frame.Holder.Holder.Displays.Selected.Text = itemName
						Dropdown:Toggle(false)
						pcall(task.spawn, Dropdown.Callback, itemName)
					end
				end

				function Dropdown:Toggle(bool)
					Dropdown.Toggled = bool

					tween(Dropdown.Frame, 0.5, { Size = UDim2.new(1, 2, 0, Dropdown:GetHeight()) })
					tween(Dropdown.Frame.Holder.Holder.Indicator, 0.5, { Rotation = bool and 90 or 0 })
					tween(Section.Frame, 0.5, { Size = UDim2.new(1, -10, 0, Section:GetHeight()) })
					tween(Tab.Frame, 0.5, { CanvasSize = UDim2.new(0, 0, 0, Tab:GetHeight()) })
				end

				-- Scripts

				Section.List[#Section.List + 1] = Dropdown
				Dropdown.Frame.Parent = Section.Frame.List

				Dropdown.Frame.Holder.List.ChildAdded:Connect(function(c)
					if c.ClassName == "Frame" then
						Dropdown:UpdateHeight()
					end
				end)

				Dropdown.Frame.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 and #Dropdown.List > 0 and Mouse.Y - Dropdown.Frame.AbsolutePosition.Y <= 30 then
						Dropdown:Toggle(not Dropdown.Toggled)
					end
				end)

				for i, v in next, list do
					Dropdown:Add(v)
				end

				if typeof(options.default) == "string" then
					Dropdown:Select(options.default)
				end

				return Dropdown
			end

			-- Picker

			function Section:AddPicker(name, options, callback)
				local Picker = {
					Name = name,
					Type = "Picker",
					Toggled = false,
					Rainbow = false,
					RainbowSpeed = 1,
					Callback = callback,
				}

				local h, s, v = (options.color or Library.Theme.Accent):ToHSV()
				Picker.Color = { R = h, G = s, B = v }

				Picker.Frame = SelfModules.UI.Create("Frame", {
					Name = "ColorPicker",
					BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
					ClipsDescendants = true,
					Size = UDim2.new(1, 2, 0, 42),

					SelfModules.UI.Create("Frame", {
						Name = "Holder",
						BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
						ClipsDescendants = true,
						Position = UDim2.new(0, 1, 0, 1),
						Size = UDim2.new(1, -2, 1, -2),

						SelfModules.UI.Create("Frame", {
							Name = "Top",
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 40),

							SelfModules.UI.Create("TextLabel", {
								Name = "Label",
								BackgroundTransparency = 1,
								Position = UDim2.new(0, 5, 0, 8),
								Size = UDim2.new(0.5, -15, 0, 14),
								Font = Enum.Font.SourceSans,
								Text = name,
								TextColor3 = Library.Theme.TextColor,
								TextSize = 14,
								TextWrapped = true,
								TextXAlignment = Enum.TextXAlignment.Left,
							}),

							SelfModules.UI.Create("Frame", {
								Name = "Selected",
								AnchorPoint = Vector2.new(1, 0),
								BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
								Position = UDim2.new(1, -29, 0, 2),
								Size = UDim2.new(0, 100, 0, 26),

								SelfModules.UI.Create("Frame", {
									Name = "Preview",
									BackgroundColor3 = Color3.fromHSV(Picker.Color.R, Picker.Color.G, Picker.Color.B),
									Position = UDim2.new(0, 1, 0, 1),
									Size = UDim2.new(1, -2, 1, -2),

									SelfModules.UI.Create("ImageLabel", {
										Name = "Glow",
										BackgroundTransparency = 1,
										Position = UDim2.new(0, -12, 0, -12),
										Size = UDim2.new(1, 24, 1, 24),
										Image = "rbxassetid://10822615828",
										ImageColor3 = Color3.fromHSV(Picker.Color.R, Picker.Color.G, Picker.Color.B),
										ScaleType = Enum.ScaleType.Slice,
										SliceCenter = Rect.new(99, 99, 99, 99),
										ImageTransparency = 0.75,
										SliceScale = 0.2,
									}),
								}, UDim.new(0, 5)),

								SelfModules.UI.Create("TextLabel", {
									Name = "Display",
									AnchorPoint = Vector2.new(0, 0.5),
									BackgroundTransparency = 1,
									Position = UDim2.new(0, 0, 0.5, 0),
									Size = UDim2.new(1, 0, 0, 16),
									Font = Enum.Font.SourceSans,
									Text = "",
									TextColor3 = Library.Theme.TextColor,
									TextSize = 16,
									TextStrokeColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
									TextStrokeTransparency = 0.5,
								}),
							}, UDim.new(0, 5)),

							SelfModules.UI.Create("ImageLabel", {
								Name = "Indicator",
								AnchorPoint = Vector2.new(1, 0),
								BackgroundTransparency = 1,
								Position = UDim2.new(1, -5, 0, 5),
								Size = UDim2.new(0, 20, 0, 20),
								Image = "rbxassetid://9243354333",
							}),

							SelfModules.UI.Create("Frame", {
								Name = "Line",
								BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
								BorderSizePixel = 0,
								Position = UDim2.new(0, 5, 0, 30),
								Size = UDim2.new(1, -10, 0, 2),
							}),
						}),

						SelfModules.UI.Create("Frame", {
							Name = "Holder",
							Active = true,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Position = UDim2.new(0, 0, 0, 40),
							Size = UDim2.new(1, 0, 1, -40),

							SelfModules.UI.Create("Frame", {
								Name = "Palette",
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
								Position = UDim2.new(0, 5, 0, 5),
								Size = UDim2.new(1, -196, 0, 110),

								SelfModules.UI.Create("Frame", {
									Name = "Point",
									AnchorPoint = Vector2.new(0.5, 0.5),
									BackgroundColor3 = SelfModules.UI.Color.Sub(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
									Position = UDim2.new(1, 0, 0, 0),
									Size = UDim2.new(0, 7, 0, 7),
									ZIndex = 2,

									SelfModules.UI.Create("Frame", {
										Name = "Inner",
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										Position = UDim2.new(0, 1, 0, 1),
										Size = UDim2.new(1, -2, 1, -2),
										ZIndex = 2,
									}, UDim.new(1, 0)),
								}, UDim.new(1, 0)),

								SelfModules.UI.Create("Frame", {
									Name = "Hue",
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BorderSizePixel = 0,
									Size = UDim2.new(1, 0, 1, 0),

									SelfModules.UI.Create("UIGradient", {
										Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromHSV(Picker.Color.R, Picker.Color.G, Picker.Color.B))},
									}),

									SelfModules.UI.Create("ImageLabel", {
										Name = "Glow",
										BackgroundTransparency = 1,
										ScaleType = Enum.ScaleType.Slice,
										SliceCenter = Rect.new(99, 99, 99, 99),
										SliceScale = 0.2,
										Size = UDim2.new(1, 24, 1, 24),
										Position = UDim2.new(0, -12, 0, -12),
										Image = "rbxassetid://10822615828",
										ImageTransparency = 0.75,

										SelfModules.UI.Create("UIGradient", {
											Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromHSV(Picker.Color.R, Picker.Color.G, Picker.Color.B))},
											Rotation = -45,
											Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(0.90, 1.00), NumberSequenceKeypoint.new(1.00, 0.00)}
										}),
									}),
								}, UDim.new(0, 5)),

								SelfModules.UI.Create("Frame", {
									Name = "SatVal",
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BorderSizePixel = 0,
									Size = UDim2.new(1, 0, 1, 0),
									ZIndex = 2,

									SelfModules.UI.Create("UIGradient", {
										Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0))},
										Rotation = 90,
										Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(1.00, 0.00)},
									}),	
								}, UDim.new(0, 5)),
							}),

							SelfModules.UI.Create("Frame", {
								Name = "HueSlider",
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BorderSizePixel = 0,
								Position = UDim2.new(0, 5, 0, 125),
								Size = UDim2.new(1, -10, 0, 20),

								SelfModules.UI.Create("ImageLabel", {
									Name = "Glow",
									BackgroundTransparency = 1,
									Position = UDim2.new(0, -12, 0, -12),
									Size = UDim2.new(1, 24, 1, 24),
									Image = "rbxassetid://10822615828",
									ImageColor3 = Color3.fromRGB(255, 255, 255),
									ScaleType = Enum.ScaleType.Slice,
									SliceCenter = Rect.new(99, 99, 99, 99),
									ImageTransparency = 0.75,
									SliceScale = 0.2,

									SelfModules.UI.Create("UIGradient", {
										Color = ColorSequence.new{
											ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
											ColorSequenceKeypoint.new(0.16666, Color3.fromRGB(255, 255, 0)),
											ColorSequenceKeypoint.new(0.33333, Color3.fromRGB(0, 255, 0)),
											ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
											ColorSequenceKeypoint.new(0.66667, Color3.fromRGB(0, 0, 255)),
											ColorSequenceKeypoint.new(0.83333, Color3.fromRGB(255, 0, 255)),
											ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
										},
									}),
								}),

								SelfModules.UI.Create("UIGradient", {
									Color = ColorSequence.new{
										ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
										ColorSequenceKeypoint.new(0.16666, Color3.fromRGB(255, 255, 0)),
										ColorSequenceKeypoint.new(0.33333, Color3.fromRGB(0, 255, 0)),
										ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
										ColorSequenceKeypoint.new(0.66667, Color3.fromRGB(0, 0, 255)),
										ColorSequenceKeypoint.new(0.83333, Color3.fromRGB(255, 0, 255)),
										ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
									},
								}),

								SelfModules.UI.Create("Frame", {
									Name = "Bar",
									AnchorPoint = Vector2.new(0.5, 0.5),
									BackgroundColor3 = SelfModules.UI.Color.Sub(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
									Position = UDim2.new(0.5, 0, 0, 0),
									Size = UDim2.new(0, 6, 1, 6),

									SelfModules.UI.Create("Frame", {
										Name = "Inner",
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										Position = UDim2.new(0, 1, 0, 1),
										Size = UDim2.new(1, -2, 1, -2),
									}, UDim.new(0, 5)),
								}, UDim.new(0, 5)),
							}, UDim.new(0, 5)),

							SelfModules.UI.Create("Frame", {
								Name = "RGB",
								BackgroundTransparency = 1,
								Position = UDim2.new(1, -180, 0, 5),
								Size = UDim2.new(0, 75, 0, 110),

								SelfModules.UI.Create("Frame", {
									Name = "Red",
									BackgroundTransparency = 1,
									Size = UDim2.new(1, 0, 0, 30),

									SelfModules.UI.Create("TextBox", {
										Name = "Box",
										BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
										Size = UDim2.new(1, 0, 1, 0),
										Font = Enum.Font.SourceSans,
										PlaceholderText = "R",
										Text = 255,
										TextColor3 = Library.Theme.TextColor,
										TextSize = 16,
										TextWrapped = true,
									}, UDim.new(0, 5)),
								}, UDim.new(0, 5)),

								SelfModules.UI.Create("Frame", {
									Name = "Green",
									BackgroundTransparency = 1,
									Position = UDim2.new(0, 0, 0, 40),
									Size = UDim2.new(1, 0, 0, 30),

									SelfModules.UI.Create("TextBox", {
										Name = "Box",
										BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
										Size = UDim2.new(1, 0, 1, 0),
										Font = Enum.Font.SourceSans,
										PlaceholderText = "G",
										Text = 0,
										TextColor3 = Library.Theme.TextColor,
										TextSize = 16,
										TextWrapped = true,
									}, UDim.new(0, 5)),
								}, UDim.new(0, 5)),

								SelfModules.UI.Create("Frame", {
									Name = "Blue",
									BackgroundTransparency = 1,
									Position = UDim2.new(0, 0, 0, 80),
									Size = UDim2.new(1, 0, 0, 30),

									SelfModules.UI.Create("TextBox", {
										Name = "Box",
										BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
										Size = UDim2.new(1, 0, 1, 0),
										Font = Enum.Font.SourceSans,
										PlaceholderText = "B",
										Text = 0,
										TextColor3 = Library.Theme.TextColor,
										TextSize = 16,
										TextWrapped = true,
									}, UDim.new(0, 5)),
								}, UDim.new(0, 5)),
							}),

							SelfModules.UI.Create("Frame", {
								Name = "Rainbow",
								AnchorPoint = Vector2.new(1, 0),
								BackgroundTransparency = 1,
								Position = UDim2.new(1, -5, 0, 87),
								Size = UDim2.new(0, 90, 0, 26),

								SelfModules.UI.Create("TextLabel", {
									Name = "Label",
									AnchorPoint = Vector2.new(0, 0.5),
									BackgroundTransparency = 1,
									Position = UDim2.new(0, 47, 0.5, 0),
									Size = UDim2.new(1, -47, 0, 14),
									Font = Enum.Font.SourceSans,
									Text = "Rainbow",
									TextColor3 = Library.Theme.TextColor,
									TextSize = 14,
									TextWrapped = true,
									TextXAlignment = Enum.TextXAlignment.Left,
								}),

								SelfModules.UI.Create("Frame", {
									Name = "Indicator",
									BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
									Size = UDim2.new(0, 40, 0, 26),

									SelfModules.UI.Create("ImageLabel", {
										Name = "Overlay",
										BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)),
										Position = UDim2.new(0, 2, 0, 2),
										Size = UDim2.new(0, 22, 0, 22),
										Image = "http://www.roblox.com/asset/?id=7827504335",
										ImageTransparency = 1,
									}, UDim.new(0, 5)),
								}, UDim.new(0, 5)),
							})
						}),
					}, UDim.new(0, 5)),
				}, UDim.new(0, 5))

				-- Variables

				local hueDragging, satDragging = false, false

				-- Functions

				function Picker:GetHeight()
					return Picker.Toggled == true and 192 or 42
				end

				function Picker:Toggle(bool)
					Picker.Toggled = bool

					tween(Picker.Frame, 0.5, { Size = UDim2.new(1, 2, 0, Picker:GetHeight()) })
					tween(Picker.Frame.Holder.Top.Indicator, 0.5, { Rotation = bool and 90 or 0 })
					tween(Section.Frame, 0.5, { Size = UDim2.new(1, -10, 0, Section:GetHeight()) })
					tween(Tab.Frame, 0.5, { CanvasSize = UDim2.new(0, 0, 0, Tab:GetHeight()) })
				end

				function Picker:ToggleRainbow(bool)
					Picker.Rainbow = bool

					tween(Picker.Frame.Holder.Holder.Rainbow.Indicator.Overlay, 0.25, {ImageTransparency = bool and 0 or 1, Position = bool and UDim2.new(1, -24, 0, 2) or UDim2.new(0, 2, 0, 2) })
					tween(Picker.Frame.Holder.Holder.Rainbow.Indicator.Overlay, "Cosmetic", 0.25, { BackgroundColor3 = bool and SelfModules.UI.Color.Add(Library.Theme.Accent, Color3.fromRGB(15, 15, 15)) or SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)) })

					if bool then
						if not Storage.Connections[Picker] then
							Storage.Connections[Picker] = {}
						end

						Storage.Connections[Picker].Rainbow = RS.Heartbeat:Connect(function()
							Picker:Set(tick() % Picker.RainbowSpeed / Picker.RainbowSpeed, Picker.Color.G, Picker.Color.B)
						end)

					elseif Storage.Connections[Picker] then
						Storage.Connections[Picker].Rainbow:Disconnect()
						Storage.Connections[Picker].Rainbow = nil
					end
				end

				function Picker:Speed(value)
					Picker.RainbowSpeed = tonumber(value)
				end

				function Picker:Set(h, s, v)
					Picker.Color.R, Picker.Color.G, Picker.Color.B = h, s, v

					local color = Color3.fromHSV(h, s, v)
					Picker.Frame.Holder.Holder.Palette.Hue.UIGradient.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromHSV(h, 1, 1))
					Picker.Frame.Holder.Top.Selected.Preview.BackgroundColor3 = color
					Picker.Frame.Holder.Top.Selected.Preview.Glow.ImageColor3 = color
					Picker.Frame.Holder.Top.Selected.Display.Text = string.format("%d, %d, %d", math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
					Picker.Frame.Holder.Top.Selected.Size = UDim2.new(0, math.round(TXS:GetTextSize(Picker.Frame.Holder.Top.Selected.Display.Text, 16, Enum.Font.SourceSans, Vector2.new(9e9)).X + 0.5) + 20, 0, 26)

					Picker.Frame.Holder.Holder.RGB.Red.Box.Text = math.floor(color.R * 255 + 0.5)
					Picker.Frame.Holder.Holder.RGB.Green.Box.Text = math.floor(color.G * 255 + 0.5)
					Picker.Frame.Holder.Holder.RGB.Blue.Box.Text = math.floor(color.B * 255 + 0.5)

					Picker.Frame.Holder.Holder.Palette.Hue.Glow.UIGradient.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromHSV(h, 1, 1))					

					tween(Picker.Frame.Holder.Holder.HueSlider.Bar, 0.1, { Position = UDim2.new(h, 0, 0.5, 0) })
					tween(Picker.Frame.Holder.Holder.Palette.Point, 0.1, { Position = UDim2.new(s, 0, 1 - v, 0) })

					pcall(task.spawn, Picker.Callback, color)
				end

				function Picker:Get()
					return Picker.Color.R, Picker.Color.G, Picker.Color.B
				end

				function Picker:SetName(text)
					Picker.Frame.Holder.Top.Label.Text = text
				end

				function Picker:GetName()
					return Picker.Frame.Holder.Top.Label
				end

				-- Scripts

				Section.List[#Section.List + 1] = Picker
				Picker.Frame.Parent = Section.Frame.List

				Picker.Frame.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 and Mouse.Y - Picker.Frame.AbsolutePosition.Y <= 30 then
						Picker:Toggle(not Picker.Toggled)
					end
				end)

				Picker.Frame.Holder.Holder.HueSlider.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						hueDragging = true
					end
				end)

				Picker.Frame.Holder.Holder.HueSlider.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						hueDragging = false
					end
				end)

				Picker.Frame.Holder.Holder.Palette.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						satDragging = true
					end
				end)

				Picker.Frame.Holder.Holder.Palette.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						satDragging = false
					end
				end)

				Mouse.Move:Connect(function()
					if hueDragging and not Picker.Rainbow then
						Picker:Set(math.clamp((Mouse.X - Picker.Frame.Holder.Holder.HueSlider.AbsolutePosition.X) / Picker.Frame.Holder.Holder.HueSlider.AbsoluteSize.X, 0, 1), Picker.Color.G, Picker.Color.B)

					elseif satDragging then
						Picker:Set(Picker.Color.R, math.clamp((Mouse.X - Picker.Frame.Holder.Holder.Palette.AbsolutePosition.X) / Picker.Frame.Holder.Holder.Palette.AbsoluteSize.X, 0, 1), 1 - math.clamp((Mouse.Y - Picker.Frame.Holder.Holder.Palette.AbsolutePosition.Y) / Picker.Frame.Holder.Holder.Palette.AbsoluteSize.Y, 0, 1))
					end
				end)

				Picker.Frame.Holder.Holder.RGB.Red.Box.FocusLost:Connect(function()
					local num = tonumber(Picker.Frame.Holder.Holder.RGB.Red.Box.Text)
					local color = Color3.fromHSV(Picker.Color.R, Picker.Color.G, Picker.Color.B)

					if num then
						Picker:Set(Color3.new(math.clamp(math.floor(num), 0, 255) / 255, color.G, color.B):ToHSV())
					else
						Picker.Frame.Holder.Holder.RGB.Red.Box.Text = math.floor(color.R * 255 + 0.5)
					end
				end)

				Picker.Frame.Holder.Holder.RGB.Green.Box.FocusLost:Connect(function()
					local num = tonumber(Picker.Frame.Holder.Holder.RGB.Green.Box.Text)
					local color = Color3.fromHSV(Picker.Color.R, Picker.Color.G, Picker.Color.B)

					if num then
						Picker:Set(Color3.new(color.R, math.clamp(math.floor(num), 0, 255) / 255, color.B):ToHSV() )
					else
						Picker.Frame.Holder.Holder.RGB.Green.Box.Text = math.floor(color.B * 255 + 0.5)
					end
				end)

				Picker.Frame.Holder.Holder.RGB.Blue.Box.FocusLost:Connect(function()
					local num = tonumber(Picker.Frame.Holder.Holder.RGB.Blue.Box.Text)
					local color = Color3.fromHSV(Picker.Color.R, Picker.Color.G, Picker.Color.B)

					if num then
						Picker:Set(Color3.new(color.R, color.G, math.clamp(math.floor(num), 0, 255) / 255):ToHSV())
					else
						Picker.Frame.Holder.Holder.RGB.Blue.Box.Text = math.floor(color.B * 255 + 0.5)
					end
				end)

				Picker.Frame.Holder.Holder.Rainbow.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						Picker:ToggleRainbow(not Picker.Rainbow)
					end
				end)

				Picker:Set(Picker.Color.R, Picker.Color.G, Picker.Color.B)

				return Picker
			end

			-- SubSection

			function Section:AddSubSection(name, options)
				options = options or {}

				local SubSection = {
					Name = name,
					Type = "SubSection",
					Toggled = options.default or false,
					List = {},
				}

				SubSection.Frame = SelfModules.UI.Create("Frame", {
					Name = "SubSection",
					BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
					Size = UDim2.new(1, 2, 0, 42),

					SelfModules.UI.Create("Frame", {
						Name = "Holder",
						BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
						Position = UDim2.new(0, 1, 0, 1),
						Size = UDim2.new(1, -2, 1, -2),

						SelfModules.UI.Create("TextLabel", {
							Name = "Header",
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 5, 0, 8),
							Size = UDim2.new(1, -40, 0, 14),
							Font = Enum.Font.SourceSans,
							Text = name,
							TextColor3 = Library.Theme.TextColor,
							TextSize = 14,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Left,
						}),

						SelfModules.UI.Create("TextLabel", {
							Name = "Indicator",
							AnchorPoint = Vector2.new(1, 0),
							BackgroundTransparency = 1,
							Position = UDim2.new(1, -5, 0, 5),
							Size = UDim2.new(0, 20, 0, 20),
							Font = Enum.Font.SourceSansBold,
							Text = "+",
							TextColor3 = Library.Theme.TextColor,
							TextSize = 20,
						}),

						SelfModules.UI.Create("Frame", {
							Name = "Line",
							BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
							BorderSizePixel = 0,
							Position = UDim2.new(0, 5, 0, 30),
							Size = UDim2.new(1, -10, 0, 2),
						}),

						SelfModules.UI.Create("Frame", {
							Name = "List",
							BackgroundTransparency = 1,
							ClipsDescendants = true,
							Position = UDim2.new(0, 5, 0, 40),
							Size = UDim2.new(1, -10, 1, -40),

							SelfModules.UI.Create("UIListLayout", {
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								SortOrder = Enum.SortOrder.LayoutOrder,
								Padding = UDim.new(0, 5),
							}),

							SelfModules.UI.Create("UIPadding", {
								PaddingBottom = UDim.new(0, 1),
								PaddingLeft = UDim.new(0, 1),
								PaddingRight = UDim.new(0, 1),
								PaddingTop = UDim.new(0, 1),
							}),
						}),
					}, UDim.new(0, 5)),
				}, UDim.new(0, 5))

				-- Functions

				local function toggleSubSection(bool)
					SubSection.Toggled = bool

					tween(SubSection.Frame, 0.5, { Size = UDim2.new(1, 2, 0, SubSection:GetHeight()) })
					tween(SubSection.Frame.Holder.Indicator, 0.5, { Rotation = bool and 45 or 0 })

					tween(Section.Frame, 0.5, { Size = UDim2.new(1, -10, 0, Section:GetHeight()) })
					tween(Tab.Frame, 0.5, { CanvasSize = UDim2.new(0, 0, 0, Tab:GetHeight()) })
				end

				function SubSection:GetHeight()
					local height = 42

					if SubSection.Toggled == true then
						for i, v in next, self.List do
							height = height + (v.GetHeight ~= nil and v:GetHeight() or v.Frame.AbsoluteSize.Y) + 5
						end
					end

					return height
				end

				function SubSection:UpdateHeight()
					if SubSection.Toggled == true then
						SubSection.Frame.Size = UDim2.new(1, 2, 0, SubSection:GetHeight())
						SubSection.Frame.Holder.Indicator.Rotation = 45

						Section:UpdateHeight()
					end
				end

				function Section:SetName(text)
					SubSection.Frame.Holder.Header.Text = text
				end

				function Section:GetName()
					return SubSection.Frame.Holder.Header.Text
				end

				-- Button

				function SubSection:AddButton(name1, callback1, options)
					-- options = { Dual = true/false, Name2 = "Button 2 Name", Callback2 = function() end }
					options = options or {}
					local isDual = options.Dual == true

					local Button = {
						Type = "Button",
						Callback1 = callback1,
						Callback2 = options.Callback2,
					}

					Button.Frame = SelfModules.UI.Create("Frame", {
						Name = "ButtonFrame",
						BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
						Size = UDim2.new(1, 2, 0, 32),
					}, UDim.new(0, 5))

					local holderFrame = SelfModules.UI.Create("Frame", {
						Name = "Holder",
						BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
						Size = UDim2.new(1, -2, 1, -2),
						Position = UDim2.new(0, 1, 0, 1),
					}, UDim.new(0, 5))
					holderFrame.Parent = Button.Frame

					-- helper to create button
					local function createTextButton(btnName, callback, posScale, sizeScale)
						local btn = SelfModules.UI.Create("TextButton", {
							Name = btnName,
							BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
							Position = posScale,
							Size = sizeScale,
							AutoButtonColor = false,
							Font = Enum.Font.SourceSans,
							Text = btnName,
							TextColor3 = Library.Theme.TextColor,
							TextSize = 14,
							TextWrapped = true,
						}, UDim.new(0, 5))

						btn.Parent = holderFrame

						-- visual effect
						local function buttonVisual()
							task.spawn(function()
								local Visual = SelfModules.UI.Create("Frame", {
									Name = "Visual",
									AnchorPoint = Vector2.new(0.5, 0.5),
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BackgroundTransparency = 0.9,
									Position = UDim2.new(0.5, 0, 0.5, 0),
									Size = UDim2.new(0, 0, 1, 0),
								}, UDim.new(0, 5))

								Visual.Parent = btn
								tween(Visual, 0.5, { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 })
								task.wait(0.5)
								Visual:Destroy()
							end)
						end

						-- interactions
						btn.MouseButton1Down:Connect(function()
							btn.TextSize = 12
						end)

						btn.MouseButton1Up:Connect(function()
							btn.TextSize = 14
							buttonVisual()
							pcall(task.spawn, callback)
						end)

						btn.MouseLeave:Connect(function()
							btn.TextSize = 14
						end)
					end

					-- decide single or dual button
					if isDual and options.Name2 and options.Callback2 then
						createTextButton(name1, callback1, UDim2.new(0, 2, 0, 2), UDim2.new(0.5, -4, 1, -4))
						createTextButton(options.Name2, options.Callback2, UDim2.new(0.5, 2, 0, 2), UDim2.new(0.5, -4, 1, -4))
					else
						createTextButton(name1, callback1, UDim2.new(0, 2, 0, 2), UDim2.new(1, -4, 1, -4))
					end

					Button.Frame.Parent = SubSection.Frame.Holder.List
					SubSection.List[#SubSection.List + 1] = Button

					return Button
				end

				-- Toggle

				function SubSection:AddToggle(name, options, callback)
					local Toggle = {
						Name = name,
						Type = "Toggle",
						Flag = options and options.flag or name,
						Callback = callback,
						Boolean = nil,
					}

					Toggle.Frame = SelfModules.UI.Create("Frame", {
						Name = name,
						BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
						Size = UDim2.new(1, 2, 0, 32),

						SelfModules.UI.Create("Frame", {
							Name = "Holder",
							BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
							Position = UDim2.new(0, 1, 0, 1),
							Size = UDim2.new(1, -2, 1, -2),

							SelfModules.UI.Create("TextLabel", {
								Name = "Label",
								BackgroundTransparency = 1,
								Position = UDim2.new(0, 5, 0.5, -7),
								Size = UDim2.new(1, -50, 0, 14),
								Font = Enum.Font.SourceSans,
								Text = name,
								TextColor3 = Library.Theme.TextColor,
								TextSize = 14,
								TextWrapped = true,
								TextXAlignment = Enum.TextXAlignment.Left,
							}),

							SelfModules.UI.Create("Frame", {
								Name = "Indicator",
								BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
								Position = UDim2.new(1, -42, 0, 2),
								Size = UDim2.new(0, 40, 0, 26),

								SelfModules.UI.Create("Frame", {
									Name = "Filler",
									BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
									Position = UDim2.new(0.5, 0, 0, 0),
									Size = UDim2.new(0.5, 0, 1, 0)
								}, UDim.new(0, 5)),

								SelfModules.UI.Create("ImageLabel", {
									Name = "Overlay",
									BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)),
									Position = UDim2.new(0, 2, 0, 2),
									Size = UDim2.new(0, 22, 0, 22),
									Image = "http://www.roblox.com/asset/?id=7827504335",
									ImageTransparency = 1,

									SelfModules.UI.Create("ImageLabel", {
										Name = "Glow",
										BackgroundTransparency = 1,
										Position = UDim2.new(0, -13, 0, -13),
										Size = UDim2.new(1, 26, 1, 26),
										Image = "rbxassetid://10822615828",
										ImageColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)),
										ScaleType = Enum.ScaleType.Slice,
										SliceCenter = Rect.new(99, 99, 99, 99),
										ImageTransparency = 0.5,
										SliceScale = 0.2,
									}),
								}, UDim.new(1, 0)),
							}, UDim.new(1, 0))
						}, UDim.new(0, 5)),
					}, UDim.new(0, 5))

					-- Functions

					function Toggle:Set(bool, instant)
						Tab.Flags[Toggle.Flag] = bool

						tween(Toggle.Frame.Holder.Indicator.Overlay.Glow, instant and 0 or 0.25, { ImageColor3 = bool and Library.Theme.Accent or SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)), SliceScale = bool and 0.2 or 1, ImageTransparency = bool and 0.85 or 0.5 })
						tween(Toggle.Frame.Holder.Indicator.Overlay, instant and 0 or 0.25, { ImageTransparency = bool and 0 or 1, Position = bool and UDim2.new(1, -24, 0, 2) or UDim2.new(0, 2, 0, 2) })
						tween(Toggle.Frame.Holder.Indicator.Overlay.UICorner, instant and 0 or 0.25, { CornerRadius = UDim.new(bool and 0 or 1, bool and 5 or 0) })
						tween(Toggle.Frame.Holder.Indicator.Overlay, "Cosmetic", instant and 0 or 0.25, { BackgroundColor3 = bool and SelfModules.UI.Color.Add(Library.Theme.Accent, Color3.fromRGB(5, 5, 5)) or SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)) })

						Toggle.Boolean = bool

						pcall(task.spawn, Toggle.Callback, bool)
					end

					function Toggle:Get()
						return Toggle.Boolean
					end

					-- Scripts

					SubSection.List[#SubSection.List + 1] = Toggle
					Tab.Flags[Toggle.Flag] = options.default == true
					Toggle.Frame.Parent = SubSection.Frame.Holder.List

					Toggle.Frame.Holder.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							Toggle:Set(not Tab.Flags[Toggle.Flag], false)
						end
					end)

					Toggle:Set(options.default == true, true)
					Toggle.Boolean = options.default == true or false

					return Toggle
				end

				-- Label

				function SubSection:AddLabel(name)
					local Label = {
						Name = name,
						Type = "Label",
					}

					Label.Frame = SelfModules.UI.Create("Frame", {
						Name = name,
						BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
						Size = UDim2.new(1, 2, 0, 22),

						SelfModules.UI.Create("Frame", {
							Name = "Holder",
							BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
							Position = UDim2.new(0, 1, 0, 1),
							Size = UDim2.new(1, -2, 1, -2),

							SelfModules.UI.Create("TextLabel", {
								Name = "Label",
								AnchorPoint = Vector2.new(0, 0.5),
								BackgroundTransparency = 1,
								Position = UDim2.new(0, 2, 0.5, 0),
								Size = UDim2.new(1, -4, 0, 14),
								Font = Enum.Font.SourceSans,
								Text = name,
								TextColor3 = Library.Theme.TextColor,
								TextSize = 14,
								TextWrapped = true,
							}),
						}, UDim.new(0, 5))
					}, UDim.new(0, 5))

					-- Functions

					function Label:SetName(text)
						Label.Frame.Holder.Label.Text = text
					end

					function Label:GetName()
						return Label.Frame.Holder.Label.Text
					end

					-- Scripts

					SubSection.List[#SubSection.List + 1] = Label
					Label.Label = Label.Frame.Holder.Label
					Label.Frame.Parent = SubSection.Frame.Holder.List

					return Label
				end

				-- DualLabel

				function SubSection:AddDualLabel(options)
					options = options or {}

					local DualLabel = {
						Name = options[1].. " ".. options[2],
						Type = "DualLabel",
					}

					DualLabel.Frame = SelfModules.UI.Create("Frame", {
						Name = options[1].. " ".. options[2],
						BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
						Size = UDim2.new(1, 2, 0, 22),

						SelfModules.UI.Create("Frame", {
							Name = "Holder",
							BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
							Position = UDim2.new(0, 1, 0, 1),
							Size = UDim2.new(1, -2, 1, -2),

							SelfModules.UI.Create("TextLabel", {
								Name = "Label1",
								AnchorPoint = Vector2.new(0, 0.5),
								BackgroundTransparency = 1,
								Position = UDim2.new(0, 5, 0.5, 0),
								Size = UDim2.new(0.5, -5, 0, 14),
								Font = Enum.Font.SourceSans,
								Text = options[1],
								TextColor3 = Library.Theme.TextColor,
								TextSize = 14,
								TextWrapped = true,
								TextXAlignment = Enum.TextXAlignment.Left,
							}),

							SelfModules.UI.Create("TextLabel", {
								Name = "Label2",
								AnchorPoint = Vector2.new(0, 0.5),
								BackgroundTransparency = 1,
								Position = UDim2.new(0.5, 0, 0.5, 0),
								Size = UDim2.new(0.5, -5, 0, 14),
								Font = Enum.Font.SourceSans,
								Text = options[2],
								TextColor3 = Library.Theme.TextColor,
								TextSize = 14,
								TextWrapped = true,
								TextXAlignment = Enum.TextXAlignment.Right,
							}),
						}, UDim.new(0, 5))
					}, UDim.new(0, 5))

					-- Functions

					function DualLabel:SetLeftText(text)
						DualLabel.Frame.Holder.Label1.Text = text
					end

					function DualLabel:GetLeftText()
						return DualLabel.Frame.Holder.Label1.Text
					end

					function DualLabel:SetRightText(text)
						DualLabel.Frame.Holder.Label2.Text = text
					end

					function DualLabel:GetRightText()
						return DualLabel.Frame.Holder.Label2.Text
					end

					-- Scripts

					SubSection.List[#SubSection.List + 1] = DualLabel
					DualLabel.Label1 = DualLabel.Frame.Holder.Label1
					DualLabel.Label2 = DualLabel.Frame.Holder.Label2
					DualLabel.Frame.Parent = SubSection.Frame.Holder.List

					return DualLabel
				end

				-- ClipboardLabel

				function SubSection:AddClipboardLabel(name, callback)
					local ClipboardLabel = {
						Name = name,
						Type = "ClipboardLabel",
						Callback = callback,
					}

					ClipboardLabel.Frame = SelfModules.UI.Create("Frame", {
						Name = name,
						BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
						Size = UDim2.new(1, 2, 0, 22),

						SelfModules.UI.Create("Frame", {
							Name = "Holder",
							BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
							Position = UDim2.new(0, 1, 0, 1),
							Size = UDim2.new(1, -2, 1, -2),

							SelfModules.UI.Create("TextLabel", {
								Name = "Label",
								AnchorPoint = Vector2.new(0, 0.5),
								BackgroundTransparency = 1,
								Position = UDim2.new(0, 2, 0.5, 0),
								Size = UDim2.new(1, -22, 0, 14),
								Font = Enum.Font.SourceSans,
								Text = name,
								TextColor3 = Library.Theme.TextColor,
								TextSize = 14,
								TextWrapped = true,
							}),

							SelfModules.UI.Create("ImageLabel", {
								Name = "Icon",
								BackgroundTransparency = 1,
								Position = UDim2.new(1, -18, 0, 2),
								Size = UDim2.new(0, 16, 0, 16),
								Image = "rbxassetid://9243581053",
							}),
						}, UDim.new(0, 5)),
					}, UDim.new(0, 5))

					-- Functions

					function ClipboardLabel:SetName(text)
						ClipboardLabel.Frame.Holder.Label.Text = text
					end

					function ClipboardLabel:GetName()
						return ClipboardLabel.Frame.Holder.Label.Text
					end

					-- Scripts

					SubSection.List[#SubSection.List + 1] = ClipboardLabel
					ClipboardLabel.Label = ClipboardLabel.Frame.Holder.Label
					ClipboardLabel.Frame.Parent = SubSection.Frame.Holder.List

					ClipboardLabel.Frame.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							local s, result = pcall(ClipboardLabel.Callback)

							if s then
								warn(result)
							end
						end
					end)

					return ClipboardLabel
				end

				-- Box

				function SubSection:AddBox(name, options, callback)
					local Box = {
						Name = name,
						Type = "Box",
						Extend = options.extend or 200,
						Callback = callback,
					}

					Box.Frame = SelfModules.UI.Create("Frame", {
						Name = name,
						BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
						Size = UDim2.new(1, 2, 0, 32),

						SelfModules.UI.Create("Frame", {
							Name = "Holder",
							BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
							Position = UDim2.new(0, 1, 0, 1),
							Size = UDim2.new(1, -2, 1, -2),

							SelfModules.UI.Create("TextLabel", {
								Name = "Label",
								BackgroundTransparency = 1,
								Position = UDim2.new(0, 5, 0.5, -7),
								Size = UDim2.new(1, -135, 0, 14),
								Font = Enum.Font.SourceSans,
								Text = name,
								TextColor3 = Library.Theme.TextColor,
								TextSize = 14,
								TextWrapped = true,
								TextXAlignment = Enum.TextXAlignment.Left,
							}),

							SelfModules.UI.Create("Frame", {
								Name = "TextBox",
								AnchorPoint = Vector2.new(1, 0),
								BackgroundColor3 = Library.Theme.SectionColor,
								Position = UDim2.new(1, -2, 0, 2),
								Size = UDim2.new(0, 140, 1, -4),
								ZIndex = 2,

								SelfModules.UI.Create("Frame", {
									Name = "Holder",
									BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
									Position = UDim2.new(0, 1, 0, 1),
									Size = UDim2.new(1, -2, 1, -2),
									ZIndex = 2,

									SelfModules.UI.Create("TextBox", {
										Name = "Box",
										AnchorPoint = Vector2.new(0, 0.5),
										BackgroundTransparency = 1,
										ClearTextOnFocus = options.clearonfocus ~= true,
										Position = UDim2.new(0, 28, 0.5, 0),
										Size = UDim2.new(1, -30, 1, 0),
										Font = Enum.Font.SourceSans,
										PlaceholderText = "Text",
										Text = "",
										TextColor3 = Library.Theme.TextColor,
										TextSize = 14,
										TextWrapped = true,
									}),

									SelfModules.UI.Create("TextLabel", {
										Name = "Icon",
										AnchorPoint = Vector2.new(0, 0.5),
										BackgroundTransparency = 1,
										Position = UDim2.new(0, 6, 0.5, 0),
										Size = UDim2.new(0, 14, 0, 14),
										Font = Enum.Font.SourceSansBold,
										Text = "T",
										TextColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(40, 40, 40)),
										TextSize = 18,
										TextWrapped = true,
									}),
								}, UDim.new(0, 5)),
							}, UDim.new(0, 5))
						}, UDim.new(0, 5)),
					}, UDim.new(0, 5))

					-- Functions

					local function extendBox(bool)
						tween(Box.Frame.Holder.TextBox, 0.25, { Size = UDim2.new(0, bool and math.abs(Box.Extend) or bool and 200 or 140, 1, -4) })
					end

					function Box:SetName(text)
						Box.Frame.Holder.Label.Text = text
					end

					function Box:GetName(text)
						return Box.Frame.Holder.Label.Text
					end

					function Box:SetText(text)
						Box.Frame.Holder.TextBox.Text = text
					end

					function Box:GetText()
						return Box.Frame.Holder.TextBox.Text
					end

					function Box:SetExtend(number)
						options.extend = number
					end

					function Box:GetExtend()
						return math.abs(options.extend)
					end

					-- Scripts

					SubSection.List[#SubSection.List + 1] = Box
					Box.Box = Box.Frame.Holder.TextBox.Holder.Box
					Box.Frame.Parent = SubSection.Frame.Holder.List

					Box.Frame.Holder.TextBox.Holder.MouseEnter:Connect(function()
						extendBox(true)
					end)

					Box.Frame.Holder.TextBox.Holder.MouseLeave:Connect(function()
						if Box.Frame.Holder.TextBox.Holder.Box:IsFocused() == false then
							extendBox(false)
						end
					end)

					Box.Frame.Holder.TextBox.Holder.Box.FocusLost:Connect(function()
						if Box.Frame.Holder.TextBox.Holder.Box.Text == "" and options.fireonempty ~= true then
							return
						end

						extendBox(false)
						pcall(task.spawn, Box.Callback, Box.Frame.Holder.TextBox.Holder.Box.Text)
					end)

					return Box
				end

				-- Bind

				function SubSection:AddBind(name, bind, options, callback)
					local Bind = {
						Name = name,
						Type = "Bind",
						Bind = bind,
						Flag = options.flag or name,
						Callback = callback,
						Boolean = nil,
					}

					Bind.Frame = SelfModules.UI.Create("Frame", {
						Name = name,
						BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
						Size = UDim2.new(1, 2, 0, 32),

						SelfModules.UI.Create("Frame", {
							Name = "Holder",
							BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
							Position = UDim2.new(0, 1, 0, 1),
							Size = UDim2.new(1, -2, 1, -2),

							SelfModules.UI.Create("TextLabel", {
								Name = "Label",
								BackgroundTransparency = 1,
								Position = UDim2.new(0, 5, 0.5, -7),
								Size = UDim2.new(1, -135, 0, 14),
								Font = Enum.Font.SourceSans,
								Text = name,
								TextColor3 = Library.Theme.TextColor,
								TextSize = 14,
								TextWrapped = true,
								TextXAlignment = Enum.TextXAlignment.Left,
							}),

							SelfModules.UI.Create("Frame", {
								Name = "Bind",
								AnchorPoint = Vector2.new(1, 0),
								BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
								Position = UDim2.new(1, -2, 0, 2),
								Size = UDim2.new(0, 78, 0, 26),
								ZIndex = 2,

								SelfModules.UI.Create("TextLabel", {
									Name = "Label",
									BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
									Position = UDim2.new(0, 1, 0, 1),
									Size = UDim2.new(1, -2, 1, -2),
									Font = Enum.Font.SourceSans,
									Text = "",
									TextColor3 = Library.Theme.TextColor,
									TextSize = 14,
								}, UDim.new(0, 5)),
							}, UDim.new(0, 5)),
						}, UDim.new(0, 5)),
					}, UDim.new(0, 5))

					-- Variables

					local indicatorEntered = false
					local connections = {}

					-- Functions

					local function listenForInput()
						if connections.listen then
							connections.listen:Disconnect()
						end

						Bind.Frame.Holder.Bind.Label.Text = "..."
						ListenForInput = true

						connections.listen = UIS.InputBegan:Connect(function(input, gameProcessed)
							if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
								Bind:Set(input.KeyCode)
							end
						end)
					end

					local function cancelListen()
						if connections.listen then
							connections.listen:Disconnect(); connections.listen = nil
						end

						Bind.Frame.Holder.Bind.Label.Text = Bind.Bind.Name
						task.spawn(function() RS.RenderStepped:Wait(); ListenForInput = false end)
					end

					function Bind:Set(bind)
						Bind.Bind = bind
						Bind.Frame.Holder.Bind.Label.Text = bind.Name
						Bind.Frame.Holder.Bind.Size = UDim2.new(0, math.max(12 + math.round(TXS:GetTextSize(bind.Name, 14, Enum.Font.SourceSans, Vector2.new(9e9)).X + 0.5), 42), 0, 26)

						if connections.listen then
							cancelListen()
						end
						if options.toggleable == true then
							Bind.Frame.Holder.Indicator.Position = UDim2.new(1, -(Bind.Frame.Holder.Bind.Size.X.Offset+5), 0, 2)
						end
					end

					function Bind:Get()
						return Bind.Boolean
					end

					function Bind:SetName(text)
						Bind.Frame.Holder.Label.Text = text
					end

					function Bind:GetName()
						return Bind.Frame.Holder.Label.Text
					end

					if options.toggleable == true then
						function Bind:Toggle(bool, instant)
							Tab.Flags[Bind.Flag] = bool

							tween(Bind.Frame.Holder.Indicator.Overlay.Glow, instant and 0 or 0.25, { ImageColor3 = bool and Library.Theme.Accent or SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)), SliceScale = bool and 0.2 or 1, ImageTransparency = bool and 0.85 or 0.5 })
							tween(Bind.Frame.Holder.Indicator.Overlay, instant and 0 or 0.25, { ImageTransparency = bool and 0 or 1, Position = bool and UDim2.new(1, -24, 0, 2) or UDim2.new(0, 2, 0, 2) })
							tween(Bind.Frame.Holder.Indicator.Overlay.UICorner, instant and 0 or 0.25, { CornerRadius = UDim.new(bool and 0 or 1, bool and 5 or 0) })
							tween(Bind.Frame.Holder.Indicator.Overlay, "Cosmetic", instant and 0 or 0.25, { BackgroundColor3 = bool and SelfModules.UI.Color.Add(Library.Theme.Accent, Color3.fromRGB(5, 5, 5)) or SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)) })

							Bind.Boolean = bool

							if options.fireontoggle ~= false then
								pcall(task.spawn, Bind.Callback, Bind.Bind)
							end
						end
					end

					-- Scripts

					SubSection.List[#SubSection.List + 1] = Bind
					Bind.Frame.Parent = SubSection.Frame.Holder.List

					Bind.Frame.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							if indicatorEntered == true then
								Bind:Toggle(not Tab.Flags[Bind.Flag], false)
							else
								listenForInput()
							end
						end
					end)

					UIS.InputBegan:Connect(function(input)
						if input.KeyCode == Bind.Bind then
							if options.toggleable == true and Tab.Flags[Bind.Flag] == false then
								return
							end

							pcall(task.spawn, Bind.Callback, Bind.Bind)
						end
					end)

					if options.toggleable == true then
						local indicator = SelfModules.UI.Create("Frame", {
							Name = "Indicator",
							AnchorPoint = Vector2.new(1, 0),
							BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
							Position = UDim2.new(1, -(Bind.Frame.Holder.Bind.Size.X.Offset+5), 0, 2),
							Size = UDim2.new(0, 40, 0, 26),

							SelfModules.UI.Create("Frame", {
								Name = "Filler",
								BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
								Position = UDim2.new(0.5, 0, 0, 0),
								Size = UDim2.new(0.5, 0, 1, 0)
							}, UDim.new(0, 5)),

							SelfModules.UI.Create("ImageLabel", {
								Name = "Overlay",
								ImageColor3 = Library.Theme.TextColor,
								BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
								Position = UDim2.new(0, 2, 0, 2),
								Size = UDim2.new(0, 22, 0, 22),
								Image = "http://www.roblox.com/asset/?id=7827504335",

								SelfModules.UI.Create("ImageLabel", {
									Name = "Glow",
									BackgroundTransparency = 1,
									Position = UDim2.new(0, -13, 0, -13),
									Size = UDim2.new(1, 26, 1, 26),
									Image = "rbxassetid://10822615828",
									ImageColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)),
									ScaleType = Enum.ScaleType.Slice,
									SliceCenter = Rect.new(99, 99, 99, 99),
									ImageTransparency = 0.5,
									SliceScale = 0.2,
								}),
							}, UDim.new(1, 0)),
						}, UDim.new(1, 0))

						-- Scripts

						Tab.Flags[Bind.Flag] = options.default == true
						indicator.Parent = Bind.Frame.Holder

						Bind.Frame.Holder.Indicator.MouseEnter:Connect(function()
							indicatorEntered = true
						end)

						Bind.Frame.Holder.Indicator.MouseLeave:Connect(function()
							indicatorEntered = false
						end)

						Bind:Toggle(options.default == true, true)
						Bind.Boolean = options.default == true or false
					end

					Bind:Set(Bind.Bind)

					return Bind
				end

				-- Slider

				function SubSection:AddSlider(name, min, max, default, options, callback)
					local Slider = {
						Name = name,
						Type = "Slider",
						Value = default,
						Min = min,
						Max = max,
						Flag = options.flag or name,
						Cap = options.cap or false,
						Callback = callback,
					}

					Slider.Frame = SelfModules.UI.Create("Frame", {
						Name = name,
						BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
						Size = UDim2.new(1, 2, 0, 41),

						SelfModules.UI.Create("Frame", {
							Name = "Holder",
							BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
							Position = UDim2.new(0, 1, 0, 1),
							Size = UDim2.new(1, -2, 1, -2),

							SelfModules.UI.Create("TextLabel", {
								Name = "Label",
								BackgroundTransparency = 1,
								Position = UDim2.new(0, 5, 0, 5),
								Size = UDim2.new(1, -75, 0, 14),
								Font = Enum.Font.SourceSans,
								Text = name,
								TextColor3 = Library.Theme.TextColor,
								TextSize = 14,
								TextWrapped = true,
								TextXAlignment = Enum.TextXAlignment.Left,
							}),

							SelfModules.UI.Create("Frame", {
								Name = "Slider",
								BackgroundTransparency = 1,
								Position = UDim2.new(0, 5, 1, -15),
								Size = UDim2.new(1, -10, 0, 10),

								SelfModules.UI.Create("Frame", {
									Name = "Bar",
									BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
									ClipsDescendants = false,
									Size = UDim2.new(1, 0, 1, 0),

									SelfModules.UI.Create("Frame", {
										Name = "Fill",
										BackgroundColor3 = SelfModules.UI.Color.Sub(Library.Theme.Accent, Color3.fromRGB(10, 10, 10)),
										Size = UDim2.new(0.5, 0, 1, 0),

										SelfModules.UI.Create("ImageLabel", {
											Name = "Glow",
											BackgroundTransparency = 1,
											Position = UDim2.new(0, -12, 0, -12),
											Size = UDim2.new(1, 30, 1, 24),
											Image = "rbxassetid://10822615828",
											ImageColor3 = SelfModules.UI.Color.Sub(Library.Theme.Accent, Color3.fromRGB(10, 10, 10)),
											ScaleType = Enum.ScaleType.Slice,
											SliceCenter = Rect.new(99, 99, 99, 99),
											ImageTransparency = 0.9,
											SliceScale = 1,
										}),
									}, UDim.new(0, 5)),
								}, UDim.new(0, 5)),

								SelfModules.UI.Create("Frame", {
									Name = "Point",
									AnchorPoint = Vector2.new(0.5, 0.5),
									BackgroundColor3 = Library.Theme.Accent,
									Position = UDim2.new(0.5, 0, 0.5, 0),
									Size = UDim2.new(0, 12, 0, 12),
								}, UDim.new(0, 5)),
							}),

							SelfModules.UI.Create("TextBox", {
								Name = "Input",
								AnchorPoint = Vector2.new(1, 0),
								BackgroundTransparency = 1,
								PlaceholderText = "...",
								Position = UDim2.new(1, -5, 0, 5),
								Size = UDim2.new(0, 60, 0, 14),
								Font = Enum.Font.SourceSans,
								Text = "",
								TextColor3 = Library.Theme.TextColor,
								TextSize = 14,
								TextWrapped = true,
								TextXAlignment = Enum.TextXAlignment.Right,
							}),
						}, UDim.new(0, 5)),
					}, UDim.new(0, 5))

					-- Variables

					local connections = {}

					-- Functions

					local function getSliderValue(val)
						if options.cap == true then
							val = math.clamp(val, Slider.Min, Slider.Max)
						else
							val = math.clamp(val, -math.huge, math.huge)
						end

						if options.rounded == true then
							val = math.floor(val)
						end

						return val
					end

					local function sliderVisual(val)
						val = getSliderValue(val)

						Slider.Frame.Holder.Input.Text = val

						local valuePercent = 1 - ((Slider.Max - val) / (Slider.Max - Slider.Min))
						local pointPadding = 1 / Slider.Frame.Holder.Slider.AbsoluteSize.X * 5
						tween(Slider.Frame.Holder.Slider.Bar.Fill, 0.25, { Size = UDim2.new(valuePercent, 0, 1, 0) })
						tween(Slider.Frame.Holder.Slider.Point, 0.25, { Position = UDim2.fromScale(math.clamp(valuePercent, pointPadding, 1 - pointPadding), 0.5) })
					end

					function Slider:Set(val)
						val = getSliderValue(val)
						Slider.Value = val
						sliderVisual(val)

						if options.toggleable == true and Tab.Flags[Slider.Flag] == false then
							return
						end

						pcall(task.spawn, Slider.Callback, val, Tab.Flags[Slider.Flag] or nil)
					end

					function Slider:Change(min, max)
						Slider.Min = min
						Slider.Max = max
						Slider:Set(getSliderValue(Slider.Value))
					end

					function Slider:SetName(text)
						Slider.Frame.Holder.Label.Text = text
					end

					function Slider:GetName(text)
						return Slider.Frame.Holder.Label.Text
					end

					if options.toggleable == true then
						function Slider:Toggle(bool, instant)
							Tab.Flags[Slider.Flag] = bool

							tween(Slider.Frame.Holder.Indicator.Overlay.Glow, instant and 0 or 0.25, { ImageColor3 = bool and Library.Theme.Accent or SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)), SliceScale = bool and 0.2 or 1, ImageTransparency = bool and 0.85 or 0.5 })
							tween(Slider.Frame.Holder.Indicator.Overlay, instant and 0 or 0.25, { ImageTransparency = bool and 0 or 1, Position = bool and UDim2.new(1, -24, 0, 2) or UDim2.new(0, 2, 0, 2) })
							tween(Slider.Frame.Holder.Indicator.Overlay.UICorner, instant and 0 or 0.25, { CornerRadius = UDim.new(bool and 0 or 1, bool and 5 or 0) })
							tween(Slider.Frame.Holder.Indicator.Overlay, "Cosmetic", instant and 0 or 0.25, { BackgroundColor3 = bool and SelfModules.UI.Color.Add(Library.Theme.Accent, Color3.fromRGB(5, 5, 5)) or SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)) })

							if options.fireontoggle ~= false then
								pcall(task.spawn, Slider.Callback, Slider.Value, bool)
							end
						end
					end

					-- Scripts

					SubSection.List[#SubSection.List + 1] = Slider
					Slider.Frame.Parent = SubSection.Frame.Holder.List

					Slider.Frame.Holder.Slider.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then

							connections.move = Mouse.Move:Connect(function()
								local sliderPercent = math.clamp((Mouse.X - Slider.Frame.Holder.Slider.AbsolutePosition.X) / Slider.Frame.Holder.Slider.AbsoluteSize.X, 0, 1)
								local sliderValue = math.floor((Slider.Min + sliderPercent * (Slider.Max - Slider.Min)) * 10) / 10

								if options.fireondrag ~= false then
									Slider:Set(sliderValue)
								else
									sliderVisual(sliderValue)
								end
							end)

						end
					end)

					Slider.Frame.Holder.Slider.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							connections.move:Disconnect()
							connections.move = nil

							if options.fireondrag ~= true then
								local sliderPercent = math.clamp((Mouse.X - Slider.Frame.Holder.Slider.AbsolutePosition.X) / Slider.Frame.Holder.Slider.AbsoluteSize.X, 0, 1)
								local sliderValue = math.floor((Slider.Min + sliderPercent * (Slider.Max - Slider.Min)) * 10) / 10

								Slider:Set(sliderValue)
							end
						end
					end)

					Slider.Frame.Holder.Input.FocusLost:Connect(function()
						Slider.Frame.Holder.Input.Text = string.sub(Slider.Frame.Holder.Input.Text, 1, 10)

						if tonumber(Slider.Frame.Holder.Input.Text) then
							Slider:Set(Slider.Frame.Holder.Input.Text)
						end
					end)

					if options.toggleable == true then
						local indicator = SelfModules.UI.Create("Frame", {
							Name = "Indicator",
							AnchorPoint = Vector2.new(1, 1),
							BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
							Position = UDim2.new(1, -2, 1, -2),
							Size = UDim2.new(0, 40, 0, 26),

							SelfModules.UI.Create("Frame", {
								Name = "Filler",
								BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
								Position = UDim2.new(0.5, 0, 0, 0),
								Size = UDim2.new(0.5, 0, 1, 0)
							}, UDim.new(0, 5)),

							SelfModules.UI.Create("ImageLabel", {
								Name = "Overlay",
								ImageColor3 = Library.Theme.TextColor,
								BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)),
								Position = UDim2.new(0, 2, 0, 2),
								Size = UDim2.new(0, 22, 0, 22),
								Image = "http://www.roblox.com/asset/?id=7827504335",

								SelfModules.UI.Create("ImageLabel", {
									Name = "Glow",
									BackgroundTransparency = 1,
									Position = UDim2.new(0, -13, 0, -13),
									Size = UDim2.new(1, 26, 1, 26),
									Image = "rbxassetid://10822615828",
									ImageColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)),
									ScaleType = Enum.ScaleType.Slice,
									SliceCenter = Rect.new(99, 99, 99, 99),
									ImageTransparency = 0.5,
									SliceScale = 0.2,
								}),
							}, UDim.new(1, 0)),
						}, UDim.new(1, 0))

						-- Scripts

						Tab.Flags[Slider.Flag] = options.default == true
						Slider.Frame.Size = UDim2.new(1, 2, 0, 54)
						Slider.Frame.Holder.Slider.Size = UDim2.new(1, -50, 0, 10)
						indicator.Parent = Slider.Frame.Holder

						Slider.Frame.Holder.Indicator.InputBegan:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 then
								Slider:Toggle(not Tab.Flags[Slider.Flag], false)
							end
						end)

						Slider:Toggle(options.default == true, true)
					end

					Slider:Set(Slider.Value)

					return Slider
				end

				-- Dropdown

				function SubSection:AddDropdown(name, list, options, callback)
					local Dropdown = {
						Name = name,
						Type = "Dropdown",
						Toggled = false,
						Selected = options ~= nil and options.multi == true and {} or "",
						List = {},
						Callback = callback,
					}

					local ListObjects = {}

					Dropdown.Frame = SelfModules.UI.Create("Frame", {
						Name = "Dropdown",
						BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
						Size = UDim2.new(1, 2, 0, 42),

						SelfModules.UI.Create("Frame", {
							Name = "Holder",
							BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
							Position = UDim2.new(0, 1, 0, 1),
							Size = UDim2.new(1, -2, 1, -2),

							SelfModules.UI.Create("Frame", {
								Name = "Holder",
								BackgroundTransparency = 1,
								Size = UDim2.new(1, 0, 0, 40),

								SelfModules.UI.Create("Frame", {
									Name = "Displays",
									BackgroundTransparency = 1,
									Position = UDim2.new(0, 5, 0, 8),
									Size = UDim2.new(1, -35, 0, 14),

									SelfModules.UI.Create("TextBox", {
										Name = "SearchBox",
										ClearTextOnFocus = false,
										TextTransparency = 1,
										BackgroundTransparency = 1,
										PlaceholderText = "Search",
										PlaceholderColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
										Font = Enum.Font.SourceSansBold,
										Text = "",
										TextSize = 14,
										TextWrapped = false,
										TextTruncate = Enum.TextTruncate.SplitWord,
										TextColor3 = Library.Theme.TextColor,
										TextXAlignment = Enum.TextXAlignment.Left,
										Size = UDim2.new(0, 0, 1, 0),
									}),

									SelfModules.UI.Create("TextLabel", {
										Name = "Label",
										BackgroundTransparency = 1,
										Size = UDim2.new(0.5, 0, 1, 0),
										Font = Enum.Font.SourceSans,
										Text = name,
										TextColor3 = Library.Theme.TextColor,
										TextSize = 14,
										TextWrapped = true,
										TextXAlignment = Enum.TextXAlignment.Left,
									}),

									SelfModules.UI.Create("TextLabel", {
										Name = "Selected",
										BackgroundTransparency = 1,
										Position = UDim2.new(0.5, 0, 0, 0),
										Size = UDim2.new(0.5, 0, 1, 0),
										Font = Enum.Font.SourceSans,
										Text = "",
										TextColor3 = Library.Theme.TextColor,
										TextSize = 14,
										TextWrapped = true,
										TextXAlignment = Enum.TextXAlignment.Right,
									}),
								}),

								SelfModules.UI.Create("ImageLabel", {
									Name = "Indicator",
									AnchorPoint = Vector2.new(1, 0),
									BackgroundTransparency = 1,
									Position = UDim2.new(1, -5, 0, 5),
									Size = UDim2.new(0, 20, 0, 20),
									Image = "rbxassetid://9243354333",
								}),

								SelfModules.UI.Create("Frame", {
									Name = "Line",
									BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
									BorderSizePixel = 0,
									Position = UDim2.new(0, 5, 0, 30),
									Size = UDim2.new(1, -10, 0, 2),
								}),
							}, UDim.new(0, 5)),

							SelfModules.UI.Create("ScrollingFrame", {
								Name = "List",
								Active = true,
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
								Position = UDim2.new(0, 5, 0, 40),
								Size = UDim2.new(1, -10, 1, -40),
								CanvasSize = UDim2.new(0, 0, 0, 0),
								ScrollBarImageColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
								ScrollBarThickness = 5,

								SelfModules.UI.Create("UIListLayout", {
									SortOrder = Enum.SortOrder.LayoutOrder,
									Padding = UDim.new(0, 5),
								}),
							}),
						}, UDim.new(0,5)),
					}, UDim.new(0, 5))

					-- Functions

					function Dropdown:GetHeight()
						return 42 + (Dropdown.Toggled == true and math.min(#Dropdown.List, 5) * 27 or 0)
					end

					function Dropdown:UpdateHeight()
						Dropdown.Frame.Holder.List.CanvasSize = UDim2.new(0, 0, 0, #Dropdown.List * 27 - 5)

						if Dropdown.Toggled == true then
							Dropdown.Frame.Size = UDim2.new(1, 2, 0, Dropdown:GetHeight())
							SubSection:UpdateHeight()
						end
					end

					function Dropdown:Add(name, options, callback)
						local Item = {
							Name = name,
							Callback = callback,
						}

						Item.Frame = SelfModules.UI.Create("Frame", {
							Name = name,
							BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
							Size = UDim2.new(1, -10, 0, 22),

							SelfModules.UI.Create("TextButton", {
								Name = "Button",
								BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
								Position = UDim2.new(0, 1, 0, 1),
								Size = UDim2.new(1, -2, 1, -2),
								Font = Enum.Font.SourceSans,
								Text = name,
								TextColor3 = Library.Theme.TextColor,
								TextSize = 14,
								TextWrapped = true,
							}, UDim.new(0, 5)),
						}, UDim.new(0, 5))

						function Dropdown:SetName(text)
							Dropdown.Frame.Holder.Holder.Displays.Label = text
						end

						function Dropdown:GetName()
							return Dropdown.Frame.Holder.Holder.Displays.Label
						end

						-- Scripts

						Dropdown.List[#Dropdown.List + 1] = name
						ListObjects[#ListObjects + 1] = Item
						Item.Frame.Parent = Dropdown.Frame.Holder.List

						if Dropdown.Toggled == true then
							Dropdown:UpdateHeight()
						end

						Item.Frame.Button.Activated:Connect(function()
							if typeof(Item.Callback) == "function" then
								pcall(task.spawn, Item.Callback)
							else
								Dropdown:Select(Item.Name)
							end
						end)

						Dropdown.Frame.Holder.Holder.Displays.SearchBox.Size = UDim2.new(0, Dropdown.Frame.Holder.Holder.Displays.Label.TextBounds.X, 1, 0)

						Dropdown.Frame.Holder.Holder.Displays.SearchBox.Focused:Connect(function()
							Dropdown:Toggle(true)
							tween(Dropdown.Frame.Holder.Holder.Displays.SearchBox, 2, { Size = UDim2.new(1, -(Dropdown.Frame.Holder.Holder.Displays.Selected.TextBounds.X-1), 1, 0), TextTransparency = 0 })
							tween(Dropdown.Frame.Holder.Holder.Displays.Label, 0.5, { TextTransparency = 1 })
						end)

						Dropdown.Frame.Holder.Holder.Displays.SearchBox.FocusLost:Connect(function()
							tween(Dropdown.Frame.Holder.Holder.Displays.SearchBox, 0.5, { Size = UDim2.new(0, Dropdown.Frame.Holder.Holder.Displays.Label.TextBounds.X, 1, 0) })
							tween(Dropdown.Frame.Holder.Holder.Displays.Label, 0.5, { TextTransparency = 0 })
							Dropdown.Frame.Holder.Holder.Displays.SearchBox.Text = ""
						end)

						Dropdown.Frame.Holder.Holder.Displays.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
							local searchText = Dropdown.Frame.Holder.Holder.Displays.SearchBox.Text:lower()
							local list = Dropdown.Frame.Holder.List:GetChildren()

							for _, item in pairs(list) do
								if item:IsA("Frame") then
									if item.Name:lower():find(searchText) then
										item.Visible = true
									else
										item.Visible = false
									end
								end
							end
						end)

						return Item
					end

					function Dropdown:Remove(name, ignoreToggle)
						for i, v in next, Dropdown.List do
							if v == name then
								local item = ListObjects[i]

								if item then
									item.Frame:Destroy()
									table.remove(Dropdown.List, i)
									table.remove(ListObjects, i)

									if Dropdown.Toggled then
										Dropdown:UpdateHeight()
									end

									if #Dropdown.List == 0 and not ignoreToggle then
										Dropdown:Toggle(false)
									end
								end

								break
							end
						end
					end

					function Dropdown:ClearList()
						for _ = 1, #Dropdown.List, 1 do
							Dropdown:Remove(Dropdown.List[1], true)
						end
					end

					function Dropdown:SetList(list)
						Dropdown:ClearList()

						for _, v in next, list do
							Dropdown:Add(v)
						end
					end

					function Dropdown:Select(itemName)
						if options.multi == true then
							if table.find(Dropdown.Selected, itemName) then
								for i, v in ipairs(Dropdown.Selected) do
									if v == itemName then
										table.remove(Dropdown.Selected, i)
										break
									end
								end
							else
								table.insert(Dropdown.Selected, itemName)
							end
							Dropdown.Frame.Holder.Holder.Displays.Selected.Text = table.concat(Dropdown.Selected, ", ")
							pcall(task.spawn, Dropdown.Callback, Dropdown.Selected)
						else
							Dropdown.Selected = itemName
							Dropdown.Frame.Holder.Holder.Displays.Selected.Text = itemName
							Dropdown:Toggle(false)
							pcall(task.spawn, Dropdown.Callback, itemName)
						end
					end

					function Dropdown:Toggle(bool)
						Dropdown.Toggled = bool

						tween(Dropdown.Frame, 0.5, { Size = UDim2.new(1, 2, 0, Dropdown:GetHeight()) })
						tween(Dropdown.Frame.Holder.Holder.Indicator, 0.5, { Rotation = bool and 90 or 0 })
						tween(SubSection.Frame, 0.5, { Size = UDim2.new(1, 2, 0, SubSection:GetHeight()) })
						tween(Section.Frame, 0.5, { Size = UDim2.new(1, -10, 0, Section:GetHeight()) })
						tween(Tab.Frame, 0.5, { CanvasSize = UDim2.new(0, 0, 0, Tab:GetHeight()) })
					end

					-- Scripts

					SubSection.List[#SubSection.List + 1] = Dropdown
					Dropdown.Frame.Parent = SubSection.Frame.Holder.List

					Dropdown.Frame.Holder.List.ChildAdded:Connect(function(c)
						if c.ClassName == "Frame" then
							Dropdown:UpdateHeight()
						end
					end)

					Dropdown.Frame.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 and #Dropdown.List > 0 and Mouse.Y - Dropdown.Frame.AbsolutePosition.Y <= 30 then
							Dropdown:Toggle(not Dropdown.Toggled)
						end
					end)

					for i, v in next, list do
						Dropdown:Add(v)
					end

					if typeof(options.default) == "string" then
						Dropdown:Select(options.default)
					end

					return Dropdown
				end

				-- Picker

				function SubSection:AddPicker(name, options, callback)
					local Picker = {
						Name = name,
						Type = "Picker",
						Toggled = false,
						Rainbow = false,
						RainbowSpeed = 1,
						Callback = callback,
					}

					local h, s, v = (options.color or Library.Theme.Accent):ToHSV()
					Picker.Color = { R = h, G = s, B = v }

					Picker.Frame = SelfModules.UI.Create("Frame", {
						Name = "ColorPicker",
						BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
						ClipsDescendants = true,
						Size = UDim2.new(1, 2, 0, 42),

						SelfModules.UI.Create("Frame", {
							Name = "Holder",
							BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
							ClipsDescendants = true,
							Position = UDim2.new(0, 1, 0, 1),
							Size = UDim2.new(1, -2, 1, -2),

							SelfModules.UI.Create("Frame", {
								Name = "Top",
								BackgroundTransparency = 1,
								Size = UDim2.new(1, 0, 0, 40),

								SelfModules.UI.Create("TextLabel", {
									Name = "Label",
									BackgroundTransparency = 1,
									Position = UDim2.new(0, 5, 0, 8),
									Size = UDim2.new(0.5, -15, 0, 14),
									Font = Enum.Font.SourceSans,
									Text = name,
									TextColor3 = Library.Theme.TextColor,
									TextSize = 14,
									TextWrapped = true,
									TextXAlignment = Enum.TextXAlignment.Left,
								}),

								SelfModules.UI.Create("Frame", {
									Name = "Selected",
									AnchorPoint = Vector2.new(1, 0),
									BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
									Position = UDim2.new(1, -29, 0, 2),
									Size = UDim2.new(0, 100, 0, 26),

									SelfModules.UI.Create("Frame", {
										Name = "Preview",
										BackgroundColor3 = Color3.fromHSV(Picker.Color.R, Picker.Color.G, Picker.Color.B),
										Position = UDim2.new(0, 1, 0, 1),
										Size = UDim2.new(1, -2, 1, -2),

										SelfModules.UI.Create("ImageLabel", {
											Name = "Glow",
											BackgroundTransparency = 1,
											Position = UDim2.new(0, -12, 0, -12),
											Size = UDim2.new(1, 24, 1, 24),
											Image = "rbxassetid://10822615828",
											ImageColor3 = Color3.fromHSV(Picker.Color.R, Picker.Color.G, Picker.Color.B),
											ScaleType = Enum.ScaleType.Slice,
											SliceCenter = Rect.new(99, 99, 99, 99),
											ImageTransparency = 0.75,
											SliceScale = 0.2,
										}),
									}, UDim.new(0, 5)),

									SelfModules.UI.Create("TextLabel", {
										Name = "Display",
										AnchorPoint = Vector2.new(0, 0.5),
										BackgroundTransparency = 1,
										Position = UDim2.new(0, 0, 0.5, 0),
										Size = UDim2.new(1, 0, 0, 16),
										Font = Enum.Font.SourceSans,
										Text = "",
										TextColor3 = Library.Theme.TextColor,
										TextSize = 16,
										TextStrokeColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
										TextStrokeTransparency = 0.5,
									}),
								}, UDim.new(0, 5)),

								SelfModules.UI.Create("ImageLabel", {
									Name = "Indicator",
									AnchorPoint = Vector2.new(1, 0),
									BackgroundTransparency = 1,
									Position = UDim2.new(1, -5, 0, 5),
									Size = UDim2.new(0, 20, 0, 20),
									Image = "rbxassetid://9243354333",
								}),

								SelfModules.UI.Create("Frame", {
									Name = "Line",
									BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
									BorderSizePixel = 0,
									Position = UDim2.new(0, 5, 0, 30),
									Size = UDim2.new(1, -10, 0, 2),
								}),
							}),

							SelfModules.UI.Create("Frame", {
								Name = "Holder",
								Active = true,
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
								Position = UDim2.new(0, 0, 0, 40),
								Size = UDim2.new(1, 0, 1, -40),

								SelfModules.UI.Create("Frame", {
									Name = "Palette",
									BackgroundTransparency = 1,
									BorderSizePixel = 0,
									Position = UDim2.new(0, 5, 0, 5),
									Size = UDim2.new(1, -196, 0, 110),

									SelfModules.UI.Create("Frame", {
										Name = "Point",
										AnchorPoint = Vector2.new(0.5, 0.5),
										BackgroundColor3 = SelfModules.UI.Color.Sub(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
										Position = UDim2.new(1, 0, 0, 0),
										Size = UDim2.new(0, 7, 0, 7),
										ZIndex = 2,

										SelfModules.UI.Create("Frame", {
											Name = "Inner",
											BackgroundColor3 = Color3.fromRGB(255, 255, 255),
											Position = UDim2.new(0, 1, 0, 1),
											Size = UDim2.new(1, -2, 1, -2),
											ZIndex = 2,
										}, UDim.new(1, 0)),
									}, UDim.new(1, 0)),

									SelfModules.UI.Create("Frame", {
										Name = "Hue",
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										BorderSizePixel = 0,
										Size = UDim2.new(1, 0, 1, 0),

										SelfModules.UI.Create("UIGradient", {
											Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromHSV(Picker.Color.R, Picker.Color.G, Picker.Color.B))},
										}),
										SelfModules.UI.Create("ImageLabel", {
											Name = "Glow",
											BackgroundTransparency = 1,
											ScaleType = Enum.ScaleType.Slice,
											SliceCenter = Rect.new(99, 99, 99, 99),
											SliceScale = 0.2,
											Size = UDim2.new(1, 24, 1, 24),
											Position = UDim2.new(0, -12, 0, -12),
											Image = "rbxassetid://10822615828",
											ImageTransparency = 0.75,

											SelfModules.UI.Create("UIGradient", {
												Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromHSV(Picker.Color.R, Picker.Color.G, Picker.Color.B))},
												Rotation = -45,
												Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(0.90, 1.00), NumberSequenceKeypoint.new(1.00, 0.00)}
											}),
										}),
									}, UDim.new(0, 5)),

									SelfModules.UI.Create("Frame", {
										Name = "SatVal",
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										BorderSizePixel = 0,
										Size = UDim2.new(1, 0, 1, 0),
										ZIndex = 2,

										SelfModules.UI.Create("UIGradient", {
											Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0))},
											Rotation = 90,
											Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(1.00, 0.00)},
										}),
									}, UDim.new(0, 5)),
								}),

								SelfModules.UI.Create("Frame", {
									Name = "HueSlider",
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BorderSizePixel = 0,
									Position = UDim2.new(0, 5, 0, 125),
									Size = UDim2.new(1, -10, 0, 20),

									SelfModules.UI.Create("ImageLabel", {
										Name = "Glow",
										BackgroundTransparency = 1,
										Position = UDim2.new(0, -12, 0, -12),
										Size = UDim2.new(1, 24, 1, 24),
										Image = "rbxassetid://10822615828",
										ImageColor3 = Color3.fromRGB(255, 255, 255),
										ScaleType = Enum.ScaleType.Slice,
										SliceCenter = Rect.new(99, 99, 99, 99),
										ImageTransparency = 0.75,
										SliceScale = 0.2,

										SelfModules.UI.Create("UIGradient", {
											Color = ColorSequence.new{
												ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
												ColorSequenceKeypoint.new(0.16666, Color3.fromRGB(255, 255, 0)),
												ColorSequenceKeypoint.new(0.33333, Color3.fromRGB(0, 255, 0)),
												ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
												ColorSequenceKeypoint.new(0.66667, Color3.fromRGB(0, 0, 255)),
												ColorSequenceKeypoint.new(0.83333, Color3.fromRGB(255, 0, 255)),
												ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
											},
										}),
									}),

									SelfModules.UI.Create("UIGradient", {
										Color = ColorSequence.new{
											ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
											ColorSequenceKeypoint.new(0.16666, Color3.fromRGB(255, 255, 0)),
											ColorSequenceKeypoint.new(0.33333, Color3.fromRGB(0, 255, 0)),
											ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
											ColorSequenceKeypoint.new(0.66667, Color3.fromRGB(0, 0, 255)),
											ColorSequenceKeypoint.new(0.83333, Color3.fromRGB(255, 0, 255)),
											ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
										},
									}),

									SelfModules.UI.Create("Frame", {
										Name = "Bar",
										AnchorPoint = Vector2.new(0.5, 0.5),
										BackgroundColor3 = SelfModules.UI.Color.Sub(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
										Position = UDim2.new(0.5, 0, 0, 0),
										Size = UDim2.new(0, 6, 1, 6),

										SelfModules.UI.Create("Frame", {
											Name = "Inner",
											BackgroundColor3 = Color3.fromRGB(255, 255, 255),
											Position = UDim2.new(0, 1, 0, 1),
											Size = UDim2.new(1, -2, 1, -2),
										}, UDim.new(0, 5)),
									}, UDim.new(0, 5)),
								}, UDim.new(0, 5)),

								SelfModules.UI.Create("Frame", {
									Name = "RGB",
									BackgroundTransparency = 1,
									Position = UDim2.new(1, -180, 0, 5),
									Size = UDim2.new(0, 75, 0, 110),

									SelfModules.UI.Create("Frame", {
										Name = "Red",
										BackgroundTransparency = 1,
										Size = UDim2.new(1, 0, 0, 30),

										SelfModules.UI.Create("TextBox", {
											Name = "Box",
											BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
											Size = UDim2.new(1, 0, 1, 0),
											Font = Enum.Font.SourceSans,
											PlaceholderText = "R",
											Text = 255,
											TextColor3 = Library.Theme.TextColor,
											TextSize = 16,
											TextWrapped = true,
										}, UDim.new(0, 5)),
									}, UDim.new(0, 5)),

									SelfModules.UI.Create("Frame", {
										Name = "Green",
										BackgroundTransparency = 1,
										Position = UDim2.new(0, 0, 0, 40),
										Size = UDim2.new(1, 0, 0, 30),

										SelfModules.UI.Create("TextBox", {
											Name = "Box",
											BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
											Size = UDim2.new(1, 0, 1, 0),
											Font = Enum.Font.SourceSans,
											PlaceholderText = "G",
											Text = 0,
											TextColor3 = Library.Theme.TextColor,
											TextSize = 16,
											TextWrapped = true,
										}, UDim.new(0, 5)),
									}, UDim.new(0, 5)),

									SelfModules.UI.Create("Frame", {
										Name = "Blue",
										BackgroundTransparency = 1,
										Position = UDim2.new(0, 0, 0, 80),
										Size = UDim2.new(1, 0, 0, 30),

										SelfModules.UI.Create("TextBox", {
											Name = "Box",
											BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
											Size = UDim2.new(1, 0, 1, 0),
											Font = Enum.Font.SourceSans,
											PlaceholderText = "B",
											Text = 0,
											TextColor3 = Library.Theme.TextColor,
											TextSize = 16,
											TextWrapped = true,
										}, UDim.new(0, 5)),
									}, UDim.new(0, 5)),
								}),

								SelfModules.UI.Create("Frame", {
									Name = "Rainbow",
									AnchorPoint = Vector2.new(1, 0),
									BackgroundTransparency = 1,
									Position = UDim2.new(1, -5, 0, 87),
									Size = UDim2.new(0, 90, 0, 26),

									SelfModules.UI.Create("TextLabel", {
										Name = "Label",
										AnchorPoint = Vector2.new(0, 0.5),
										BackgroundTransparency = 1,
										Position = UDim2.new(0, 47, 0.5, 0),
										Size = UDim2.new(1, -47, 0, 14),
										Font = Enum.Font.SourceSans,
										Text = "Rainbow",
										TextColor3 = Library.Theme.TextColor,
										TextSize = 14,
										TextWrapped = true,
										TextXAlignment = Enum.TextXAlignment.Left,
									}),

									SelfModules.UI.Create("Frame", {
										Name = "Indicator",
										BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
										Size = UDim2.new(0, 40, 0, 26),

										SelfModules.UI.Create("ImageLabel", {
											Name = "Overlay",
											BackgroundColor3 = SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)),
											Position = UDim2.new(0, 2, 0, 2),
											Size = UDim2.new(0, 22, 0, 22),
											Image = "http://www.roblox.com/asset/?id=7827504335",
											ImageTransparency = 1,
										}, UDim.new(0, 5)),
									}, UDim.new(0, 5)),
								})
							}),
						}, UDim.new(0, 5)),
					}, UDim.new(0, 5))

					-- Variables

					local hueDragging, satDragging = false, false

					-- Functions

					function Picker:GetHeight()
						return Picker.Toggled == true and 192 or 42
					end

					function Picker:Toggle(bool)
						Picker.Toggled = bool

						tween(Picker.Frame, 0.5, { Size = UDim2.new(1, 2, 0, Picker:GetHeight()) })
						tween(Picker.Frame.Holder.Top.Indicator, 0.5, { Rotation = bool and 90 or 0 })

						tween(SubSection.Frame, 0.5, { Size = UDim2.new(1, 2, 0, SubSection:GetHeight()) })
						tween(Section.Frame, 0.5, { Size = UDim2.new(1, -10, 0, Section:GetHeight()) })
						tween(Tab.Frame, 0.5, { CanvasSize = UDim2.new(0, 0, 0, Tab:GetHeight()) })
					end

					function Picker:ToggleRainbow(bool)
						Picker.Rainbow = bool

						tween(Picker.Frame.Holder.Holder.Rainbow.Indicator.Overlay, 0.25, {ImageTransparency = bool and 0 or 1, Position = bool and UDim2.new(1, -24, 0, 2) or UDim2.new(0, 2, 0, 2) })
						tween(Picker.Frame.Holder.Holder.Rainbow.Indicator.Overlay, "Cosmetic", 0.25, { BackgroundColor3 = bool and SelfModules.UI.Color.Add(Library.Theme.Accent, Color3.fromRGB(15, 15, 15)) or SelfModules.UI.Color.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)) })

						if bool then
							if not Storage.Connections[Picker] then
								Storage.Connections[Picker] = {}
							end

							Storage.Connections[Picker].Rainbow = RS.Heartbeat:Connect(function()
								Picker:Set(tick() % Picker.RainbowSpeed / Picker.RainbowSpeed, Picker.Color.G, Picker.Color.B)
							end)

						elseif Storage.Connections[Picker] then
							Storage.Connections[Picker].Rainbow:Disconnect()
							Storage.Connections[Picker].Rainbow = nil
						end
					end

					function Picker:Speed(value)
						Picker.RainbowSpeed = tonumber(value)
					end

					function Picker:Set(h, s, v)
						Picker.Color.R, Picker.Color.G, Picker.Color.B = h, s, v

						local color = Color3.fromHSV(h, s, v)
						Picker.Frame.Holder.Holder.Palette.Hue.UIGradient.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromHSV(h, 1, 1))
						Picker.Frame.Holder.Top.Selected.Preview.BackgroundColor3 = color
						Picker.Frame.Holder.Top.Selected.Preview.Glow.ImageColor3 = color
						Picker.Frame.Holder.Top.Selected.Display.Text = string.format("%d, %d, %d", math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
						Picker.Frame.Holder.Top.Selected.Size = UDim2.new(0, math.round(TXS:GetTextSize(Picker.Frame.Holder.Top.Selected.Display.Text, 16, Enum.Font.SourceSans, Vector2.new(9e9)).X + 0.5) + 20, 0, 26)

						Picker.Frame.Holder.Holder.RGB.Red.Box.Text = math.floor(color.R * 255 + 0.5)
						Picker.Frame.Holder.Holder.RGB.Green.Box.Text = math.floor(color.G * 255 + 0.5)
						Picker.Frame.Holder.Holder.RGB.Blue.Box.Text = math.floor(color.B * 255 + 0.5)

						Picker.Frame.Holder.Holder.Palette.Hue.Glow.UIGradient.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromHSV(h, 1, 1))	

						tween(Picker.Frame.Holder.Holder.HueSlider.Bar, 0.1, { Position = UDim2.new(h, 0, 0.5, 0) })
						tween(Picker.Frame.Holder.Holder.Palette.Point, 0.1, { Position = UDim2.new(s, 0, 1 - v, 0) })

						pcall(task.spawn, Picker.Callback, color)
					end

					function Picker:Get()
						return Picker.Color.R, Picker.Color.G, Picker.Color.B
					end

					function Picker:SetName(text)
						Picker.Frame.Holder.Top.Label.Text = text
					end

					function Picker:GetName()
						return Picker.Frame.Holder.Top.Label
					end

					-- Scripts

					SubSection.List[#SubSection.List + 1] = Picker
					Picker.Frame.Parent = SubSection.Frame.Holder.List

					Picker.Frame.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 and Mouse.Y - Picker.Frame.AbsolutePosition.Y <= 30 then
							Picker:Toggle(not Picker.Toggled)
						end
					end)

					Picker.Frame.Holder.Holder.HueSlider.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							hueDragging = true
						end
					end)

					Picker.Frame.Holder.Holder.HueSlider.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							hueDragging = false
						end
					end)

					Picker.Frame.Holder.Holder.Palette.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							satDragging = true
						end
					end)

					Picker.Frame.Holder.Holder.Palette.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							satDragging = false
						end
					end)

					Mouse.Move:Connect(function()
						if hueDragging and not Picker.Rainbow then
							Picker:Set(math.clamp((Mouse.X - Picker.Frame.Holder.Holder.HueSlider.AbsolutePosition.X) / Picker.Frame.Holder.Holder.HueSlider.AbsoluteSize.X, 0, 1), Picker.Color.G, Picker.Color.B)

						elseif satDragging then
							Picker:Set(Picker.Color.R, math.clamp((Mouse.X - Picker.Frame.Holder.Holder.Palette.AbsolutePosition.X) / Picker.Frame.Holder.Holder.Palette.AbsoluteSize.X, 0, 1), 1 - math.clamp((Mouse.Y - Picker.Frame.Holder.Holder.Palette.AbsolutePosition.Y) / Picker.Frame.Holder.Holder.Palette.AbsoluteSize.Y, 0, 1))
						end
					end)

					Picker.Frame.Holder.Holder.RGB.Red.Box.FocusLost:Connect(function()
						local num = tonumber(Picker.Frame.Holder.Holder.RGB.Red.Box.Text)
						local color = Color3.fromHSV(Picker.Color.R, Picker.Color.G, Picker.Color.B)

						if num then
							Picker:Set(Color3.new(math.clamp(math.floor(num), 0, 255) / 255, color.G, color.B):ToHSV())
						else
							Picker.Frame.Holder.Holder.RGB.Red.Box.Text = math.floor(color.R * 255 + 0.5)
						end
					end)

					Picker.Frame.Holder.Holder.RGB.Green.Box.FocusLost:Connect(function()
						local num = tonumber(Picker.Frame.Holder.Holder.RGB.Green.Box.Text)
						local color = Color3.fromHSV(Picker.Color.R, Picker.Color.G, Picker.Color.B)

						if num then
							Picker:Set(Color3.new(color.R, math.clamp(math.floor(num), 0, 255) / 255, color.B):ToHSV() )
						else
							Picker.Frame.Holder.Holder.RGB.Green.Box.Text = math.floor(color.B * 255 + 0.5)
						end
					end)

					Picker.Frame.Holder.Holder.RGB.Blue.Box.FocusLost:Connect(function()
						local num = tonumber(Picker.Frame.Holder.Holder.RGB.Blue.Box.Text)
						local color = Color3.fromHSV(Picker.Color.R, Picker.Color.G, Picker.Color.B)

						if num then
							Picker:Set(Color3.new(color.R, color.G, math.clamp(math.floor(num), 0, 255) / 255):ToHSV())
						else
							Picker.Frame.Holder.Holder.RGB.Blue.Box.Text = math.floor(color.B * 255 + 0.5)
						end
					end)

					Picker.Frame.Holder.Holder.Rainbow.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							Picker:ToggleRainbow(not Picker.Rainbow)
						end
					end)

					Picker:Set(Picker.Color.R, Picker.Color.G, Picker.Color.B)

					return Picker
				end

				-- Scripts

				SubSection.Frame.Holder.List.ChildAdded:Connect(function(c)
					if c.ClassName == "Frame" then
						SubSection:UpdateHeight()
					end
				end)

				SubSection.Frame.Holder.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 and #SubSection.List > 0 and Window.Sidebar.Frame.AbsoluteSize.X <= 35 and Mouse.Y - SubSection.Frame.AbsolutePosition.Y <= 30 then
						toggleSubSection(not SubSection.Toggled)
					end
				end)

				Section.List[#Section.List + 1] = SubSection
				SubSection.Frame.Parent = Section.Frame.List

				return SubSection
			end

			return Section
		end

		return Tab
	end

	loadup()

	return Window
end

function Library:Auth(options)
	assert(options, "No options data assigned to Auth")

	local Auth = {
		Name = options.title[1].. " ".. options.title[2],
		Type = "Auth",
		Key = options.Key,
		Discord = options.Discord,
		Authenticated = false,
	}
	
	Auth.Frame = SelfModules.UI.Create("CanvasGroup", {
		Name = "Auth",
		BackgroundColor3 = Library.Theme.TopbarColor,
		Size = UDim2.new(0, 360, 0, 360),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		GroupTransparency = 1,
		
		SelfModules.UI.Create("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(0, 0, 0),
			Thickness = 2.5,
			Transparency = 0.8,
		}),
		
		SelfModules.UI.Create("Frame", {
			Name = "Background",
			BackgroundColor3 = Color3.fromRGB(15, 15, 15),
			Size = UDim2.new(1, -4, 1, -4),
			Position = UDim2.new(0, 2, 0, 2),
			
			SelfModules.UI.Create("Frame", {
				Name = "Instance",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 18, 0, 232),
				Size = UDim2.new(0, 317, 0, 104),
				
				SelfModules.UI.Create("Frame", {
					Name = "Discord",
					BackgroundColor3 = options.Accent,
					Position = UDim2.new(0, 0, 0.5, 0),
					Size = UDim2.new(1, 0, 0.5, 0),
					
					SelfModules.UI.Create("Frame", {
						Name = "Fill",
						BorderSizePixel = 0,
						BackgroundColor3 = options.Accent,
						Position = UDim2.new(0, 0, 0, 0),
						Size = UDim2.new(1, 0, 0.5, 0),
					}),
					
					SelfModules.UI.Create("TextButton", {
						Name = "Invite",
						Text = "Join Our Discord",
						Font = Enum.Font.SourceSansBold,
						TextColor3 = Color3.fromRGB(0, 0, 0),
						TextSize = 14,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 1, 0),
					}),
					
					SelfModules.UI.Create("TextBox", {
						Name = "InviteHandler",
						Size = UDim2.new(1, 0, 1, 0),
						Position = UDim2.new(0, 0, 0, 0),
						TextColor3 = Color3.fromRGB(0, 0, 0),
						Visible = false,
						TextSize = 14,
						Font = Enum.Font.SourceSansBold,
						BackgroundTransparency = 1,
						Interactable = true,
						ClearTextOnFocus = false,
						TextEditable = false,
						Text = options.Discord,
						PlaceholderText = "Ion lil bro but ur device lowkey suck if u see ts :pray:"
					}),
				}, UDim.new(0, 5)),
				
				SelfModules.UI.Create("Frame", {
					Name = "Key",
					BackgroundColor3 = Library.Theme.SectionColor,
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(1, 0, 0.5, 0),

					SelfModules.UI.Create("Frame", {
						Name = "Fill",
						BorderSizePixel = 0,
						BackgroundColor3 = Library.Theme.SectionColor,
						Position = UDim2.new(0, 0, 0.5, 0),
						Size = UDim2.new(1, 0, 0.5, 0),
					}),

					SelfModules.UI.Create("ImageButton", {
						Name = "Button",
						BackgroundTransparency = 1,
						Image = "rbxassetid://91271099449709",
						Position = UDim2.new(0, 284, 0, 14),
						Size = UDim2.new(0, 23, 0, 23),
					}),
					SelfModules.UI.Create("TextBox", {
						Name = "Box",
						BackgroundTransparency = 1,
						ClearTextOnFocus = false,
						MultiLine = false,
						Position = UDim2.new(0, 16, 0, 10),
						Size = UDim2.new(0, 243, 0, 29),
						Font = Enum.Font.SourceSansBold,
						PlaceholderColor3 = Color3.fromRGB(40, 40, 40),
						PlaceholderText = "Key / Token",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 17,
						TextTruncate = Enum.TextTruncate.AtEnd,
						TextXAlignment = Enum.TextXAlignment.Left,
						Text = "",
					}),
				}, UDim.new(0, 5)),
				
				SelfModules.UI.Create("ImageLabel", {
					Name = "Glow",
					BackgroundTransparency = 1,
					Position = UDim2.new(0, -20, 0.5, -20),
					Size = UDim2.new(1, 40, 0.5, 40),
					Image = "rbxassetid://10822615828",
					ImageColor3 = Color3.fromRGB(255, 255, 255),
					ImageTransparency = 0.55,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(99, 99, 99, 99),
					SliceScale = 0.4,
					ZIndex = -1,
					SelfModules.UI.Create("UIGradient", {
						Name = "Gradient",
						Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(25, 25, 25)), ColorSequenceKeypoint.new(1.00, options.Accent)},
						Rotation = 90,
					}),
				}),
			}),
			SelfModules.UI.Create("TextLabel", {
				Name = "LeftSideText",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, -181, 0, 19),
				Size = UDim2.new(0, 417, 0, 646),
				Rotation = -45,
				Font = Enum.Font.SourceSansBold,
				Text = "SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community",
				TextColor3 = Library.Theme.TopbarColor,
				TextSize = 28,
				TextWrapped = true,
				ZIndex = -1,
			}),
			SelfModules.UI.Create("TextLabel", {
				Name = "RightSideText",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 119, 0, -311),
				Size = UDim2.new(0, 417, 0, 646),
				Rotation = 135,
				Font = Enum.Font.SourceSansBold,
				Text = "SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community SolSel Scripting Community",
				TextColor3 = Library.Theme.TopbarColor,
				TextSize = 28,
				TextWrapped = true,
				ZIndex = -1,
			}),
		}, UDim.new(0, 5)),
		SelfModules.UI.Create("CanvasGroup", {
			Name = "Topbar",
			BackgroundColor3 = Library.Theme.TopbarColor,
			Size = UDim2.new(1, 0, 0, 40),
			ZIndex = 3,
			Visible = true,
			SelfModules.UI.Create("Frame", {
				Name = "Filling",
				BackgroundColor3 = Library.Theme.TopbarColor,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.new(1, 0, 0.5, 0),
				BackgroundTransparency = 1,
			}),

			SelfModules.UI.Create("Frame", {
				Name = "Titles",
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,

				SelfModules.UI.Create("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),

				SelfModules.UI.Create("UIPadding", {
					PaddingLeft = UDim.new(0, 10)
				}),

				SelfModules.UI.Create("TextLabel", {
					Name = "Label1",
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 0, 0, 22),
					Font = Enum.Font.SourceSansBold,
					TextXAlignment = Enum.TextXAlignment.Left,
					Text = options.title[1],
					RichText = true,
					TextColor3 = Library.Theme.TextColor,
					TextSize = 22,
					TextWrapped = true,
					LayoutOrder = 0,
				}),

				SelfModules.UI.Create("Frame", {
					Name = "Label2",
					BorderSizePixel = 0,
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(0, 0, 0, 0),
					BackgroundTransparency = 1,

					SelfModules.UI.Create("TextLabel", {
						Name = "Label",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 0,
						BackgroundColor3 = options.Accent,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						Size = UDim2.new(1, 0, 1, 0),
						Font = Enum.Font.SourceSansSemibold,
						TextXAlignment = Enum.TextXAlignment.Center,
						Text = options.title[2],
						RichText = true,
						TextColor3 = Library.Theme.TextColor,
						TextSize = 20,
						TextWrapped = true,
						LayoutOrder = 1,
						ZIndex = 2,
					}, UDim.new(0, 5)),

					SelfModules.UI.Create("ImageLabel", {
						Name = "Glow",
						BackgroundTransparency = 1,
						Position = UDim2.new(0, -13, 0, -13),
						Size = UDim2.new(1, 26, 1, 26),
						Image = "rbxassetid://10822615828",
						ImageColor3 = options.Accent,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(99, 99, 99, 99),
						ImageTransparency = 0.9,
						SliceScale = 0.2,
					}),
				}),
			}),
		}, UDim.new(0, 5)),
	}, UDim.new(0, 5))
	
	-- Script
	
	local Done = false
	Auth.Frame.Background.Instance.Key.Button.MouseButton1Click:Connect(function()
		if Auth.Frame.Background.Instance.Key.Box.Text == options.Key then
			if Done == false then
				Done = true
				local Sound = Instance.new("Sound", game:GetService("SoundService"))
				Sound.PlayOnRemove = true
				Sound.PlaybackSpeed = 2
				Sound.Volume = 1
				Sound.SoundId = "rbxassetid://89087762338808"
				repeat wait() until Sound.IsLoaded == true
				Sound:Remove()
				tween(Auth.Frame, 1, { GroupTransparency = 1 })
				tween(Auth.Frame.UIStroke, 1, { Transparency = 1 })
				wait(2)
				Auth.Authenticated = true
				Auth.Frame:Destroy()
			end
		else
			local Sound = Instance.new("Sound", game:GetService("SoundService"))
			Sound.PlayOnRemove = true
			Sound.PlaybackSpeed = 1
			Sound.Volume = 1
			Sound.SoundId = "rbxassetid://89087762338808"
			repeat wait() until Sound.IsLoaded == true
			Sound:Remove()
		end
	end)
	
	Auth.Frame.Background.Instance.Discord.Invite.MouseButton1Click:Connect(function()
		Auth.Frame.Background.Instance.Discord.Invite.Text = ""
		Auth.Frame.Background.Instance.Discord.InviteHandler.Visible = true
	end)
	
	repeat wait() until game:IsLoaded()
	
	tween(Auth.Frame, 1.5, { GroupTransparency = 0 })
	tween(Auth.Frame.UIStroke, 1.5, { Transparency = 0.8 })
	
	local Sound = Instance.new("Sound", game:GetService("SoundService"))
	Sound.PlayOnRemove = true
	Sound.PlaybackSpeed = 1.8
	Sound.Volume = 1
	Sound.SoundId = "rbxassetid://89087762338808"

	repeat wait() until Sound.IsLoaded == true

	Sound:Remove()
	
	local Size1 = TXS:GetTextSize(Auth.Frame.Topbar.Titles.Label1.Text, 22, Enum.Font.SourceSansBold, Vector2.new(0, 22))
	local Size2 = TXS:GetTextSize(Auth.Frame.Topbar.Titles.Label2.Label.Text, 20, Enum.Font.SourceSansSemibold, Vector2.new(0, 20))
	Auth.Frame.Topbar.Titles.Label1.Size = UDim2.new(0, Size1.X + 5, 0, Size1.Y)
	Auth.Frame.Topbar.Titles.Label2.Size = UDim2.new(0, Size2.X + 10, 0, Size2.Y + 5)
	
	Auth.Frame.Parent = ScreenGui
	
	return Auth
end


ScreenGui.Parent = VG

return Library
