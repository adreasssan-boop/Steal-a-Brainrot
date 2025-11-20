-- RAGE MOD Advanced
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- Переменные
local ESPOn = false
local NoclipOn = false
local FlyOn = false
local MenuOpen = false
local ESPCache = {}
local Flying = false
local FlySpeed = 50

-- Кнопка открытия меню
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 40, 0, 40)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -20)
OpenBtn.BackgroundColor3 = Color3.new(1, 0.84, 0)
OpenBtn.TextColor3 = Color3.new(0, 0, 0)
OpenBtn.Text = "☰"
OpenBtn.TextSize = 20
OpenBtn.ZIndex = 10
OpenBtn.Parent = game.CoreGui

-- Основное меню
local GUI = Instance.new("ScreenGui")
GUI.Parent = game.CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 220, 0, 200)
Main.Position = UDim2.new(0, 60, 0, 10)
Main.BackgroundColor3 = Color3.new(0.1, 0.1, 0)
Main.BorderColor3 = Color3.new(1, 0.84, 0)
Main.Visible = false
Main.Active = true
Main.Draggable = true
Main.Parent = GUI

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundColor3 = Color3.new(1, 0.84, 0)
Title.TextColor3 = Color3.new(0, 0, 0)
Title.Text = "RAGE MOD - Перетащи"
Title.TextSize = 14
Title.Parent = Main

-- Функция Fly
local function StartFlying()
    if not FlyOn or not LP.Character then return end
    
    local character = LP.Character
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not root then return end
    
    Flying = true
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Parent = root
    
    local function fly()
        while Flying and FlyOn do
            if not root or not bodyVelocity then break end
            
            local camera = workspace.CurrentCamera
            local direction = Vector3.new(0, 0, 0)
            
            if UIS:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + camera.CFrame.LookVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - camera.CFrame.LookVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.A) then
                direction = direction - camera.CFrame.RightVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + camera.CFrame.RightVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + Vector3.new(0, 1, 0)
            end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                direction = direction + Vector3.new(0, -1, 0)
            end
            
            if direction.Magnitude > 0 then
                bodyVelocity.Velocity = direction.Unit * FlySpeed
            else
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
            
            RunService.Heartbeat:Wait()
        end
        
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
    end
    
    coroutine.wrap(fly)()
end

-- Улучшенный Noclip
local function AdvancedNoclip()
    if not NoclipOn or not LP.Character then return end
    
    local character = LP.Character
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.Velocity = Vector3.new(0, 0, 0)
        end
    end
end

-- Функция ESP
local function SimpleESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and not ESPCache[player] then
            ESPCache[player] = true
            
            local function setup()
                if not player.Character then return end
                
                local char = player.Character
                local root = char:FindFirstChild("HumanoidRootPart")
                if not root then return end
                
                local hl = Instance.new("Highlight")
                hl.Name = "RAGE_HL"
                hl.Parent = char
                hl.Enabled = ESPOn
                hl.FillColor = Color3.new(1, 1, 1)
                hl.OutlineColor = Color3.new(1, 1, 1)
                hl.FillTransparency = 0.9
                
                local conn
                conn = RunService.Heartbeat:Connect(function()
                    if not char or not char.Parent then
                        conn:Disconnect()
                        hl:Destroy()
                        return
                    end
                    hl.Enabled = ESPOn
                end)
            end
            
            if player.Character then
                coroutine.wrap(setup)()
            end
            player.CharacterAdded:Connect(function()
                wait(1)
                setup()
            end)
        end
    end
end

-- Создание кнопок в меню
local yPos = 30

local function CreateButton(text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 25)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.new(1, 0.84, 0)
    btn.TextColor3 = Color3.new(0, 0, 0)
    btn.Text = text
    btn.TextSize = 12
    btn.Parent = Main
    yPos = yPos + 30
    return btn
end

-- Кнопки
local ESPBtn = CreateButton("ESP: OFF")
local NoclipBtn = CreateButton("NOCLIP: OFF")
local FlyBtn = CreateButton("FLY: OFF")
local CloseMenuBtn = CreateButton("ЗАКРЫТЬ МЕНЮ")

-- Обработчики кнопок
ESPBtn.MouseButton1Click:Connect(function()
    ESPOn = not ESPOn
    ESPBtn.Text = "ESP: " .. (ESPOn and "ON" or "OFF")
    SimpleESP()
end)

NoclipBtn.MouseButton1Click:Connect(function()
    NoclipOn = not NoclipOn
    NoclipBtn.Text = "NOCLIP: " .. (NoclipOn and "ON" or "OFF")
end)

FlyBtn.MouseButton1Click:Connect(function()
    FlyOn = not FlyOn
    FlyBtn.Text = "FLY: " .. (FlyOn and "ON" or "OFF")
    
    if FlyOn then
        StartFlying()
    else
        Flying = false
    end
end)

CloseMenuBtn.MouseButton1Click:Connect(function()
    MenuOpen = false
    Main.Visible = false
    OpenBtn.Visible = true
end)

-- Кнопка открытия меню
OpenBtn.MouseButton1Click:Connect(function()
    MenuOpen = not MenuOpen
    Main.Visible = MenuOpen
    OpenBtn.Visible = not MenuOpen
end)

-- Циклы
RunService.Stepped:Connect(AdvancedNoclip)

-- Инициализация
wait(2)
SimpleESP()

-- Авто-обновление ESP при новых игроках
Players.PlayerAdded:Connect(function(player)
    wait(2)
    SimpleESP()
end)
