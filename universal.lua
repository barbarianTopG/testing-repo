local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/refs/heads/main/Library.lua"))()
local themeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/refs/heads/main/addons/ThemeManager.lua"))()
local saveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/refs/heads/main/addons/SaveManager.lua"))()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local currentCamera = workspace.CurrentCamera;
local localPlayer = Players.LocalPlayer;
local settings = {
	Combat = {
		Aimbot = {
			Enabled = false,
			TeamCheck = false,
			Smoothness = 0,
			HitPart = "Head"
		},
		Prediction = {
			Enabled = false,
			X = 0.1433,
			Y = 0.13872
		},
		ClosestCharacters = false
	},
	Visuals = {
		TeamCheck = false,
		ClosestCharacters = false,
		Box = {
			Enabled = false,
			Color = Color3.fromRGB(255, 255, 255)
		},
		Healthbar = {
			Enabled = false,
			Color = Color3.fromRGB(100, 255, 0)
		},
		Tracers = {
			Enabled = false,
			Color = Color3.fromRGB(255, 255, 255)
		},
		Name = {
			Enabled = false,
			Color = Color3.fromRGB(255, 255, 255)
		}
	},
	Misc = {
		Player = {
			Fly = {
				Enabled = false,
				Speed = 0
			},
			WalkSpeed = {
				Enabled = false,
				Speed = 50
			},
			Spinbot = {
				Enabled = false,
				Speed = 50
			}
		}
	}
}
local cache = {
	Players = {},
	Drawing = {}
}
local internalState = {
	Drawing = {},
	ClosestPlayer = nil,
	Player = {
		OldVelocity = Vector3.new(0, 0, 0)
	},
	Players = {
		OldPositions = {},
		RenderPositions = {}
	}
}
local Window = UILibrary:CreateWindow({
	Title = "homohack @vydrak | made by jemstry#0001 / dm me for key",
	Center = true,
	AutoShow = true,
	Padding = 8,
	MinFadeTime = 0.2
})
local Tabs = {
	AimbotTab = Window:AddTab("Aimbot"),
	VisualsTab = Window:AddTab("Visuals"),
	MiscTab = Window:AddTab("Misc"),
	UISettingsTab = Window:AddTab("UI Settings")
}
local Groups = {
	CombatSection = Tabs.AimbotTab:AddLeftGroupbox("Aimbot"),
	OtherSection = Tabs.AimbotTab:AddRightGroupbox("Other"),
	VisualsSection = Tabs.VisualsTab:AddLeftGroupbox("Visuals"),
	MiscSection = Tabs.MiscTab:AddLeftGroupbox("Misc")
}
local fovCircle = Drawing.new("Circle")
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Transparency = 1;
fovCircle.Visible = false;
fovCircle.Radius = 0;
Groups.CombatSection:AddToggle("Aimbot_Enabled", {
	Text = "Aimbot",
	Default = false,
	Callback = function(value)
		settings.Combat.Aimbot.Enabled = value
	end
})
Groups.CombatSection:AddToggle("FOV_Circle_Enabled", {
	Text = "FOV Circle",
	Default = false,
	Callback = function(value)
		fovCircle.Visible = value
	end
})
Groups.CombatSection:AddSlider("FOV_Circle_Radius", {
	Text = "FOV Circle Radius",
	Default = 0,
	Min = 0,
	Max = 1000,
	Rounding = 1,
	Callback = function(value)
		fovCircle.Radius = value
	end
})
Groups.CombatSection:AddDropdown("Aimbot_HitPart", {
	Values = {
		"Head",
		"HumanoidRootPart"
	},
	Default = 1,
	Multi = false,
	Text = "Aimbot HitPart",
	Callback = function(value)
		settings.Combat.Aimbot.HitPart = value
	end
})
Groups.OtherSection:AddToggle("Aimbot_TeamCheck", {
	Text = "Team Check",
	Default = false,
	Callback = function(value)
		settings.Combat.Aimbot.TeamCheck = value
	end
})
Groups.OtherSection:AddToggle("Prediction_Enabled", {
	Text = "Prediction",
	Default = false,
	Callback = function(value)
		settings.Combat.Prediction.Enabled = value
	end
})
Groups.OtherSection:AddSlider("Prediction_X_Value", {
	Text = "Prediction X",
	Default = settings.Combat.Prediction.X,
	Min = 0,
	Max = 1,
	Rounding = 3,
	Callback = function(value)
		settings.Combat.Prediction.X = value
	end
})
Groups.OtherSection:AddSlider("Prediction_Y_Value", {
	Text = "Prediction Y",
	Default = settings.Combat.Prediction.Y,
	Min = 0,
	Max = 1,
	Rounding = 3,
	Callback = function(value)
		settings.Combat.Prediction.Y = value
	end
})
Groups.OtherSection:AddDivider()
Groups.OtherSection:AddSlider("Smoothness_Value", {
	Text = "Smoothness",
	Default = settings.Combat.Aimbot.Smoothness,
	Min = 0,
	Max = 10,
	Rounding = 1,
	Callback = function(value)
		settings.Combat.Aimbot.Smoothness = value
	end
})
Groups.VisualsSection:AddToggle("ESP_TeamCheck", {
	Text = "Team Check",
	Default = false,
	Callback = function(value)
		settings.Visuals.TeamCheck = value
	end
})
Groups.VisualsSection:AddToggle("ESP_Box_Enabled", {
	Text = "Box",
	Default = false,
	Callback = function(value)
		settings.Visuals.Box.Enabled = value
	end
}):AddColorPicker("Box_Color", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "Box Color",
	Callback = function(value)
		settings.Visuals.Box.Color = value
	end
})
Groups.VisualsSection:AddToggle("ESP_Name_Enabled", {
	Text = "Name",
	Default = false,
	Callback = function(value)
		settings.Visuals.Name.Enabled = value
	end
}):AddColorPicker("Name_Color", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "Name Color",
	Callback = function(value)
		settings.Visuals.Name.Color = value
	end
})
Groups.VisualsSection:AddToggle("ESP_Healthbar_Enabled", {
	Text = "Healthbar",
	Default = false,
	Callback = function(value)
		settings.Visuals.Healthbar.Enabled = value
	end
}):AddColorPicker("Healthbar_Color", {
	Default = Color3.fromRGB(100, 255, 0),
	Title = "Healthbar Color",
	Callback = function(value)
		settings.Visuals.Healthbar.Color = value
	end
})
Groups.VisualsSection:AddToggle("ESP_Tracers_Enabled", {
	Text = "Tracers",
	Default = false,
	Callback = function(value)
		settings.Visuals.Tracers.Enabled = value
	end
}):AddColorPicker("Tracer_Color", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "Tracer Color",
	Callback = function(value)
		settings.Visuals.Tracers.Color = value
	end
})
Groups.MiscSection:AddToggle("Spinbot_Enabled", {
	Text = "Spinbot",
	Default = false,
	Callback = function(value)
		settings.Misc.Player.Spinbot.Enabled = value
	end
})
Groups.MiscSection:AddSlider("Spinbot_Speed_Value", {
	Text = "Spinbot Speed",
	Default = settings.Misc.Player.Spinbot.Speed,
	Min = 0,
	Max = 100,
	Rounding = 1,
	Callback = function(value)
		settings.Misc.Player.Spinbot.Speed = value
	end
})
Groups.MiscSection:AddToggle("WalkSpeed_Enabled", {
	Text = "WalkSpeed",
	Default = false,
	Callback = function(value)
		settings.Misc.Player.WalkSpeed.Enabled = value
	end
})
Groups.MiscSection:AddSlider("WalkSpeed_Value", {
	Text = "WalkSpeed Value",
	Default = settings.Misc.Player.WalkSpeed.Speed,
	Min = 0,
	Max = 100,
	Rounding = 1,
	Callback = function(value)
		settings.Misc.Player.WalkSpeed.Speed = value
	end
})
function cache.Players.GetClosestPlayer()
	local closestPlayer = nil;
	local shortestDistance = math.huge;
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local targetPart = player.Character:FindFirstChild(settings.Combat.Aimbot.HitPart)
			if targetPart then
				local screenPosition, onScreen = currentCamera:WorldToViewportPoint(targetPart.Position)
				local distance = (UserInputService:GetMouseLocation() - Vector2.new(screenPosition.X, screenPosition.Y)).Magnitude;
				local isTeamCheckPassed = (settings.Combat.Aimbot.TeamCheck and player.Team ~= localPlayer.Team) or not settings.Combat.Aimbot.TeamCheck;
				if distance < shortestDistance and distance < fovCircle.Radius and onScreen and isTeamCheckPassed then
					shortestDistance = distance;
					closestPlayer = player
				end
			end
		end
	end;
	return closestPlayer
