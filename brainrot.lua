-- RAGE MOD Steal a brainrot Cheat
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Ожидание появления игрока
repeat wait() until LocalPlayer.Character

-- Simple GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "RAGE_MOD_GUI"

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 0)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Text = "RAGE MOD - Steal a brainrot"
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold

-- ESP Tab
local ESPFrame = Instance.new("Frame")
ESPFrame.Parent = MainFrame
ESPFrame.Size = UDim2.new(1, 0, 1, -30)
ESPFrame.Position = UDim2.new(0, 0, 0, 30)
ESPFrame.BackgroundTransparency = 1
ESPFrame.Visible = true

-- MISC Tab
local MISCFrame = Instance.new("Frame")
MISCFrame.Parent = MainFrame
MISCFrame.Size = UDim2.new(1, 0, 1, -30)
MISCFrame.Position = UDim2.new(0, 0, 0, 30)
MISCFrame.BackgroundTransparency = 1
MISCFrame.Visible = false

-- ESP Variables
local ESPEnabled = false
local HealthBarEnabled = false
local DistanceEnabled = false
local ESPColor = Color3.fromRGB(255, 255, 255)
local ESPConnections = {}

-- Noclip Variables
local NoclipEnabled = false

-- ESP Functions
local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local function setupESP()
        local Character = player.Character
        if not Character then return end
        
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        local Humanoid = Character:FindFirstChild("Humanoid")
        if not HumanoidRootPart or not Humanoid then return end

        -- Highlight ESP
        local Highlight = Instance.new("Highlight")
        Highlight.Name = "RAGE_ESP"
        Highlight.Parent = Character
        Highlight.Enabled = ESPEnabled
        Highlight.FillColor = ESPColor
        Highlight.OutlineColor = ESPColor
        Highlight.FillTransparency = 0.8

        -- Info Billboard
        local BillboardGui = Instance.new("BillboardGui")
        BillboardGui.Name = "RAGE_INFO"
        BillboardGui.Parent = HumanoidRootPart
        BillboardGui.Size = UDim2.new(0, 200, 0, 50)
        BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
        BillboardGui.AlwaysOnTop = true

        local InfoText = Instance.new("TextLabel")
        InfoText.Name = "InfoText"
        InfoText.Parent = BillboardGui
        InfoText.Size = UDim2.new(1, 0, 1, 0)
        InfoText.BackgroundTransparency = 1
        InfoText.TextColor3 = ESPColor
        InfoText.TextSize = 14
        InfoText.TextStrokeTransparency = 0

        -- Update ESP
        local connection
        connection = RunService.Heartbeat:Connect(function()
            if not Character or not Character.Parent or not HumanoidRootPart or not Humanoid then
                connection:Disconnect()
                Highlight:Destroy()
                BillboardGui:Destroy()
                return
            end

            Highlight.Enabled = ESPEnabled
            
            local info = ""
            if HealthBarEnabled then
                info = "HP: " .. math.floor(Humanoid.Health)
            end
            
            if DistanceEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if info ~= "" then
                    info = info .. " | "
                end
                info = info .. "Dist: " .. math.floor(distance) .. "m"
            end
            
            InfoText.Text = info
            InfoText.Visible = ESPEnabled and (HealthBarEnabled or DistanceEnabled)
        end)
        
        table.insert(ESPConnections, connection)
    end

    -- Wait for character
    if player.Character then
        setupESP()
    end
    
    player.CharacterAdded:Connect(function(character)
        wait(1)
        setupESP()
    end)
end

-- Initialize ESP
for _, player in ipairs(Players:GetPlayers()) do
    CreateESP(player)
end

Players.PlayerAdded:Connect(CreateESP)

-- Noclip Function
local function Noclip()
    if NoclipEnabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end

-- GUI Elements
local yOffset = 10

-- ESP Toggle
local ESPToggle = Instance.new("TextButton")
ESPToggle.Parent = ESPFrame
ESPToggle.Size = UDim2.new(0.9, 0, 0, 30)
ESPToggle.Position = UDim2.new(0.05, 0, 0, yOffset)
ESPToggle.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
ESPToggle.TextColor3 = Color3.fromRGB(0, 0, 0)
ESPToggle.Text = "ESP: OFF"
ESPToggle.TextSize = 14
yOffset = yOffset + 40

