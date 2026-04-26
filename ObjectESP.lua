-- [[ mx_Mrol | ULTIMATE ITEM HUNTER - V5.5 MULTI ]] --
-- "Çoklu hedef, tek merkez."

local ItemHunter = {
    Active = false,
    Targets = {}, -- Artık TextBox'tan besleniyor
    Connection = nil
}

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- UI ANA PANEL
local HG = Instance.new("ScreenGui", CoreGui)
HG.Name = "Mrol_Elite_Hunter"

local Main = Instance.new("Frame", HG)
Main.Size = UDim2.new(0, 220, 0, 210) -- Boyut TextBox için uzatıldı
Main.Position = UDim2.new(0, 20, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
Main.BorderSizePixel = 0
local MCorner = Instance.new("UICorner", Main)
local MStroke = Instance.new("UIStroke", Main)
MStroke.Color = Color3.fromRGB(180, 0, 0)
MStroke.Thickness = 1.5

-- ÜST BAŞLIK
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundTransparency = 1
local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Text = "HUNTER <font color='#FF0000'>MULTI</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- MULTI-TARGET TEXTBOX
local TargetBox = Instance.new("TextBox", Main)
TargetBox.Size = UDim2.new(1, -30, 0, 35)
TargetBox.Position = UDim2.new(0, 15, 0, 45)
TargetBox.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
TargetBox.PlaceholderText = "Fuel, Ammo, Pistol..."
TargetBox.Text = ""
TargetBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetBox.Font = Enum.Font.Gotham
TargetBox.TextSize = 12
TargetBox.PlaceholderColor3 = Color3.fromRGB(80, 80, 80)
local TCorner = Instance.new("UICorner", TargetBox)
local TStroke = Instance.new("UIStroke", TargetBox)
TStroke.Color = Color3.fromRGB(40, 40, 45)

-- DURUM BUTONU
local StatusBtn = Instance.new("TextButton", Main)
StatusBtn.Size = UDim2.new(1, -30, 0, 45)
StatusBtn.Position = UDim2.new(0, 15, 0, 95)
StatusBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
StatusBtn.Text = "SYSTEM: STANDBY"
StatusBtn.TextColor3 = Color3.fromRGB(100, 100, 100)
StatusBtn.Font = Enum.Font.GothamBold
StatusBtn.TextSize = 12
local BCorner = Instance.new("UICorner", StatusBtn)
local BStroke = Instance.new("UIStroke", StatusBtn)
BStroke.Color = Color3.fromRGB(30, 30, 35)

-- ALT BİLGİ
local Footer = Instance.new("TextLabel", Main)
Footer.Size = UDim2.new(1, 0, 0, 40)
Footer.Position = UDim2.new(0, 0, 1, -40)
Footer.Text = "Virgül kullanarak listeleyebilirsin."
Footer.TextColor3 = Color3.fromRGB(120, 120, 120)
Footer.Font = Enum.Font.Gotham
Footer.TextSize = 10
Footer.BackgroundTransparency = 1

-- SÜRÜKLEME SİSTEMİ
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true dragStart = input.Position startPos = Main.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ESP OLUŞTURUCU
local function CreateESP(obj)
    if obj:FindFirstChild("Hunter_Visual") then return end
    local hl = Instance.new("Highlight", obj)
    hl.Name = "Hunter_Visual"
    hl.FillColor = Color3.fromRGB(255, 0, 0)
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    local bg = Instance.new("BillboardGui", obj)
    bg.Name = "Hunter_Label"
    bg.Size = UDim2.new(0, 120, 0, 40)
    bg.AlwaysOnTop = true
    bg.ExtentsOffset = Vector3.new(0, 3, 0)

    local tl = Instance.new("TextLabel", bg)
    tl.Size = UDim2.new(1, 0, 1, 0)
    tl.BackgroundTransparency = 1
    tl.TextColor3 = Color3.fromRGB(255, 255, 255)
    tl.TextStrokeTransparency = 0
    tl.Font = Enum.Font.GothamBold
    tl.TextSize = 12

    task.spawn(function()
        while obj and obj.Parent and ItemHunter.Active do
            if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                local pos = obj:IsA("Model") and (obj.PrimaryPart and obj.PrimaryPart.Position or obj:GetPivot().Position) or obj.Position
                local dist = math.floor((LP.Character.HumanoidRootPart.Position - pos).Magnitude)
                tl.Text = "⌖ " .. obj.Name .. "\n" .. dist .. "m"
            end
            task.wait(0.3)
        end
        hl:Destroy() bg:Destroy()
    end)
end

-- TARAMA MANTIĞI (Virgül Ayırıcılı)
local function Scan(v)
    for _, t in pairs(ItemHunter.Targets) do
        if v.Name:lower():find(t:lower()) then
            CreateESP(v)
        end
    end
end

StatusBtn.MouseButton1Click:Connect(function()
    ItemHunter.Active = not ItemHunter.Active
    
    if ItemHunter.Active then
        -- Listeyi Güncelle
        ItemHunter.Targets = {}
        for term in string.gmatch(TargetBox.Text, '([^,]+)') do
            table.insert(ItemHunter.Targets, term:match("^%s*(.-)%s*$"))
        end

        StatusBtn.Text = "HUNTER: ACTIVE"
        TweenService:Create(StatusBtn, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 0, 0), BackgroundColor3 = Color3.fromRGB(35, 5, 5)}):Play()
        TweenService:Create(BStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(180, 0, 0)}):Play()
        
        for _, v in pairs(workspace:GetDescendants()) do Scan(v) end
        ItemHunter.Connection = workspace.DescendantAdded:Connect(function(v)
            task.wait(0.5)
            if ItemHunter.Active then Scan(v) end
        end)
    else
        StatusBtn.Text = "SYSTEM: STANDBY"
        TweenService:Create(StatusBtn, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(100, 100, 100), BackgroundColor3 = Color3.fromRGB(18, 18, 22)}):Play()
        TweenService:Create(BStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(30, 30, 35)}):Play()
        if ItemHunter.Connection then ItemHunter.Connection:Disconnect() end
    end
end)