end;
function cache.Drawing.Cache(player)
	if not internalState.Drawing[player] then
		local drawings = {
			Boxes = {
				Box = Drawing.new("Square"),
				Healthbar = Drawing.new("Square")
			},
			Text = {
				Name = Drawing.new("Text")
			},
			Lines = {
				Tracer = Drawing.new("Line")
			}
		}
		for _, boxType in pairs(drawings.Boxes) do
			boxType.Visible = false;
			boxType.Transparency = 1;
			boxType.Color = Color3.fromRGB(255, 255, 255)
		end;
		for _, textType in pairs(drawings.Text) do
			textType.Visible = false;
			textType.Transparency = 1;
			textType.Color = Color3.fromRGB(255, 255, 255)
			textType.Center = true
		end;
		internalState.Drawing[player] = drawings
	end
end;
function cache.Drawing.ClearCache(player)
	if internalState.Drawing[player] then
		local drawings = internalState.Drawing[player]
		drawings.Boxes.Box.Visible = false;
		drawings.Boxes.Box:Remove()
		drawings.Boxes.Healthbar.Visible = false;
		drawings.Boxes.Healthbar:Remove()
		drawings.Lines.Tracer.Visible = false;
		drawings.Lines.Tracer:Remove()
		drawings.Text.Name.Visible = false;
		drawings.Text.Name:Remove()
		internalState.Drawing[player] = nil
	end
