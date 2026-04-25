-- mx_Mrol Suite V2.1 | Blood Edition Aimbot & Hitbox (FIXED)
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
    HitboxSize = 5
}

-- Menü Oluşturma
local AIM_GUI = Instance.new("ScreenGui", game:GetService("CoreGui"))
AIM_GUI.Name = "Mrol_Aimbot_Panel"

local Main = Instance.new("Frame", AIM_GUI)
Main.Size = UDim2.new(0, 220, 0, 230)
Main.Position = UDim2.new(0.8, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", Main)
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

local function DestroyAimbot()
    Aimbot.Active = false
    Aimbot.HitboxActive = false
    AIM_GUI:Destroy()
end

local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 20, 0, 20)
Close.Position = UDim2.new(1, -25, 0, 5)
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 0, 0)
Close.BackgroundTransparency = 1
Close.MouseButton1Click:Connect(DestroyAimbot)

local Input = Instance.new("TextBox", Main)
Input.Size = UDim2.new(1, -20, 0, 30)
Input.Position = UDim2.new(0, 10, 0, 40)
Input.PlaceholderText = "Kullanıcı Adı..."
Input.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Input.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", Input)
Input.FocusLost:Connect(function() Aimbot.TargetName = Input.Text end)

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

local HitBtn = Instance.new("TextButton", Main)
HitBtn.Size = UDim2.new(1, -20, 0, 30)
HitBtn.Position = UDim2.new(0, 10, 0, 110)
HitBtn.BackgroundColor3 = Color3.fromRGB(25, 5, 5)
HitBtn.Text = "HITBOX: OFF"
HitBtn.TextColor3 = Color3.fromRGB(180, 0, 0)
Instance.new("UICorner", HitBtn)

local ActionBtn = Instance.new("TextButton", Main)
ActionBtn.Size = UDim2.new(1, -20, 0, 40)
ActionBtn.Position = UDim2.new(0, 10, 0, 175)
ActionBtn.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
ActionBtn.Text = "START AIM"
ActionBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
ActionBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ActionBtn)

-- [DÜZELTME] Duvar Kontrolü (Wall Check)
local function IsVisible(targetPart)
    local char = localPlayer.Character
    if not char then return false end
    local ignoreList = {char, camera}
    local ray = Ray.new(camera.CFrame.Position, (targetPart.Position - camera.CFrame.Position).Unit * 500)
    local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
    if hit and hit:IsDescendantOf(targetPart.Parent) then
        return true
    end
    return false
end

-- [DÜZELTME] Akıllı Hedefleme (Öncelik: Görünürlük > Mesafe)
local function GetTarget()
    local closestVisible, distVisible = nil, math.huge
    local closestHidden, distHidden = nil, math.huge

    for _, p in pairs(players:GetPlayers()) do
        if p ~= localPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            if Aimbot.SelectedTeam and p.Team ~= Aimbot.SelectedTeam then continue end
            if Aimbot.TargetName ~= "" and not (p.Name:lower():find(Aimbot.TargetName:lower()) or p.DisplayName:lower():find(Aimbot.TargetName:lower())) then continue end
            
            local d = (camera.CFrame.Position - p.Character.Head.Position).Magnitude
            
            if IsVisible(p.Character.Head) then
                if d < distVisible then distVisible = d; closestVisible = p end
            else
                if d < distHidden then distHidden = d; closestHidden = p end
            end
        end
    end
    -- Öncelik açıkta olanda, yoksa en yakındakine bak
    return closestVisible or closestHidden
end

-- Ana Döngü
runService.RenderStepped:Connect(function()
    -- Hitbox Uygulama (Geliştirildi: Her karede zorlar)
    for _, p in pairs(players:GetPlayers()) do
        if p ~= localPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local isTarget = Aimbot.HitboxActive
            if isTarget then
                if Aimbot.SelectedTeam and p.Team ~= Aimbot.SelectedTeam then isTarget = false end
                if Aimbot.TargetName ~= "" and not (p.Name:lower():find(Aimbot.TargetName:lower()) or p.DisplayName:lower():find(Aimbot.TargetName:lower())) then isTarget = false end
            end

            if isTarget then
                p.Character.Head.Size = Vector3.new(Aimbot.HitboxSize, Aimbot.HitboxSize, Aimbot.HitboxSize)
                p.Character.Head.Transparency = 0.6
                p.Character.Head.CanCollide = false
            else
                -- Hitbox kapalıyken veya hedef değilken orijinal boyuta döndür
                p.Character.Head.Size = Vector3.new(1.15, 1.15, 1.15) -- Standart R6/R15 kafa boyutu
                p.Character.Head.Transparency = 0
            end
        end
    end

    -- Aimbot Uygulama
    if Aimbot.Active then
        local target = GetTarget()
        if target and target.Character:FindFirstChild("Head") then
            -- Sadece hedef görünürse kilitlenmeyi daha sert yap
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

HitBtn.MouseButton1Click:Connect(function()
    Aimbot.HitboxActive = not Aimbot.HitboxActive
    HitBtn.Text = Aimbot.HitboxActive and "HITBOX: ON" or "HITBOX: OFF"
    HitBtn.TextColor3 = Aimbot.HitboxActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 0, 0)
    HitBtn.BackgroundColor3 = Aimbot.HitboxActive and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(25, 5, 5)
end)

ActionBtn.MouseButton1Click:Connect(function()
    Aimbot.Active = not Aimbot.Active
    ActionBtn.Text = Aimbot.Active and "STOP AIM" or "START AIM"
    ActionBtn.BackgroundColor3 = Aimbot.Active and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(30, 0, 0)
end)

return function(state)
    if not state then DestroyAimbot() end
end
