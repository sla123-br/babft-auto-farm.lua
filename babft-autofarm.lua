glocal ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local autoFarmEnabled = false
local speed = 360
local currentTween = nil
local isMinimized = false

-- Anti-AFK
player.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

-- Interface
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BABFT_UltraFarm_v6"
screenGui.ResetOnSpawn = false
local s, _ = pcall(function() screenGui.Parent = CoreGui end)
if not s then screenGui.Parent = player:WaitForChild("PlayerGui") end

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 180)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BackgroundTransparency = 0.7
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local uiCornerMain = Instance.new("UICorner", mainFrame)
uiCornerMain.CornerRadius = UDim.new(0, 10)

local uiStrokeMain = Instance.new("UIStroke", mainFrame)
uiStrokeMain.Color = Color3.fromRGB(255, 255, 255)
uiStrokeMain.Transparency = 0.6
uiStrokeMain.Thickness = 1.2

local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
topBar.BackgroundTransparency = 0.7
topBar.BorderSizePixel = 0
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "BABFT | Auto Farm"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left

local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, 0, 1, -35)
contentFrame.Position = UDim2.new(0, 0, 0, 35)
contentFrame.BackgroundTransparency = 1

local statusLabel = Instance.new("TextLabel", contentFrame)
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 0, 15)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Parado"
statusLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextSize = 13

local toggleBtn = Instance.new("TextButton", contentFrame)
toggleBtn.Size = UDim2.new(0, 240, 0, 45)
toggleBtn.Position = UDim2.new(0.5, -120, 0, 65)
toggleBtn.BackgroundColor3 = Color3.fromRGB(90, 60, 200)
toggleBtn.BackgroundTransparency = 0.3
toggleBtn.Text = "INICIAR FARM"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

-- Sistema de Arrasto
local dragging, dragInput, dragStart, startPos
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = input.Position startPos = mainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input) dragging = false end)

-- Funções de Farm
local function getHRP() return player.Character and player.Character:FindFirstChild("HumanoidRootPart") end

local function tweenTo(targetPos)
    local hrp = getHRP()
    if not hrp or not autoFarmEnabled then return end
    local dist = (hrp.Position - targetPos).Magnitude
    currentTween = TweenService:Create(hrp, TweenInfo.new(dist / speed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
    currentTween:Play()
    local noclip = RunService.Stepped:Connect(function()
        if not autoFarmEnabled or not hrp then return end
        hrp.Velocity = Vector3.new(0, 0, 0)
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end)
    currentTween.Completed:Wait()
    noclip:Disconnect()
    currentTween = nil
end

local function doAutoFarm()
    while autoFarmEnabled do
        local hrp = getHRP()
        if not hrp then task.wait(1) continue end
        
        statusLabel.Text = "Status: Teleportando..."
        hrp.CFrame = CFrame.new(-60, 49, 1341)
        task.wait(0.5)
        
        if not autoFarmEnabled then break end
        statusLabel.Text = "Status: Indo pro final..."
        tweenTo(Vector3.new(-52, 25, 8724))
        
        if not autoFarmEnabled then break end
        statusLabel.Text = "Status: Coletando Baú..."
        tweenTo(Vector3.new(-56, -348, 9491))

        if getHRP() then 
            getHRP().CFrame = CFrame.new(-56, -358, 9491) 
        end
        task.wait(3)

        statusLabel.Text = "Status: Registrando Ouro..."
        local t = 11 
        while t > 0 and autoFarmEnabled do
            local currentHrp = getHRP()
            if currentHrp then
                local offX = (math.random() * 3) - 1.5
                local offZ = (math.random() * 3) - 1.5
                currentHrp.CFrame = CFrame.new(-56 + offX, -358, 9491 + offZ)
            end
            task.wait(0.1)
            t = t - 0.1
        end
        
        statusLabel.Text = "Status: Esperando Loop (15s)..."
        local waitT = 12 while waitT > 0 and autoFarmEnabled do task.wait(0.5) waitT = waitT - 0.5 end
    end
end

toggleBtn.MouseButton1Click:Connect(function()
    autoFarmEnabled = not autoFarmEnabled
    if autoFarmEnabled then
        toggleBtn.Text = "PARAR FARM"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        task.spawn(doAutoFarm)
    else
        toggleBtn.Text = "INICIAR FARM"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(90, 60, 200)
        statusLabel.Text = "Status: Parado"
        if currentTween then currentTween:Cancel() end
        if player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.Health = 0 end
    end
end)
ame
