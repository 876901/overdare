﻿local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remoteEvent = ReplicatedStorage:WaitForChild("AttachRequest")

remoteEvent.OnServerEvent:Connect(function(player, targetObject)
    if not player.Character then return end

    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    if targetObject and (targetObject:IsA("Part") or targetObject:IsA("MeshPart")) then
        print("[Server] Attaching object:", targetObject.Name, "to player:", player.Name)

        -- HumanoidRootPart 투명화
        rootPart.Transparency = 1
        print("[Server] Set HumanoidRootPart transparency to 1")

        -- 충돌 비활성화
        targetObject.CanCollide = false

        -- 부모를 HumanoidRootPart로 변경
        targetObject.Parent = rootPart

    else
        print("[Server] Invalid object or not Part/MeshPart")
    end
end)