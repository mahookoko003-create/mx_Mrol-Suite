-- mx_Mrol Suite V2.3 | Item Hunter Edition
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- BURAYA YENİ ŞEYLER EKLEMEK ÇOK KOLAY:
-- Sadece tırnak içinde ismini yaz ve virgül koy.
local TargetItems = {
    "Fuel",
    "Berry Bush",
    "Gasoline", -- Örnek ekleme
    "Water Bottle" -- Örnek ekleme
}

local function CreateVisuals(obj)
    -- Zaten işaretlenmişse pas geç
    if obj:FindFirstChild("Mxrol_Hunter_HL") then return end

    -- Parlama Efekti (Sarı Altın Rengi)
    local hl = Instance.new("Highlight")
    hl.Name = "Mxrol_Hunter_HL"
    hl.FillColor = Color3.fromRGB(255, 215, 0) 
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillAlpha = 0.4
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = obj

    -- İsim Etiketi (Tepesinde yazar)
    local billboard = Instance.new("BillboardGui", obj)
    billboard.Name = "Mxrol_Label"
    billboard.Size = UDim2.new(0, 150, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.ExtentsOffset = Vector3.new(0, 4, 0) -- Yazıyı biraz yukarı kaldırır

    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "★ " .. obj.Name:upper() .. " ★"
    label.TextColor3 = Color3.fromRGB(255, 215, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextStrokeTransparency = 0
end

local function CheckAndApply(obj)
    for _, targetName in pairs(TargetItems) do
        -- İsim tam eşleşmese bile içinde geçiyorsa yakalar (Örn: "Fuel Can")
        if obj.Name:find(targetName) then
            CreateVisuals(obj)
            break
        end
    end
end

-- Tüm haritayı bir kez tara
local function FullScan()
    for _, v in pairs(Workspace:GetDescendants()) do
        CheckAndApply(v)
    end
end

return function(state)
    _G.HunterActive = state

    if state then
        -- 1. Mevcutları bul
        FullScan()

        -- 2. Yeni doğanları (Spawn) takip et
        _G.HunterConnection = Workspace.DescendantAdded:Connect(function(newObj)
            -- Objelerin tam yüklenmesi için kısa bir bekleme
            task.wait(0.5)
            if _G.HunterActive then
                CheckAndApply(newObj)
            end
        end)
        
        print("Item Hunter: AKTİF. Hedefler izleniyor...")
    else
        -- Temizlik
        if _G.HunterConnection then _G.HunterConnection:Disconnect() end
        for _, v in pairs(Workspace:GetDescendants()) do
            if v.Name == "Mxrol_Hunter_HL" or v.Name == "Mxrol_Label" then
                v:Destroy()
            end
        end
        print("Item Hunter: KAPALI.")
    end
end
