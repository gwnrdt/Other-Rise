-- Gui to Lua
-- Version: 3.2

-- Instances:

local RiseAutoCarry = Instance.new("ScreenGui")
local carry = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

--Properties:

RiseAutoCarry.Name = "RiseAutoCarry"
RiseAutoCarry.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
RiseAutoCarry.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
RiseAutoCarry.ResetOnSpawn = false

carry.Name = "carry"
carry.Parent = RiseAutoCarry
carry.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
carry.BackgroundTransparency = 0.300
carry.BorderColor3 = Color3.fromRGB(0, 0, 0)
carry.BorderSizePixel = 0
carry.Position = UDim2.new(0.572982252, -100, 0.322164178, -25)
carry.Size = UDim2.new(0, 227, 0, 40)
carry.Font = Enum.Font.Code
carry.Text = "Auto Carry: OFF"
carry.TextColor3 = Color3.fromRGB(255, 255, 255)
carry.TextSize = 23.000
carry.TextWrapped = true

UICorner.Parent = carry

-- Scripts:

local function GBKRO_fake_script() -- carry.drag 
	local script = Instance.new('LocalScript', carry)

	script.Parent.Draggable = true
	script.Parent.Active = true
end
coroutine.wrap(GBKRO_fake_script)()
local function YDARNBS_fake_script() -- carry.LocalScript 
	local script = Instance.new('LocalScript', carry)

	local Players = game:GetService("Players")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Player = Players.LocalPlayer
	local Event = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Character"):WaitForChild("Interact")
	
	local gui = Player:WaitForChild("PlayerGui"):WaitForChild("RiseAutoCarry")
	local button = gui:WaitForChild("carry") -- carry butonu
	
	local autoCarry = false
	local carryLoop
	local MAX_DISTANCE = 15 -- maksimum mesafe (stud)
	
	-- En yakın downed oyuncuyu bul (15 stud sınırı)
	local function getNearestDownedPlayer()
		local nearest
		local shortestDist = math.huge
		local myChar = Player.Character
		if not myChar or not myChar.PrimaryPart then return nil end
	
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= Player and plr.Character and plr.Character.PrimaryPart then
				local downed = plr.Character:GetAttribute("Downed") or false
				if downed then
					local dist = (plr.Character.PrimaryPart.Position - myChar.PrimaryPart.Position).Magnitude
					if dist < shortestDist and dist <= MAX_DISTANCE then
						shortestDist = dist
						nearest = plr
					end
				end
			end
		end
		return nearest
	end
	
	-- Auto-Carry başlat/durdur
	local function setAutoCarry(state)
		autoCarry = state
		if state then
			button.Text = "Auto Carry: ON"
			carryLoop = task.spawn(function()
				while autoCarry do
					local target = getNearestDownedPlayer()
					if target then
						local args = {
							[1] = "Carry",
							[3] = target.Name
						}
						Event:FireServer(unpack(args))
					end
					task.wait(0.5)
				end
			end)
		else
			button.Text = "Auto Carry: OFF"
			if carryLoop then
				task.cancel(carryLoop)
				carryLoop = nil
			end
		end
	end
	
	-- Butona tıklandığında toggle
	button.MouseButton1Click:Connect(function()
		setAutoCarry(not autoCarry)
	end)
	
	-- Başlangıçta kapalı
	button.Text = "Auto Carry: OFF"
	
end
coroutine.wrap(YDARNBS_fake_script)()
