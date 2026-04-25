-- Mxrol Speed Hack
local Player = game.Players.LocalPlayer
local TargetSpeed = 100 -- Burayı istediğin hıza ayarla

return function(state)
    _G.SpeedActive = state
    
    task.spawn(function()
        while _G.SpeedActive do
            local char = Player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = TargetSpeed
            end
            task.wait(0.1) -- Oyunun hızı geri düşürmesini engellemek için sürekli tetikle
        end
        -- Kapandığında hızı normale döndür
        local char = Player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end)
end