ESPToggle.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    ESPToggle.Text = "ESP: " .. (ESPEnabled and "ON" or "OFF")
end)

-- Health Bar Toggle
local HealthToggle = Instance.new("TextButton")
HealthToggle.Parent = ESPFrame
HealthToggle.Size = UDim2.new(0.9, 0, 0, 30)
HealthToggle.Position = UDim2.new(0.05, 0, 0, yOffset)
HealthToggle.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
HealthToggle.TextColor3 = Color3.fromRGB(0, 0, 0)
HealthToggle.Text = "Health Bar: OFF"
HealthToggle.TextSize = 14
yOffset = yOffset + 40

HealthToggle.MouseButton1Click:Connect(function()
    HealthBarEnabled = not HealthBarEnabled
    HealthToggle.Text = "Health Bar: " .. (HealthBarEnabled and "ON" or "OFF")
end)

-- Distance Toggle
local DistanceToggle = Instance.new("TextButton")
DistanceToggle.Parent = ESPFrame
DistanceToggle.Size = UDim2.new(0.9, 0, 0, 30)
DistanceToggle.Position = UDim2.new(0.05, 0, 0, yOffset)
DistanceToggle.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
DistanceToggle.TextColor3 = Color3.fromRGB(0, 0, 0)
DistanceToggle.Text = "Distance: OFF"
DistanceToggle.TextSize = 14
yOffset = yOffset + 40

DistanceToggle.MouseButton1Click:Connect(function()
    DistanceEnabled = not DistanceEnabled
    DistanceToggle.Text = "Distance: " .. (DistanceEnabled and "ON" or "OFF")
end)

-- MISC Elements
local miscYOffset = 10

-- Noclip Toggle
local NoclipToggle = Instance.new("TextButton")
NoclipToggle.Parent = MISCFrame
NoclipToggle.Size = UDim2.new(0.9, 0, 0, 30)
NoclipToggle.Position = UDim2.new(0.05, 0, 0, miscYOffset)
NoclipToggle.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
NoclipToggle.TextColor3 = Color3.fromRGB(0, 0, 0)
NoclipToggle.Text = "Noclip: OFF"
NoclipToggle.TextSize = 14
miscYOffset = miscYOffset + 40

NoclipToggle.MouseButton1Click:Connect(function()
    NoclipEnabled = not NoclipEnabled
    NoclipToggle.Text = "Noclip: " .. (NoclipEnabled and "ON" or "OFF")
end)

-- Tab Buttons
local ESPTabBtn = Instance.new("TextButton")
ESPTabBtn.Parent = MainFrame
ESPTabBtn.Size = UDim2.new(0.5, 0, 0, 25)
ESPTabBtn.Position = UDim2.new(0, 0, 0, 30)
ESPTabBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
ESPTabBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
ESPTabBtn.Text = "ESP"
ESPTabBtn.TextSize = 14

local MISCTabBtn = Instance.new("TextButton")
MISCTabBtn.Parent = MainFrame
MISCTabBtn.Size = UDim2.new(0.5, 0, 0, 25)
MISCTabBtn.Position = UDim2.new(0.5, 0, 0, 30)
MISCTabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 0)
MISCTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MISCTabBtn.Text = "MISC"
MISCTabBtn.TextSize = 14

ESPTabBtn.MouseButton1Click:Connect(function()
    ESPFrame.Visible = true
    MISCFrame.Visible = false
    ESPTabBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    ESPTabBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    MISCTabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 0)
    MISCTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

MISCTabBtn.MouseButton1Click:Connect(function()
    ESPFrame.Visible = false
    MISCFrame.Visible = true
    MISCTabBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    MISCTabBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    ESPTabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 0)
    ESPTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

-- Noclip Loop
RunService.Stepped:Connect(Noclip)

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -20, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Text = "X"
CloseBtn.TextSize = 14

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    for _, conn in ipairs(ESPConnections) do
        conn:Disconnect()
    end
end)
