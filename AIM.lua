-- mx_Mrol Suite V2.0 | Blood Edition Aimbot & Hitbox
local players = game:GetService("Players")
local teams = game:GetService("Teams")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")

local Aimbot = {
    Active = false,
    HitboxActive = false,
    TargetName = "",
    SelectedTeam = nil,
    Connection = nil,
    HitboxSize = 5 -- Kafanın büyüklüğü (Normali 1'dir)
}

-- Menü Oluşturma
local AIM_GUI = Instance.new("ScreenGui", game:GetService("CoreGui"))
AIM_GUI.Name = "Mrol_Aimbot_Panel"

local Main = Instance.new("Frame", AIM_GUI)
Main.Size = UDim2.new(0, 220, 0, 230) -- Boyut biraz daha büyüdü
Main.Position = UDim2.new(0.8, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
local MCorner = Instance.new("UICorner", Main)
local MStroke = Instance.new("UIStroke", Main)
MStroke.Color = Color3.fromRGB(180, 0, 0)

-- Başlık
local Header = Instance.new("TextLabel", Main)
Header.Size = UDim2.new(1, 0, 0, 30)
Header.Text = "  AIM & HITBOX | <font color='#FF0000'>EXECUTION</font>"
Header.RichText = true
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.Font = Enum.Font.GothamBold
Header.TextSize = 12
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.BackgroundTransparency = 1

-- Kapatma (Tam Temizlik)
local function DestroyAimbot()
    Aimbot.Active = false
    Aimbot.HitboxActive = false
    if Aimbot.Connection then Aimbot.Connection:Disconnect() end
    AIM_GUI:Destroy()
end

local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 20, 0, 20)
Close.Position = UDim2.new(1, -25, 0, 5)
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 0, 0)
Close.BackgroundTransparency = 1
Close.MouseButton1Click:Connect(DestroyAimbot)

-- TextBox
local Input = Instance.new("TextBox", Main)
Input.Size = UDim2.new(1, -20, 0, 30)
Input.Position = UDim2.new(0, 10, 0, 40)
Input.PlaceholderText = "Kullanıcı Adı..."
Input.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Input.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", Input)
Input.FocusLost:Connect(function() Aimbot.TargetName = Input.Text end)

-- [YENİ] Team Selector
local TeamBtn = Instance.new("TextButton", Main)
TeamBtn.Size = UDim2.new(1, -20, 0, 30)
TeamBtn.Position = UDim2.new(0, 10, 0, 75)
TeamBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TeamBtn.Text = "TEAM: ALL"
TeamBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
Instance.new("UICorner", TeamBtn)

TeamBtn.MouseButton1Click:Connect(function()
    local t = teams:GetTeams()
    if #t == 0 then return end
    if Aimbot.SelectedTeam == nil then Aimbot.SelectedTeam = t[1]
    else
        local idx = table.find(t, Aimbot.SelectedTeam)
        Aimbot.SelectedTeam = (idx and idx < #t) and t[idx+1] or nil
    end
    TeamBtn.Text = Aimbot.SelectedTeam and "TEAM: "..Aimbot.SelectedTeam.Name:upper() or "TEAM: ALL"
end)

-- [YENİ] Hitbox Toggle
local HitBtn = Instance.new("TextButton", Main)
HitBtn.Size = UDim2.new(1, -20, 0, 30)
HitBtn.Position = UDim2.new(0, 10, 0, 110)
HitBtn.BackgroundColor3 = Color3.fromRGB(25, 5, 5)
HitBtn.Text = "HITBOX: OFF"
HitBtn.TextColor3 = Color3.fromRGB(180, 0, 0)
Instance.new("UICorner", HitBtn)

HitBtn.MouseButton1Click:Connect(function()
    Aimbot.HitboxActive = not Aimbot.HitboxActive
    HitBtn.Text = Aimbot.HitboxActive and "HITBOX: ON" or "HITBOX: OFF"
    HitBtn.TextColor3 = Aimbot.HitboxActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 0, 0)
    HitBtn.BackgroundColor3 = Aimbot.HitboxActive and Color3.fromRGB(120, 0, 0) or Color3.fromRGB(25, 5, 5)
end)

-- Start/Stop Aimbot
local ActionBtn = Instance.new("TextButton", Main)
ActionBtn.Size = UDim2.new(1, -20, 0, 40)
ActionBtn.Position = UDim2.new(0, 10, 0, 175)
ActionBtn.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
ActionBtn.Text = "START AIM"
ActionBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
ActionBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ActionBtn)

-- Fonksiyonlar (Targeting & Hitbox)
local function GetTarget()
    local closest, dist = nil, math.huge
    for _, p in pairs(players:GetPlayers()) do
        if p ~= localPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            if Aimbot.SelectedTeam and p.Team ~= Aimbot.SelectedTeam then continue end
            if Aimbot.TargetName ~= "" and not (p.Name:lower():find(Aimbot.TargetName:lower()) or p.DisplayName:lower():find(Aimbot.TargetName:lower())) then continue end
            
            local d = (localPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then dist = d closest = p end
        end
    end
    return closest
end

-- Ana Döngü (Hem Aimbot hem Hitbox aynı döngüde)
runService.RenderStepped:Connect(function()
    -- 1. Hitbox Mantığı
    if Aimbot.HitboxActive then
        for _, p in pairs(players:GetPlayers()) do
            if p ~= localPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local isTarget = true
                if Aimbot.SelectedTeam and p.Team ~= Aimbot.SelectedTeam then isTarget = false end
                if Aimbot.TargetName ~= "" and not (p.Name:lower():find(Aimbot.TargetName:lower()) or p.DisplayName:lower():find(Aimbot.TargetName:lower())) then isTarget = false end
                
                if isTarget then
                    p.Character.Head.Size = Vector3.new(Aimbot.HitboxSize, Aimbot.HitboxSize, Aimbot.HitboxSize)
                    p.Character.Head.Transparency = 0.5
                    p.Character.Head.CanCollide = false
                else
                    p.Character.Head.Size = Vector3.new(1, 1, 1)
                    p.Character.Head.Transparency = 0
                end
            end
        end
    end

    -- 2. Aimbot Mantığı
    if Aimbot.Active then
        local target = GetTarget()
        if target and target.Character:FindFirstChild("Head") then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

ActionBtn.MouseButton1Click:Connect(function()
    Aimbot.Active = not Aimbot.Active
    ActionBtn.Text = Aimbot.Active and "STOP AIM" or "START AIM"
end)

return function(state)
    if not state then DestroyAimbot() end
end
