-- mx_Mrol Suite V2.0 | Blood Edition Click TP
local players = game:GetService("Players")
local userInput = game:GetService("UserInputService")
local localPlayer = players.LocalPlayer
local mouse = localPlayer:GetMouse()

local ClickTP_Data = {
    Active = false,
    Connection = nil
}

local function ExecuteTP()
    -- Sadece sol CTRL tuşu basılıyken çalışır
    if ClickTP_Data.Active and userInput:IsKeyDown(Enum.KeyCode.LeftControl) then
        local char = localPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        if root and mouse.Hit then
            -- Hedefin 3 birim yukarısına ışınla (yere gömülmemek için)
            root.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end

-- Modül Fonksiyonu
return function(state)
    ClickTP_Data.Active = state
    
    -- Bağlantıyı Temizle
    if ClickTP_Data.Connection then
        ClickTP_Data.Connection:Disconnect()
        ClickTP_Data.Connection = nil
    end
    
    if state then
        -- Fare tıklandığında kontrol et
        ClickTP_Data.Connection = mouse.Button1Down:Connect(ExecuteTP)
    end
end
