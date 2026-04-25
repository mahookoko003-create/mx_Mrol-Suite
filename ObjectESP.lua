-- Mxrol Object ESP
local function ApplyObjectESP()
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("Tool") or (obj:IsA("Part") and obj.Parent:IsA("Model") and obj.Parent:FindFirstChildOfClass("TouchTransmitter")) then
            if not obj:FindFirstChild("Mxrol_Highlight") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "Mxrol_Highlight"
                highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Kan Kırmızısı
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillAlpha = 0.5
                highlight.Parent = obj
            end
        end
    end
end

-- Menüye bağlamak için:
return function(state)
    if state then
        _G.ObjESP = true
        task.spawn(function()
            while _G.ObjESP do
                ApplyObjectESP()
                task.wait(5) -- Sistemi yormamak için 5 saniyede bir tara
            end
        end)
    else
        _G.ObjESP = false
        for _, v in pairs(game.Workspace:GetDescendants()) do
            if v.Name == "Mxrol_Highlight" then v:Destroy() end
        end
    end
end
