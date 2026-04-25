-- mx_Mrol Suite V2.0 | Blood Edition NoClip
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer

local noclipActive = true -- Loadstring yapıldığında direkt çalışır

local noclipConnection
noclipConnection = runService.Stepped:Connect(function()
    if noclipActive then
        if localPlayer.Character then
            for _, part in pairs(localPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide == true then
                    part.CanCollide = false
                end
            end
        end
    else
        -- Bağlantıyı kopar ve temizle
        noclipConnection:Disconnect()
    end
end)

-- Kapatma fonksiyonu (Menüden çağırmak istersen)
return function(state)
    noclipActive = state
end
