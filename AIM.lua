-- mx_Mrol Suite V2.0 | Blood Edition Aimbot
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")

local Aimbot = {
    Active = false,
    TargetName = "",
    Connection = nil
}

-- Menü Oluşturma
local AIM_GUI = Instance.new("ScreenGui", game:GetService("CoreGui"))
AIM_GUI.Name = "Mrol_Aimbot_Panel"

local Main = Instance.new("Frame", AIM_GUI)
Main.Size = UDim2.new(0, 220, 0, 150)
Main.Position = UDim2.new(0.8, 0, 0.5, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10) -- Daha Dark
local MCorner = Instance.new("UICorner", Main)
local MStroke = Instance.new("UIStroke", Main)
MStroke.Color = Color3.fromRGB(180, 0, 0) -- Kan Kırmızısı Kenarlık

-- Başlık
local Header = Instance.new("TextLabel", Main)
Header.Size = UDim2.new(1, 0, 0, 30)
Header.Text = "  AIMBOT | <font color='#FF0000'>EXECUTION</font>"
Header.RichText = true
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.Font = Enum.Font.GothamBold
Header.TextSize = 13
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.BackgroundTransparency = 1

-- Kapatma Fonksiyonu (Tam Temizlik)
local function DestroyAimbot()
    Aimbot.Active = false
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
Input.Text = ""
Input.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Input.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", Input)
Input.FocusLost:Connect(function() Aimbot.TargetName = Input.Text end)

-- Start/Stop Butonu
local ActionBtn = Instance.new("TextButton", Main)
ActionBtn.Size = UDim2.new(1, -20, 0, 40)
ActionBtn.Position = UDim2.new(0, 10, 0, 85)
ActionBtn.BackgroundColor3 = Color3.fromRGB(25, 5, 5)
ActionBtn.Text = "START"
ActionBtn.TextColor3 = Color3.fromRGB(180, 0, 0) -- Kan Kırmızısı Yazı
ActionBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ActionBtn)

local function GetClosest()
    local closest = nil
    local maxDist = math.huge
    for _, p in pairs(players:GetPlayers()) do
        if p ~= localPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local pos, onScreen = camera:WorldToViewportPoint(p.Character.Head.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                if dist < maxDist then
                    maxDist = dist
                    closest = p
                end
            end
        end
    end
    return closest
end

local function ToggleAimbot()
    Aimbot.Active = not Aimbot.Active
    ActionBtn.Text = Aimbot.Active and "STOP" or "START"
    ActionBtn.TextColor3 = Aimbot.Active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 0, 0)
    ActionBtn.BackgroundColor3 = Aimbot.Active and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(25, 5, 5)
    
    if Aimbot.Active then
        Aimbot.Connection = runService.RenderStepped:Connect(function()
            local target = nil
            if Aimbot.TargetName ~= "" then
                for _, p in pairs(players:GetPlayers()) do
                    if p.Name:lower():find(Aimbot.TargetName:lower()) or p.DisplayName:lower():find(Aimbot.TargetName:lower()) then
                        target = p
                        break
                    end
                end
            else
                target = GetClosest()
            end
            
            if target and target.Character and target.Character:FindFirstChild("Head") then
                camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.Head.Position)
            end
        end)
    else
        if Aimbot.Connection then Aimbot.Connection:Disconnect() end
    end
end

ActionBtn.MouseButton1Click:Connect(ToggleAimbot)

-- [ÖNEMLİ] Ana Menüden Kapatma Kontrolü
return function(state)
    if not state then
        DestroyAimbot()
    end
end
