local ReplicatedStorage = game:GetService("ReplicatedStorage")
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
local mensagem = "🫪"
local tempoSegundos = 600

-- Anti-AFK
player.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

-- Loop do Chat (Agora em task.spawn para não travar o resto)
task.spawn(function()
    while true do
        local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if chatEvents then
            chatEvents.SayMessageRequest:FireServer(mensagem, "All")
        end
        task.wait(tempoSegundos)
    end
end)

-- Início da Interface (Restante do seu código)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BABFT_UltraFarm_v6"
screenGui.ResetOnSpawn = false
local s, _ = pcall(function() screenGui.Parent = CoreGui end)
if not s then screenGui.Parent = player:WaitForChild("PlayerGui") end

-- [O RESTANTE DO SEU CÓDIGO DA GUI SEGUE AQUI IGUAL...]
