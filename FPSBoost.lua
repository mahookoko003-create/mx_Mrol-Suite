-- Mxrol FPS Booster
return function(state)
    if state then
        local settings = game:GetService("Lighting")
        settings.GlobalShadows = false
        settings.FogEnd = 9e9
        
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1 -- Tüm resimleri gizle
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            end
        end
    else
        -- Not: FPS Boost kapatıldığında materyalleri geri getirmek için 
        -- oyunu yeniden başlatmak veya karakter yenilemek en sağlıklısıdır.
        print("FPS Boost pasif. Ayarların düzelmesi için karakteri yenileyin.")
    end
end
