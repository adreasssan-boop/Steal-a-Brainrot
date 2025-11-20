-- RAGE MOD Premium UI
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

-- Создание красивого GUI
local GUI = Instance.new("ScreenGui")
GUI.Name = "RAGE_MOD_UI"
GUI.Parent = game.CoreGui

-- Основное меню
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 250, 0, 300)
Main.Position = UDim2.new(0.5, -125, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 10)
Main.BorderSizePixel = 0
Main.Visible = false
Main.Active = true
Main.Draggable = true
Main.Parent = GUI

-- Тень
local Shadow = Instance.new("ImageLabel")
Shadow.Size = UDim2.new(1, 10, 1, 10)
Shadow.Position = UDim2.new(0, -5, 0, -5)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://5554237731"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
Shadow.Parent = Main

-- Заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
TitleBar.BorderSizePixel = 0
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
Title.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 0, 0)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Text = "×"
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar

-- Контейнер для кнопок
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Size = UDim2.new(1, -20, 1, -50)
ButtonContainer.Position = UDim2.new(0, 10, 0, 40)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Parent = Main

-- Стилизованная кнопка
local function CreateStyledButton(yPos, text)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(1, 0, 0, 40)
    buttonFrame.Position = UDim2.new(0, 0, 0, yPos)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = ButtonContainer
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 20)
    button.BorderSizePixel = 0
    button.Text = ""
    button.Parent = buttonFrame
    
    local buttonShadow = Instance.new("Frame")
    buttonShadow.Size = UDim2.new(1, 4, 1, 4)
    buttonShadow.Position = UDim2.new(0, -2, 0, -2)
    buttonShadow.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    buttonShadow.BorderSizePixel = 0
    buttonShadow.ZIndex = 0
    buttonShadow.Parent = buttonFrame
    
    local buttonText = Instance.new("TextLabel")
    buttonText.Size = UDim2.new(1, -20, 1, 0)
    buttonText.Position = UDim2.new(0, 10, 0, 0)
    buttonText.BackgroundTransparency = 1
    buttonText.TextColor3 = Color3.fromRGB(255, 255, 255)
    buttonText.Text = text
    buttonText.TextSize = 14
    buttonText.Font = Enum.Font.Gotham
    buttonText.TextXAlignment = Enum.TextXAlignment.Left
    buttonText.Parent = button
    
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(0, 40, 1, 0)
    statusText.Position = UDim2.new(1, -45, 0, 0)
    statusText.BackgroundTransparency = 1
    statusText.TextColor3 = Color3.fromRGB(255, 50, 50)
    statusText.Text = "OFF"
    statusText.TextSize = 12
    statusText.Font = Enum.Font.GothamBold
    statusText.Parent = button
    
    -- Анимация наведения
    button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 25)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 20)}):Play()
    end)
    
    return button, statusText
end

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
                hl.FillColor = Color3.fromRGB(255, 255, 255)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
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

-- Создание кнопок
local buttons = {}
local statusLabels = {}

local buttonConfigs = {
    "Player ESP",
    "Noclip",
    "Fly Mode",
    "Speed Hack"
}

for i, config in ipairs(buttonConfigs) do
    local button, status = CreateStyledButton((i-1) * 45, config)
    buttons[config] = button
    statusLabels[config] = status
end

-- Обработчики кнопок
buttons["Player ESP"].MouseButton1Click:Connect(function()
    ESPOn = not ESPOn
    statusLabels["Player ESP"].Text = ESPOn and "ON" or "OFF"
    statusLabels["Player ESP"].TextColor3 = ESPOn and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    SimpleESP()
end)

buttons["Noclip"].MouseButton1Click:Connect(function()
    NoclipOn = not NoclipOn
    statusLabels["Noclip"].Text = NoclipOn and "ON" or "OFF"
    statusLabels["Noclip"].TextColor3 = NoclipOn and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
end)

buttons["Fly Mode"].MouseButton1Click:Connect(function()
    FlyOn = not FlyOn
    statusLabels["Fly Mode"].Text = FlyOn and "ON" or "OFF"
    statusLabels["Fly Mode"].TextColor3 = FlyOn and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    
    if FlyOn then
        StartFlying()
    else
        Flying = false
    end
end)

buttons["Speed Hack"].MouseButton1Click:Connect(function()
    -- Заглушка для будущей функции
end)

-- Управление меню
CloseBtn.MouseButton1Click:Connect(function()
    MenuOpen = false
    Main.Visible = false
end)

-- Открытие/закрытие на Insert
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Insert then
        MenuOpen = not MenuOpen
        Main.Visible = MenuOpen
    end
end)

-- Циклы
RunService.Stepped:Connect(AdvancedNoclip)

-- Информация в консоль
print("RAGE MOD loaded! Press INSERT to open menu")

-- Инициализация
wait(2)
SimpleESP()

-- Авто-обновление ESP
Players.PlayerAdded:Connect(function(player)
    wait(2)
    SimpleESP()
end)
