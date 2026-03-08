local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local autoFarmEnabled = false
local speed = 362
local currentTween = nil
local isMinimized = false

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

local uiCornerMain = Instance.new("UICorner")
uiCornerMain.CornerRadius = UDim.new(0, 10)
uiCornerMain.Parent = mainFrame

local uiStrokeMain = Instance.new("UIStroke")
uiStrokeMain.Color = Color3.fromRGB(255, 255, 255)
uiStrokeMain.Transparency = 0.6
uiStrokeMain.Thickness = 1.2
uiStrokeMain.Parent = mainFrame

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
topBar.BackgroundTransparency = 0.7
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 10)
topBarCorner.Parent = topBar

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -35)
contentFrame.Position = UDim2.new(0, 0, 0, 35)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "BABFT | Auto Farm"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 0, 15)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Parado"
statusLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextSize = 13
statusLabel.Parent = contentFrame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 240, 0, 45)
toggleBtn.Position = UDim2.new(0.5, -120, 0, 65)
toggleBtn.BackgroundColor3 = Color3.fromRGB(90, 60, 200)
toggleBtn.BackgroundTransparency = 0.3
toggleBtn.Text = "INICIAR FARM"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.Parent = contentFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = toggleBtn

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -65, 0, 2)
minBtn.BackgroundTransparency = 1
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 18
minBtn.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 2)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = topBar

local dragging, dragInput, dragStart, startPos
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = input.Position startPos = mainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
topBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    mainFrame:TweenSize(isMinimized and UDim2.new(0, 300, 0, 35) or UDim2.new(0, 300, 0, 180), "Out", "Quint", 0.3, true)
    contentFrame.Visible = not isMinimized
end)

closeBtn.MouseButton1Click:Connect(function()
    autoFarmEnabled = false
    if currentTween then currentTween:Cancel() end
    screenGui:Destroy()
end)

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
        local chestPos = Vector3.new(-56, -348, 9491)
        tweenTo(chestPos)
        
        if getHRP() then 
            getHRP().CFrame = CFrame.new(-56, -358, 9491) 
        end
        task.wait(1)
        
        statusLabel.Text = "Status: Registrando Ouro..."
        local t = 11 
        while t > 0 and autoFarmEnabled do
            local currentHrp = getHRP()
            if currentHrp then
                local offX = (math.random() * 3) - 1.5
                local offZ = (math.random() * 3) - 1.5
                currentHrp.CFrame = CFrame.new(Vector3.new(-56 + offX, -358, 9491 + offZ))
            end
            task.wait(0.1)
            t = t - 0.1
        end
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

