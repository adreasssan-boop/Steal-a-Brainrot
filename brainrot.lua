-- RAGE MOD Steal a brainrot Cheat
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- GUI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/uwuware-ui/main/main.lua"))()
local Window = Library:CreateWindow("RAGE MOD")
local ESPTab = Window:AddTab("ESP")
local MISCTab = Window:AddTab("MISC")

-- ESP Variables
local ESPEnabled = false
local BoxESP = false
local HealthBar = false
local Distance = false
local ESPColor = Color3.fromRGB(255, 255, 255)

-- Noclip Variables
local NoclipEnabled = false
local NoclipConnection

-- ESP Functions
local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local Character = player.Character
    if not Character then return end
    
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character:FindFirstChild("Humanoid")
    if not HumanoidRootPart or not Humanoid then return end

    -- Highlight for ESP
    local Highlight = Instance.new("Highlight")
    Highlight.Name = "RAGE_ESP"
    Highlight.Parent = Character
    Highlight.Enabled = ESPEnabled
    Highlight.FillColor = ESPColor
    Highlight.OutlineColor = ESPColor
    Highlight.FillTransparency = 0.8
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    -- Billboard GUI for Info
    local BillboardGui = Instance.new("BillboardGui")
    BillboardGui.Name = "RAGE_INFO"
    BillboardGui.Parent = HumanoidRootPart
    BillboardGui.Size = UDim2.new(0, 200, 0, 100)
    BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
    BillboardGui.AlwaysOnTop = true

    local HealthText = Instance.new("TextLabel")
    HealthText.Name = "HealthText"
    HealthText.Parent = BillboardGui
    HealthText.Size = UDim2.new(1, 0, 0.5, 0)
    HealthText.Position = UDim2.new(0, 0, 0, 0)
    HealthText.BackgroundTransparency = 1
    HealthText.TextColor3 = ESPColor
    HealthText.TextSize = 14
    HealthText.TextStrokeTransparency = 0

    local DistanceText = Instance.new("TextLabel")
    DistanceText.Name = "DistanceText"
    DistanceText.Parent = BillboardGui
    DistanceText.Size = UDim2.new(1, 0, 0.5, 0)
    DistanceText.Position = UDim2.new(0, 0, 0.5, 0)
    DistanceText.BackgroundTransparency = 1
    DistanceText.TextColor3 = ESPColor
    DistanceText.TextSize = 14
    DistanceText.TextStrokeTransparency = 0

    -- Update function
    local function UpdateESP()
        if not Character or not HumanoidRootPart or not Humanoid then
            Highlight:Destroy()
            BillboardGui:Destroy()
            return
        end

        local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) 
            and (HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude 
            or 0

        Highlight.Enabled = ESPEnabled
        
        if HealthBar then
            HealthText.Visible = true
            HealthText.Text = "HP: " .. math.floor(Humanoid.Health) .. "/" .. math.floor(Humanoid.MaxHealth)
        else
            HealthText.Visible = false
        end

        if Distance then
            DistanceText.Visible = true
            DistanceText.Text = "Dist: " .. math.floor(distance) .. "m"
        else
            DistanceText.Visible = false
        end
    end

    -- ESP Connection
    local ESPConnection
    ESPConnection = RunService.Heartbeat:Connect(function()
        if not Character or not Character.Parent then
            ESPConnection:Disconnect()
            Highlight:Destroy()
            BillboardGui:Destroy()
            return
        end
        UpdateESP()
    end)
end

-- Initialize ESP for existing players
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

-- ESP for new players
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1)
        CreateESP(player)
    end)
end)

-- Noclip Function
local function Noclip()
    if NoclipEnabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end

-- Toggle Noclip
NoclipConnection = RunService.Stepped:Connect(Noclip)

-- GUI Elements
ESPTab:AddToggle("ESP", {
    location = _G,
    flag = "ESP_Toggle",
    callback = function(value)
        ESPEnabled = value
    end
})

ESPTab:AddToggle("Health Bar", {
    location = _G,
    flag = "Health_Toggle",
    callback = function(value)
        HealthBar = value
    end
})

ESPTab:AddToggle("Distance", {
    location = _G,
    flag = "Distance_Toggle", 
    callback = function(value)
        Distance = value
    end
})

MISCTab:AddToggle("Noclip", {
    location = _G,
    flag = "Noclip_Toggle",
    callback = function(value)
        NoclipEnabled = value
    end
})

-- Theme
Library:SetColor(Color3.fromRGB(255, 215, 0)) -- Dark yellow theme

Library:Init()
