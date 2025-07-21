local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remoteEvent = ReplicatedStorage:WaitForChild("DetachRequest")

remoteEvent.OnServerEvent:Connect(function(player, targetObject)
    if not player.Character then return end

    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    -- 변신 해제 요청
    if targetObject == nil then
        rootPart.Transparency = 0
        print("[Server] Restored HumanoidRootPart transparency")

        -- 자식 중에 부착된 오브젝트 제거
        for _, child in ipairs(rootPart:GetChildren()) do
            if child:IsA("Part") or child:IsA("MeshPart") then
                child:Destroy()
                print("[Server] Detached object from player:", player.Name)
            end
        end
        return
    end

    -- 변신 시작
    if targetObject and (targetObject:IsA("Part") or targetObject:IsA("MeshPart")) then
        print("[Server] Attaching object:", targetObject.Name, "to player:", player.Name)

        rootPart.Transparency = 1
        print("[Server] Set HumanoidRootPart transparency to 1")

        targetObject.CanCollide = false
        targetObject.Parent = rootPart
    else
        print("[Server] Invalid object or not Part/MeshPart")
    end
end)