-- mx_Mrol Suite V2.0 | Blood Edition TP Tool
local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()

local ToolName = "Mxrol TP"
local ToolConnection = nil

-- Temizlik Fonksiyonu (Kapanınca her şeyi siler)
local function RemoveTool()
    -- Envanterden sil
    if Player.Backpack:FindFirstChild(ToolName) then
        Player.Backpack[ToolName]:Destroy()
    end
    -- Elinden sil (Karakterin içindeyse)
    if Player.Character and Player.Character:FindFirstChild(ToolName) then
        Player.Character[ToolName]:Destroy()
    end
end

return function(state)
    -- Her ihtimale karşı önce temizle (Üst üste binmesin)
    RemoveTool()

    if state then
        -- SENİN KODUNUN ENTEGRE EDİLMİŞ HALİ
        local Tool = Instance.new("Tool")
        Tool.Name = ToolName
        Tool.RequiresHandle = false
        Tool.Parent = Player.Backpack

        -- Işınlanma Fonksiyonu
        Tool.Activated:Connect(function()
            local Pos = Mouse.Hit.p
            local Character = Player.Character
            
            if Character and Character:FindFirstChild("HumanoidRootPart") then
                Character:SetPrimaryPartCFrame(CFrame.new(Pos + Vector3.new(0, 3, 0)))
            end
        end)

        print("Mxrol TP Aktif! Yönetmen, şov başlasın.")
    else
        -- Kapatılınca aleti yok et
        RemoveTool()
        print("Mxrol TP Devre Dışı.")
    end
end