end;
RunService.RenderStepped:Connect(function()
	pcall(function()
		if settings.Combat.Aimbot.Enabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
			local target = internalState.ClosestPlayer;
			if target and target.Character then
				local targetPart = target.Character:FindFirstChild(settings.Combat.Aimbot.HitPart)
				local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
				if targetPart and humanoid and humanoid.Health > 0 then
					local targetVelocity = target.Character.HumanoidRootPart.Velocity;
					local predictedPosition = (settings.Combat.Prediction.Enabled and targetPart.Position + Vector3.new(targetVelocity.X * settings.Combat.Prediction.X, targetVelocity.Y * settings.Combat.Prediction.Y, targetVelocity.Z * settings.Combat.Prediction.X)) or targetPart.Position;
					local smoothness = settings.Combat.Aimbot.Smoothness ~= 0 and 0.04 * (1 / settings.Combat.Aimbot.Smoothness) or 1;
					currentCamera.CFrame = currentCamera.CFrame:Lerp(CFrame.new(currentCamera.CFrame.Position, predictedPosition), smoothness)
				else
					internalState.ClosestPlayer = nil
				end
			end;
			if not internalState.ClosestPlayer then
				internalState.ClosestPlayer = cache.Players.GetClosestPlayer()
			end
		end
	end)
	for _, player in pairs(Players:GetPlayers()) do
		cache.Drawing.Cache(player)
	end;
	for player, drawings in pairs(internalState.Drawing) do
		local character = player.Character;
		local isPlayerValid = character and character:FindFirstChild("HumanoidRootPart")
		if isPlayerValid then
			local box = drawings.Boxes.Box;
			local healthBar = drawings.Boxes.Healthbar;
			local tracer = drawings.Lines.Tracer;
			local nameText = drawings.Text.Name;
			local rootPart = character.HumanoidRootPart;
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			local screenPosition, onScreen = currentCamera:WorldToViewportPoint(rootPart.Position)
			local distance = (currentCamera.CFrame.Position - rootPart.Position).Magnitude;
			local isTeamCheckPassed = (settings.Visuals.TeamCheck and localPlayer.Team ~= player.Team) or not settings.Visuals.TeamCheck;
			if onScreen and player ~= localPlayer and isTeamCheckPassed then
				local boxSizeMultiplier = ((1000 / distance) * 80) / currentCamera.FieldOfView;
				local characterSize = player.Character:GetExtentsSize() / 1.5;
				box.Size = Vector2.new(characterSize.X * boxSizeMultiplier, characterSize.Y * boxSizeMultiplier)
				box.Position = Vector2.new(screenPosition.X - box.Size.X / 2, screenPosition.Y - box.Size.Y / 2)
				box.Visible = settings.Visuals.Box.Enabled;
				box.Color = settings.Visuals.Box.Color;
				local health = humanoid.Health;
				local maxHealth = humanoid.MaxHealth;
				healthBar.Size = Vector2.new(2, (box.Size.Y * health) / maxHealth)
				healthBar.Position = Vector2.new(box.Position.X - 2.5, box.Position.Y + box.Size.Y * (1 - health / maxHealth))
				healthBar.Color = settings.Visuals.Healthbar.Color;
				healthBar.Visible = settings.Visuals.Healthbar.Enabled;
				tracer.From = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
				tracer.To = Vector2.new(box.Position.X + box.Size.X / 2, box.Position.Y + box.Size.Y)
				tracer.Visible = settings.Visuals.Tracers.Enabled;
				tracer.Color = settings.Visuals.Tracers.Color;
				nameText.Position = Vector2.new(box.Position.X + box.Size.X / 2, box.Position.Y - nameText.TextBounds.Y)
				nameText.Text = player.Name;
				nameText.Visible = settings.Visuals.Name.Enabled;
				nameText.Size = math.clamp((1 / distance) * 1000, 10, 20)
				nameText.Font = 2;
				nameText.Color = settings.Visuals.Name.Color
			else
				cache.Drawing.ClearCache(player)
			end
		else
			cache.Drawing.ClearCache(player)
		end
	end;
	if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local rootPart = localPlayer.Character.HumanoidRootPart;
		local humanoid = localPlayer.Character.Humanoid;
		if settings.Misc.Player.WalkSpeed.Enabled then
			humanoid.WalkSpeed = settings.Misc.Player.WalkSpeed.Speed
		end;
		if settings.Misc.Player.Spinbot.Enabled then
			humanoid.AutoRotate = false;
			rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, settings.Misc.Player.Spinbot.Speed / 200, 0)
		else
			humanoid.AutoRotate = true
		end
	end;
	fovCircle.Position = UserInputService:GetMouseLocation()
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		internalState.ClosestPlayer = nil
	end
end)
Window:OnUnload(function()
	Window:Destroy()
    UILibrary = nil
    themeManager = nil 
    saveManager = nil
    fovCircle:Remove()
    fovCircle = nil
    internalState = nil
    cache = nil
end)
local menuSettingsGroup = Tabs.UISettingsTab:AddLeftGroupbox("Menu")
menuSettingsGroup:AddButton("Unload", function()
	Window:Unload()
end)
menuSettingsGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
	Default = "End",
	NOUI = true,
	Text = "Menu keybind"
})
Window.ToggleKeybind = Options.MenuKeybind;
themeManager:SetLibrary(Window)
saveManager:SetLibrary(Window)
saveManager:IgnoreThemeSettings()
saveManager:SetIgnoreIndexes({
	"MenuKeybind"
})
themeManager:SetFolder("Homohack")
saveManager:SetFolder("Homohack/visuals")
saveManager:BuildConfigSection(Tabs.UISettingsTab)
themeManager:ApplyToTab(Tabs.UISettingsTab)
saveManager:LoadAutoloadConfig()
