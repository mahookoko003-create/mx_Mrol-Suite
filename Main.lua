-- [[ mx_Mrol Suite V2.0 - PROFESSIONAL PRESTIGE ]] --

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = game.Players.LocalPlayer

-- UI OLUŞTURMA ANA FONKSİYONU
function Library:Init(hubName)
    local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    local Main = Instance.new("Frame", ScreenGui)
    
    -- Ana Panel Tasarımı
    Main.Name = "mx_Mrol_Main"
    Main.Size = UDim2.new(0, 450, 0, 320)
    Main.Position = UDim2.new(0.5, -225, 0.5, -160)
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(35, 35, 45)
    Stroke.Thickness = 2

    -- Başlık Paneli
    local Header = Instance.new("Frame", Main)
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.BackgroundTransparency = 1
    
    local Title = Instance.new("TextLabel", Header)
    Title.Text = "  " .. hubName .. " | V2.0"
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.TextColor3 = Color3.fromRGB(0, 170, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    -- Kapatma Butonu (X)
    local Close = Instance.new("TextButton", Header)
    Close.Size = UDim2.new(0, 30, 0, 30)
    Close.Position = UDim2.new(1, -40, 0, 7)
    Close.Text = "X"
    Close.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Close.TextColor3 = Color3.fromRGB(255, 80, 80)
    Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 5)

    Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    -- Kaydırma Alanı
    local Scroll = Instance.new("ScrollingFrame", Main)
    Scroll.Size = UDim2.new(1, -20, 1, -65)
    Scroll.Position = UDim2.new(0, 10, 0, 55)
    Scroll.BackgroundTransparency = 1
    Scroll.ScrollBarThickness = 2
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local Layout = Instance.new("UIListLayout", Scroll)
    Layout.Padding = UDim.new(0, 8)
    
    -- Sürükleme Sistemi
    local dragging, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

    -- BUTON EKLEME FONKSİYONU (Kritik Yer)
    function Library:AddToggle(name, callback)
        local active = false
        local Btn = Instance.new("TextButton", Scroll)
        Btn.Size = UDim2.new(1, -10, 0, 40)
        Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        Btn.Text = "  " .. name
        Btn.TextColor3 = Color3.fromRGB(200, 200, 205)
        Btn.Font = Enum.Font.Gotham
        Btn.TextSize = 14
        Btn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", Btn)
        
        local Indicator = Instance.new("Frame", Btn)
        Indicator.Size = UDim2.new(0, 4, 0, 20)
        Indicator.Position = UDim2.new(1, -10, 0.5, -10)
        Indicator.BackgroundColor3 = Color3.fromRGB(40, 40, 45)

        Btn.MouseButton1Click:Connect(function()
            active = not active
            callback(active)
            
            if active then
                TweenService:Create(Indicator, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 170, 255)}):Play()
                Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                TweenService:Create(Indicator, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
                Btn.TextColor3 = Color3.fromRGB(200, 200, 205)
            end
        end)
    end

    return Library
end

-- [[ SCRIPTLERİ ÇALIŞTIRMA KISMI ]] --
local UI = Library:Init("mx_Mrol Suite")

-- Örnek: Fly Özelliği
UI:AddToggle("Ghost Fly (Stealth)", function(state)
    -- Buraya Fly kodumuzu koyacağız
    print("Fly Durumu: ", state)
end)

-- Örnek: ESP Özelliği
UI:AddToggle("Global ESP", function(state)
    print("ESP Durumu: ", state)
end)
