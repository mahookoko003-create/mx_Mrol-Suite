-- [[ mx_Mrol Suite V2.0 - PRESTIGE INTERNAL ]] --
-- "Sessiz güç, mutlak kontrol."

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = game.Players.LocalPlayer

-- Akıcı Animasyon Ayarları
local SmoothInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

function Library:Init(hubName)
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "Mrol_Prestige_Suite"
    
    local Main = Instance.new("Frame", ScreenGui)
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 480, 0, 420) -- Profil için biraz uzattım
    Main.Position = UDim2.new(0.5, -240, 0.5, -210)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    Main.BorderSizePixel = 0
    
    local MainCorner = Instance.new("UICorner", Main)
    MainCorner.CornerRadius = UDim.new(0, 12)
    
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Color3.fromRGB(255, 0, 0)
    MainStroke.Thickness = 1.5
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- [HEADER] Üst Panel
    local Header = Instance.new("Frame", Main)
    Header.Size = UDim2.new(1, 0, 0, 55)
    Header.BackgroundTransparency = 1
    
    local Title = Instance.new("TextLabel", Header)
    Title.Text = hubName:upper() .. " <font color='#FF0000'>PRESTIGE</font>"
    Title.RichText = true
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    -- Kapatma Tuşu
    local CloseBtn = Instance.new("TextButton", Header)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -40, 0, 12)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(180, 0, 0)
    CloseBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    local Line = Instance.new("Frame", Main)
    Line.Size = UDim2.new(1, -40, 0, 1)
    Line.Position = UDim2.new(0, 20, 0, 55)
    Line.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    Line.BackgroundTransparency = 0.3

    -- [SCROLL] İçerik Alanı
    local Scroll = Instance.new("ScrollingFrame", Main)
    Scroll.Size = UDim2.new(1, -30, 1, -160) -- Alt paneli açmak için kısalttım
    Scroll.Position = UDim2.new(0, 15, 0, 70)
    Scroll.BackgroundTransparency = 1
    Scroll.ScrollBarThickness = 0
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local Layout = Instance.new("UIListLayout", Scroll)
    Layout.Padding = UDim.new(0, 10)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- [PROFILE SECTION] Alt Bilgi Paneli
    local Profile = Instance.new("Frame", Main)
    Profile.Size = UDim2.new(1, -30, 0, 70)
    Profile.Position = UDim2.new(0, 15, 1, -85)
    Profile.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    Instance.new("UICorner", Profile).CornerRadius = UDim.new(0, 10)
    local PStroke = Instance.new("UIStroke", Profile)
    PStroke.Color = Color3.fromRGB(30, 30, 35)

    local PImage = Instance.new("ImageLabel", Profile)
    PImage.Size = UDim2.new(0, 50, 0, 50)
    PImage.Position = UDim2.new(0, 10, 0, 10)
    PImage.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    PImage.Image = "rbxthumb://type=AvatarHeadShot&id="..LocalPlayer.UserId.."&w=150&h=150"
    Instance.new("UICorner", PImage).CornerRadius = UDim.new(1, 0)

    local PUser = Instance.new("TextLabel", Profile)
    PUser.Text = LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")"
    PUser.Size = UDim2.new(1, -75, 0, 25)
    PUser.Position = UDim2.new(0, 70, 0, 12)
    PUser.TextColor3 = Color3.fromRGB(180, 0, 0)
    PUser.Font = Enum.Font.GothamBold
    PUser.TextSize = 14
    PUser.TextXAlignment = Enum.TextXAlignment.Left
    PUser.BackgroundTransparency = 1

    local PVer = Instance.new("TextLabel", Profile)
    PVer.Text = "Sürüm: 2.0 Prestige Build | ID: " .. LocalPlayer.UserId
    PVer.Size = UDim2.new(1, -75, 0, 20)
    PVer.Position = UDim2.new(0, 70, 0, 32)
    PVer.TextColor3 = Color3.fromRGB(120, 120, 125)
    PVer.Font = Enum.Font.Gotham
    PVer.TextSize = 12
    PVer.TextXAlignment = Enum.TextXAlignment.Left
    PVer.BackgroundTransparency = 1

    -- Sürükleme Sistemi
    local dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragStart = input.Position startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragStart then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragStart = nil end end)

    -- [TOGGLE SİSTEMİ]
    function Library:AddToggle(name, callback)
        local active = false
        local ToggleFrame = Instance.new("TextButton", Scroll)
        ToggleFrame.Size = UDim2.new(1, -5, 0, 45)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
        ToggleFrame.AutoButtonColor = false
        ToggleFrame.Text = ""
        Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 8)
        local TStroke = Instance.new("UIStroke", ToggleFrame)
        TStroke.Color = Color3.fromRGB(35, 35, 40)

        local TName = Instance.new("TextLabel", ToggleFrame)
        TName.Text = name
        TName.Size = UDim2.new(1, 0, 1, 0)
        TName.Position = UDim2.new(0, 15, 0, 0)
        TName.TextColor3 = Color3.fromRGB(180, 180, 185)
        TName.Font = Enum.Font.GothamMedium
        TName.TextSize = 14
        TName.TextXAlignment = Enum.TextXAlignment.Left
        TName.BackgroundTransparency = 1

        local Switch = Instance.new("Frame", ToggleFrame)
        Switch.Size = UDim2.new(0, 34, 0, 18)
        Switch.Position = UDim2.new(1, -45, 0.5, -9)
        Switch.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

        local Dot = Instance.new("Frame", Switch)
        Dot.Size = UDim2.new(0, 12, 0, 12)
        Dot.Position = UDim2.new(0, 3, 0.5, -6)
        Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

        ToggleFrame.MouseButton1Click:Connect(function()
            active = not active
            callback(active)
            if active then
                TweenService:Create(Switch, SmoothInfo, {BackgroundColor3 = Color3.fromRGB(180, 0, 0)}):Play()
                TweenService:Create(Dot, SmoothInfo, {Position = UDim2.new(1, -15, 0.5, -6)}):Play()
                TweenService:Create(TName, SmoothInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            else
                TweenService:Create(Switch, SmoothInfo, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
                TweenService:Create(Dot, SmoothInfo, {Position = UDim2.new(0, 3, 0.5, -6)}):Play()
                TweenService:Create(TName, SmoothInfo, {TextColor3 = Color3.fromRGB(180, 180, 185)}):Play()
            end
        end)
    end

    return Library
end

-- [BAĞLANTI BÖLÜMÜ]
local UI = Library:Init("mx_Mrol")

-- Fly
UI:AddToggle("FLY - Flight", function(active)
    local flyModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/mahookoko003-create/mx_Mrol-Suite/main/Fly.lua"))()
    flyModule(active)
end)

-- ESP
UI:AddToggle("ESP - Track", function(active)
    local espModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/mahookoko003-create/mx_Mrol-Suite/main/ESP.lua"))()
    espModule(active)
end)

-- Aimbot
UI:AddToggle("Aimbot Master", function(active)
    if active then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/mahookoko003-create/mx_Mrol-Suite/main/AIM.lua"))()
    end
end)
