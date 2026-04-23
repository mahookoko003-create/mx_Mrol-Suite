-- mx_Mrol Suite V2.0 | Advanced Aimbot Module
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
Main.Position = UDim2.new(0.8, 0, 0.5, 0) -- Sağ tarafta açılır
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
local MCorner = Instance.new("UICorner", Main)
local MStroke = Instance.new("UIStroke", Main)
MStroke.Color = Color3.fromRGB(0, 240, 255)

-- Başlık & X
local Header = Instance.new("TextLabel", Main)
Header.Size = UDim2.new(1, 0, 0, 30)
Header.Text = "  AIMBOT | MAHOMOUS"
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.Font = Enum.Font.GothamBold
Header.TextSize = 13
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.BackgroundTransparency = 1

local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 20, 0, 20)
Close.Position = UDim2.new(1, -25, 0, 5)
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 80, 80)
Close.BackgroundTransparency = 1
Close.MouseButton1Click:Connect(function() AIM_GUI:Destroy() Aimbot.Active = false end)

-- TextBox (Kullanıcı Adı)
local Input = Instance.new("TextBox", Main)
Input.Size = UDim2.new(1, -20, 0, 30)
Input.Position = UDim2.new(0, 10, 0, 40)
Input.PlaceholderText = "Kullanıcı Adı Gir..."
Input.Text = ""
Input.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Input.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", Input)
Input.FocusLost:Connect(function() Aimbot.TargetName = Input.Text end)

-- Start/Stop Butonu
local ActionBtn = Instance.new("TextButton", Main)
ActionBtn.Size = UDim2.new(1, -20, 0, 40)
ActionBtn.Position = UDim2.new(0, 10, 0, 85)
ActionBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
ActionBtn.Text = "START"
ActionBtn.TextColor3 = Color3.fromRGB(0, 240, 255)
ActionBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ActionBtn)

-- En Yakın Oyuncuyu Bulma Fonksiyonu
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

-- Aimbot Döngüsü
local function ToggleAimbot()
    Aimbot.Active = not Aimbot.Active
    ActionBtn.Text = Aimbot.Active and "STOP" or "START"
    ActionBtn.TextColor3 = Aimbot.Active and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(0, 240, 255)
    
    if Aimbot.Active then
        Aimbot.Connection = runService.RenderStepped:Connect(function()
            local target = nil
            
            if Aimbot.TargetName ~= "" then
                -- Özel Hedef Kilitlenme
                for _, p in pairs(players:GetPlayers()) do
                    if p.Name:lower():find(Aimbot.TargetName:lower()) or p.DisplayName:lower():find(Aimbot.TargetName:lower()) then
                        target = p
                        break
                    end
                end
            else
                -- En Yakın Hedef Kilitlenme
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
