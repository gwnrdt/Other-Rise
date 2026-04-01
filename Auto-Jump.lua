local ScreenGui = Instance.new('ScreenGui')
local JumpButton = Instance.new('TextButton')
local UICorner = Instance.new('UICorner')

ScreenGui.Name = 'RiseAutoJump'
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild('PlayerGui')
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

JumpButton.Name = 'jump'
JumpButton.Parent = ScreenGui
JumpButton.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
JumpButton.BackgroundTransparency = 0.5
JumpButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
JumpButton.BorderSizePixel = 0
JumpButton.Position = UDim2.new(0.480299383, 0, 0.291583687, 0)
JumpButton.Size = UDim2.new(0, 227, 0, 40)
JumpButton.Font = Enum.Font.Code
JumpButton.Text = 'Auto Jump: OFF'
JumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpButton.TextSize = 23
JumpButton.TextWrapped = true

UICorner.Parent = JumpButton

local function MakeDraggable()
    local DragScript = Instance.new('LocalScript', JumpButton)

    DragScript.Parent.Draggable = true
    DragScript.Parent.Active = true
end

coroutine.wrap(MakeDraggable)()

local function AutoJumpSystem()
    local Button = Instance.new('LocalScript', JumpButton).Parent
    local Player = game.Players.LocalPlayer
    local AutoJump = false
    local Humanoid = nil

    local function SetupCharacter(Character)
        Humanoid = Character:WaitForChild('Humanoid')

        Humanoid.StateChanged:Connect(function(_, State)
            if AutoJump and State == Enum.HumanoidStateType.Landed then
                task.wait(0.05)

                if Humanoid and Humanoid.Health > 0 then
                    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    end

    SetupCharacter(Player.Character or Player.CharacterAdded:Wait())
    Player.CharacterAdded:Connect(SetupCharacter)

    Button.MouseButton1Click:Connect(function()
        AutoJump = not AutoJump

        if AutoJump then
            Button.Text = 'AutoJump: ON'

            if Humanoid and Humanoid.Health > 0 then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        else
            Button.Text = 'AutoJump: OFF'
        end
    end)

    Button.Text = 'AutoJump: OFF'
end

coroutine.wrap(AutoJumpSystem)()
