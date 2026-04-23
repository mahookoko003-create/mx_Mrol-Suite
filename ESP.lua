-- mx_Mrol Suite V2.0 | Blood Edition ESP
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")

local ESP_Data = {
    Active = false,
    Objects = {}
}

-- ESP Temizlik Fonksiyonu (Çizgileri ve Kareleri Siler)
local function ClearESP()
    for _, obj in pairs(ESP_Data.Objects) do
        if obj.Box then obj.Box:Remove() end
        if obj.Line then obj.Line:Remove() end
        if obj.Name then obj.Name:Remove() end
    end
    ESP_Data.Objects = {}
end

-- Görsel Oluşturma (Renkler Kan Kırmızısı Yapıldı)
local function CreateVisuals(plr)
    local visuals = {
        Box = Drawing.new("Square"),
        Line = Drawing.new("Line"),
        Name = Drawing.new("Text")
    }
    
    -- Kan Kırmızısı Ayarları
    visuals.Box.Color = Color3.fromRGB(180, 0, 0)
    visuals.Box.Thickness = 1.5
    visuals.Box.Filled = false
    
    visuals.Line.Color = Color3.fromRGB(180, 0, 0)
    visuals.Line.Thickness = 1
    visuals.Line.Transparency = 0.6
    
    visuals.Name.Color = Color3.fromRGB(255, 255, 255) -- İsim beyaz kalsın (daha okunaklı)
    visuals.Name.Size = 14
    visuals.Name.Center = true
    visuals.Name.Outline = true
    
    ESP_Data.Objects[plr] = visuals
end

return function(state)
    -- Global kontrol ve yerel state güncelleme
    ESP_Data.Active = state
    _G.Mrol_ESP_Running = state 

    if not state then
        ClearESP()
        return
    end

    -- Döngü Başlat
    task.spawn(function()
        -- Hem state hem de global değişken üzerinden kontrol (Çift emniyet)
        while ESP_Data.Active and _G.Mrol_ESP_Running do
            for _, plr in pairs(players:GetPlayers()) do
                if plr ~= localPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    if not ESP_Data.Objects[plr] then CreateVisuals(plr) end
                    
                    local visuals = ESP_Data.Objects[plr]
                    local root = plr.Character.HumanoidRootPart
                    local pos, onScreen = camera:WorldToViewportPoint(root.Position)
                    
                    if onScreen then
                        local size = (camera:WorldToViewportPoint(root.Position + Vector3.new(0, 3, 0)).Y - camera:WorldToViewportPoint(root.Position + Vector3.new(0, -3.5, 0)).Y)
                        
                        visuals.Box.Size = Vector2.new(size / 1.5, size)
                        visuals.Box.Position = Vector2.new(pos.X - visuals.Box.Size.X / 2, pos.Y - visuals.Box.Size.Y / 2)
                        visuals.Box.Visible = true
                        
                        visuals.Name.Text = plr.DisplayName .. " (@" .. plr.Name .. ")"
                        visuals.Name.Position = Vector2.new(pos.X, pos.Y - (size / 2) - 20)
                        visuals.Name.Visible = true
                        
                        visuals.Line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                        visuals.Line.To = Vector2.new(pos.X, pos.Y + (size / 2))
                        visuals.Line.Visible = true
                    else
                        visuals.Box.Visible = false
                        visuals.Name.Visible = false
                        visuals.Line.Visible = false
                    end
                elseif ESP_Data.Objects[plr] then
                    for _, v in pairs(ESP_Data.Objects[plr]) do v.Visible = false end
                end
            end
            runService.RenderStepped:Wait()
        end
        -- Döngü kırıldığında (Toggle OFF yapıldığında) temizlik yap
        ClearESP()
    end)
end
