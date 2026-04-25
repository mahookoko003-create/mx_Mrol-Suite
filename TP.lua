-- mx_Mrol Suite V2.0 | Blood Edition Teleport
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer

local TP_DATA = {
    TargetName = "",
    Mode = "Username" -- "Username" veya "Random"
}

-- Menü Oluşturma
local TP_GUI = Instance.new("ScreenGui", game:GetService("CoreGui"))
TP_GUI.Name = "Mrol_TP_Panel"

local Main = Instance.new("Frame", TP_GUI)
Main.Size = UDim2.new(0, 220, 0, 180)
Main.Position = UDim2.new(0.8, 0, 0.2, 0) -- Diğer panellerle çakışmaması için yukarıda
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
local MCorner = Instance.new("UICorner", Main)
local MStroke = Instance.new("UIStroke", Main)
MStroke.Color = Color3.fromRGB(180, 0, 0)

-- Başlık
local Header = Instance.new("TextLabel", Main)
Header.Size = UDim2.new(1, 0, 0, 35)
Header.Text = "  TELEPORT | <font color='#FF0000'>EXECUTION</font>"
Header.RichText = true
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.Font = Enum.Font.GothamBold
Header.TextSize = 13
Header.BackgroundTransparency = 1
Header.TextXAlignment = Enum.TextXAlignment.Left

local Line1 = Instance.new("Frame", Main)
Line1.Size = UDim2.new(1, -20, 0, 1)
Line1.Position = UDim2.new(0, 10, 0, 35)
Line1.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Line1.BorderSizePixel = 0

-- Username Input
local Input = Instance.new("TextBox", Main)
Input.Size = UDim2.new(1, -20, 0, 30)
Input.Position = UDim2.new(0, 10, 0, 45)
Input.PlaceholderText = "TO | Username"
Input.Text = ""
Input.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Input.TextColor3 = Color3.fromRGB(255, 255, 255)
Input.Font = Enum.Font.Gotham
Instance.new("UICorner", Input)

Input.Focused:Connect(function() TP_DATA.Mode = "Username" end)
Input.FocusLost:Connect(function() TP_DATA.TargetName = Input.Text end)

local Line2 = Instance.new("Frame", Main)
Line2.Size = UDim2.new(1, -20, 0, 1)
Line2.Position = UDim2.new(0, 10, 0, 85)
Line2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Line2.BorderSizePixel = 0

-- Random Seçeneği
local RandomBtn = Instance.new("TextButton", Main)
RandomBtn.Size = UDim2.new(1, -20, 0, 30)
RandomBtn.Position = UDim2.new(0, 10, 0, 95)
RandomBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
RandomBtn.Text = "TO | Random"
RandomBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
RandomBtn.Font = Enum.Font.Gotham
Instance.new("UICorner", RandomBtn)

RandomBtn.MouseButton1Click:Connect(function()
    TP_DATA.Mode = "Random"
    Input.Text = "" -- Random seçilince ismi temizle
    RandomBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    RandomBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
end)

-- Start Button
local StartBtn = Instance.new("TextButton", Main)
StartBtn.Size = UDim2.new(1, -20, 0, 35)
StartBtn.Position = UDim2.new(0, 10, 1, -45)
StartBtn.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
StartBtn.Text = "EXECUTE TELEPORT"
StartBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
StartBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", StartBtn)

-- Işınlanma Fonksiyonu
local function TeleportAction()
    local targetChar = nil
    
    if TP_DATA.Mode == "Username" and TP_DATA.TargetName ~= "" then
        for _, p in pairs(players:GetPlayers()) do
            if p.Name:lower():find(TP_DATA.TargetName:lower()) or p.DisplayName:lower():find(TP_DATA.TargetName:lower()) then
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    targetChar = p.Character
                    break
                end
            end
        end
    elseif TP_DATA.Mode == "Random" then
        local otherPlayers = {}
        for _, p in pairs(players:GetPlayers()) do
            if p ~= localPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(otherPlayers, p)
            end
        end
        if #otherPlayers > 0 then
            targetChar = otherPlayers[math.random(1, #otherPlayers)].Character
        end
    end

    if targetChar and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPos = targetChar.HumanoidRootPart.CFrame
        -- Direkt üzerine değil, 3 birim önüne ışınla (Execution için hazır pozisyon)
        localPlayer.Character.HumanoidRootPart.CFrame = targetPos * CFrame.new(0, 0, 3)
    end
end

StartBtn.MouseButton1Click:Connect(TeleportAction)

-- Kapatma (Ana Menü Kontrolü)
return function(state)
    if not state then
        TP_GUI:Destroy()
    end
end
