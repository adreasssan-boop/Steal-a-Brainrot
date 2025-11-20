-- RAGE MOD Ultra Lite
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

-- Минимальный GUI
local GUI = Instance.new("ScreenGui")
GUI.Parent = game.CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 200, 0, 150)
Main.Position = UDim2.new(0, 10, 0, 10)
Main.BackgroundColor3 = Color3.new(0.1, 0.1, 0)
Main.BorderColor3 = Color3.new(1, 0.84, 0)
Main.Parent = GUI

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 20)
Title.BackgroundColor3 = Color3.new(1, 0.84, 0)
Title.TextColor3 = Color3.new(0, 0, 0)
Title.Text = "RAGE MOD"
Title.Parent = Main

-- Переменные
local ESPOn = false
local NoclipOn = false
local ESPCache = {}

-- Функция ESP (оптимизированная)
local function SimpleESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and not ESPCache[player] then
            ESPCache[player] = true
            
            local function setup()
                if not player.Character then return end
                
                local char = player.Character
                local root = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChild("Humanoid")
                
                if not root or not hum then return end
                
                -- Минимальный Highlight
                local hl = Instance.new("Highlight")
                hl.Name = "RAGE_HL"
                hl.Parent = char
                hl.Enabled = ESPOn
                hl.FillColor = Color3.new(1, 1, 1)
                hl.OutlineColor = Color3.new(1, 1, 1)
                hl.FillTransparency = 0.9
                
                -- Обновление
                RunService.Heartbeat:Connect(function()
                    if not char or not char.Parent then
                        hl:Destroy()
                        return
                    end
                    hl.Enabled = ESPOn
                end)
            end
            
            if player.Character then
                setup()
            end
            player.CharacterAdded:Connect(setup)
        end
    end
end

-- Noclip функция
local function NoclipLoop()
    if NoclipOn and LP.Character then
        for _, part in pairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end

-- Кнопки
local yPos = 25

local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0.9, 0, 0, 25)
ESPBtn.Position = UDim2.new(0.05, 0, 0, yPos)
ESPBtn.BackgroundColor3 = Color3.new(1, 0.84, 0)
ESPBtn.TextColor3 = Color3.new(0, 0, 0)
ESPBtn.Text = "ESP: OFF"
ESPBtn.Parent = Main
yPos = yPos + 30

ESPBtn.MouseButton1Click:Connect(function()
    ESPOn = not ESPOn
    ESPBtn.Text = "ESP: " .. (ESPOn and "ON" or "OFF")
    SimpleESP()
end)

local NoclipBtn = Instance.new("TextButton")
NoclipBtn.Size = UDim2.new(0.9, 0, 0, 25)
NoclipBtn.Position = UDim2.new(0.05, 0, 0, yPos)
NoclipBtn.BackgroundColor3 = Color3.new(1, 0.84, 0)
NoclipBtn.TextColor3 = Color3.new(0, 0, 0)
NoclipBtn.Text = "NOCLIP: OFF"
NoclipBtn.Parent = Main
yPos = yPos + 30

NoclipBtn.MouseButton1Click:Connect(function()
    NoclipOn = not NoclipOn
    NoclipBtn.Text = "NOCLIP: " .. (NoclipOn and "ON" or "OFF")
end)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0.9, 0, 0, 25)
CloseBtn.Position = UDim2.new(0.05, 0, 0, yPos)
CloseBtn.BackgroundColor3 = Color3.new(1, 0, 0)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Text = "CLOSE"
CloseBtn.Parent = Main

CloseBtn.MouseButton1Click:Connect(function()
    GUI:Destroy()
end)

-- Запуск циклов
RunService.Stepped:Connect(NoclipLoop)

-- Инициализация ESP
wait(1)
SimpleESP()
