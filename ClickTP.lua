-- mx_Mrol Suite V2.0 | Blood Edition TP Tool
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local mouse = localPlayer:GetMouse()

local TP_Tool_Data = {
    ToolName = "Mxrol TP",
    ToolInstance = nil
}

-- Temizlik Fonksiyonu (Silme)
local function CleanupTool()
    if TP_Tool_Data.ToolInstance then
        TP_Tool_Data.ToolInstance:Destroy()
        TP_Tool_Data.ToolInstance = nil
    end
    -- Karakterin elindeyse de sil
    local toolInChar = localPlayer.Character and localPlayer.Character:FindFirstChild(TP_Tool_Data.ToolName)
    if toolInChar then toolInChar:Destroy() end
    
    -- Envanterde kalmışsa sil
    local toolInBackpack = localPlayer.Backpack:FindFirstChild(TP_Tool_Data.ToolName)
    if toolInBackpack then toolInBackpack:Destroy() end
end

return function(state)
    -- Önce mevcut her şeyi temizle (Üst üste binmesin)
    CleanupTool()

    if state then
        -- Yeni Tool Oluştur
        local tool = Instance.new("Tool")
        tool.Name = TP_Tool_Data.ToolName
        tool.RequiresHandle = false -- Tutacak parça gerekmez, direkt çalışır
        tool.CanBeDropped = false
        
        -- Tool Seçiliyken Tıklama Olayı
        tool.Activated:Connect(function()
            local char = localPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            
            if root and mouse.Hit then
                -- Kan kırmızısı bir efekt istersen (isteğe bağlı) buraya eklenebilir
                root.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
            end
        end)
        
        tool.Parent = localPlayer.Backpack
        TP_Tool_Data.ToolInstance = tool
    else
        -- Kapandığında her yerden sil
        CleanupTool()
    end
end
