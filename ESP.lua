-- mx_Mrol Suite V2.0 | Advanced ESP Module
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")

local ESP_Data = {
    Active = false,
    Objects = {}
}

-- ESP Temizlik Fonksiyonu
local function ClearESP()
    for _, obj in pairs(ESP_Data.Objects) do
        for _, visual in pairs(obj) do
            visual:Remove()
        end
    end
    ESP_Data.Objects = {}
end

-- Görsel Oluşturma (Box, Line, Text)
local function CreateVisuals(plr)
    local visuals = {
        Box = Drawing.new("Square"),
        Line = Drawing.new("Line"),
        Name = Drawing.new("Text")
    }
    
    visuals.Box.Color = Color3.fromRGB(0, 240, 255)
    visuals.Box.Thickness = 1.5
    visuals.Box.Filled = false
    
    visuals.Line.Color = Color3.fromRGB(0, 240, 255)
    visuals.Line.Thickness = 1
    visuals.Line.Transparency = 0.6
    
    visuals.Name.Color = Color3.fromRGB(255, 255, 255)
    visuals.Name.Size = 16
    visuals.Name.Center = true
    visuals.Name.Outline = true
    
    ESP_Data.Objects[plr] = visuals
end

return function(state)
    ESP_Data.Active = state
    
    if not state then
        ClearESP()
        return
    end

    -- Döngü Başlat
    task.spawn(function()
        while ESP_Data.Active do
            for _, plr in pairs(players:GetPlayers()) do
                if plr ~= localPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    if not ESP_Data.Objects[plr] then CreateVisuals(plr) end
                    
                    local visuals = ESP_Data.Objects[plr]
                    local root = plr.Character.HumanoidRootPart
                    local pos, onScreen = camera:WorldToViewportPoint(root.Position)
                    
                    if onScreen then
                        -- Kare (Box) Ayarları
                        local size = (camera:WorldToViewportPoint(root.Position + Vector3.new(0, 3, 0)).Y - camera:WorldToViewportPoint(root.Position + Vector3.new(0, -3.5, 0)).Y)
                        visuals.Box.Size = Vector2.new(size / 1.5, size)
                        visuals.Box.Position = Vector2.new(pos.X - visuals.Box.Size.X / 2, pos.Y - visuals.Box.Size.Y / 2)
                        visuals.Box.Visible = true
                        
                        -- İsim (Name | DisplayName)
                        visuals.Name.Text = plr.DisplayName .. " (@" .. plr.Name .. ")"
                        visuals.Name.Position = Vector2.new(pos.X, pos.Y - (size / 2) - 20)
                        visuals.Name.Visible = true
                        
                        -- İz Çizgisi (Tracer / İp)
                        visuals.Line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y) -- Ekranın alt ortasından başlar
                        visuals.Line.To = Vector2.new(pos.X, pos.Y + (size / 2))
                        visuals.Line.Visible = true
                    else
                        visuals.Box.Visible = false
                        visuals.Name.Visible = false
                        visuals.Line.Visible = false
                    end
                elseif ESP_Data.Objects[plr] then
                    -- Karakter yoksa gizle
                    for _, v in pairs(ESP_Data.Objects[plr]) do v.Visible = false end
                end
            end
            runService.RenderStepped:Wait()
        end
        ClearESP()
    end)
end
