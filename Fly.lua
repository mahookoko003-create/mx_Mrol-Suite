-- mx_Mrol Fly Module V2.0 | Advanced Cleanup
local player = game.Players.LocalPlayer
local userInput = game:GetService("UserInputService")
local runService = game:GetService("RunService")

return function(state)
    _G.MrolFlyV2 = state
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if not root or not hum then return end

    -- KAPATMA KOMUTU GELDİĞİNDE:
    if not state then
        _G.MrolFlyV2 = false
        -- Karakter üzerindeki uçuş objelerini anında temizle
        if root:FindFirstChild("MrolBG") then root.MrolBG:Destroy() end
        if root:FindFirstChild("MrolBV") then root.MrolBV:Destroy() end
        hum.PlatformStand = false
        return
    end

    -- AÇMA KOMUTU GELDİĞİNDE:
    if state then
        -- Varsa eski objeleri temizle (Üst üste binmesin)
        if root:FindFirstChild("MrolBG") then root.MrolBG:Destroy() end
        if root:FindFirstChild("MrolBV") then root.MrolBV:Destroy() end

        local bg = Instance.new("BodyGyro", root)
        bg.Name = "MrolBG"
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = root.CFrame
        
        local bv = Instance.new("BodyVelocity", root)
        bv.Name = "MrolBV"
        bv.velocity = Vector3.new(0,0,0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        
        hum.PlatformStand = true
        
        task.spawn(function()
            -- Döngü her karede _G.MrolFlyV2'yi kontrol eder
            while _G.MrolFlyV2 and char and char.Parent and root and root.Parent do
                local cam = workspace.CurrentCamera
                bg.cframe = cam.CFrame
                local dir = Vector3.new(0,0,0)
                
                if userInput:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
                if userInput:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
                if userInput:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
                if userInput:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
                
                bv.velocity = dir.Magnitude > 0 and dir.Unit * 100 or Vector3.new(0,0,0)
                runService.RenderStepped:Wait()
            end
            
            -- Döngü bittiğinde veya karakter öldüğünde son temizlik
            if bg then bg:Destroy() end
            if bv then bv:Destroy() end
            if hum then hum.PlatformStand = false end
        end)
    end
end
