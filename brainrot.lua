-- RAGE MOD WORKING VERSION
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

-- Ждем загрузки игры
if not game:IsLoaded() then
    game.Loaded:Wait()
end
repeat wait() until LP.Character

-- Переменные
local ESPOn = false
local NoclipOn = false
local FlyOn = false
local MenuOpen = false
local ESPCache = {}
local Flying = false
local FlySpeed = 50

-- Создание GUI
local GUI = Instance.new("ScreenGui")
GUI.Name = "RAGE_MOD"
GUI.Parent = game.CoreGui

-- Главное меню
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 260, 0, 320)
Main.Position = UDim2.new(0.5, -130, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 15)
Main.BorderSizePixel = 0
Main.Visible = false
Main.Active = true
Main.Draggable = true
Main.Parent = GUI

-- Тень
local Shadow = Instance.new("Frame")
Shadow.Size = UDim2.new(1, 6, 1, 6)
Shadow.Position = UDim2.new(0, -3, 0, -3)
Shadow.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
Shadow.BorderSizePixel = 0
Shadow.ZIndex = -1
Shadow.Parent = Main

-- Заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 2
TitleBar.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Text = "RAGE MOD v1.01"
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0, 10, 0, 0)
Title.ZIndex = 2
Title.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 0, 0)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Text = "X"
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 2
CloseBtn.Parent = TitleBar

-- Контейнер кнопок
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Size = UDim2.new(1, -20, 1, -50)
ButtonContainer.Position = UDim2.new(0, 10, 0, 40)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Parent = Main

-- Функция создания кнопки
local function CreateButton(yPos, text)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(1, 0, 0, 35)
    buttonFrame.Position = UDim2.new(0, 0, 0, yPos)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = ButtonContainer
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 25)
    button.BorderSizePixel = 0
    button.Text = ""
    button.ZIndex = 2
    button.Parent = buttonFrame
    
    local buttonText = Instance.new("TextLabel")
    buttonText.Size = UDim2.new(1, -20, 1, 0)
    buttonText.Position = UDim2.new(0, 10, 0, 0)
    buttonText.BackgroundTransparency = 1
    buttonText.TextColor3 = Color3.fromRGB(255, 255, 255)
    buttonText.Text = text
    buttonText.TextSize = 14
    buttonText.Font = Enum.Font.Gotham
    buttonText.TextXAlignment = Enum.TextXAlignment.Left
    buttonText.ZIndex = 2
    buttonText.Parent = button
    
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(0, 40, 1, 0)
    statusText.Position = UDim2.new(1, -45, 0, 0)
    statusText.BackgroundTransparency = 1
    statusText.TextColor3 = Color3.fromRGB(255, 50, 50)
    statusText.Text = "OFF"
    statusText.TextSize = 12
    statusText.Font = Enum.Font.GothamBold
    statusText.ZIndex = 2
    statusText.Parent = button
    
    -- Анимация наведения
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 35)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(40, 40, 25)
    end)
    
    return button, statusText
end

-- Fly функция
local function StartFlying()
    if not FlyOn or not LP.Character then return end
    
    local character = LP.Character
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    Flying = true
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Parent = root
    
    while Flying and FlyOn and root and bodyVelocity do
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

-- ESP функция
local function UpdateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP then
            if player.Character then
                local char = player.Character
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                
                if humanoid and root then
                    local highlight = char:FindFirstChild("RAGE_ESP") or Instance.new("Highlight")
                    highlight.Name = "RAGE_ESP"
                    highlight.FillColor = Color3.fromRGB(255, 255, 255)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.8
                    highlight.Enabled = ESPOn
                    highlight.Parent = char
                end
            end
        end
    end
end

-- Создаем кнопки
local buttonData = {
    {"Player ESP", function(btn, status)
        ESPOn = not ESPOn
        status.Text = ESPOn and "ON" or "OFF"
        status.TextColor3 = ESPOn and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
        UpdateESP()
    end},
    
    {"Noclip", function(btn, status)
        NoclipOn = not NoclipOn
        status.Text = NoclipOn and "ON" or "OFF"
        status.TextColor3 = NoclipOn and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    end},
    
    {"Fly Mode", function(btn, status)
        FlyOn = not FlyOn
        status.Text = FlyOn and "ON" or "OFF"
        status.TextColor3 = FlyOn and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
        
        if FlyOn then
            coroutine.wrap(StartFlying)()
        else
            Flying = false
        end
    end},
    
    {"Speed Hack", function(btn, status)
        -- Заглушка для скорости
        status.Text = "SOON"
        status.TextColor3 = Color3.fromRGB(255, 215, 0)
    end}
}

local buttons = {}

for i, data in ipairs(buttonData) do
    local button, status = CreateButton((i-1) * 40, data[1])
    button.MouseButton1Click:Connect(function()
        data[2](button, status)
    end)
    buttons[data[1]] = {button = button, status = status}
end

-- Обработчики интерфейса
CloseBtn.MouseButton1Click:Connect(function()
    MenuOpen = false
    Main.Visible = false
end)

-- Обработка клавиши Insert
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        MenuOpen = not MenuOpen
        Main.Visible = MenuOpen
    end
end)

-- Запускаем циклы
RunService.Stepped:Connect(NoclipLoop)

-- Авто-обновление ESP
RunService.Heartbeat:Connect(function()
    if ESPOn then
        UpdateESP()
    end
end)

-- Информация
print("RAGE MOD loaded! Press INSERT to open menu")

-- Первоначальное обновление ESP
wait(2)
UpdateESP()
