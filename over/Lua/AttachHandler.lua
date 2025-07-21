local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remoteEvent = ReplicatedStorage:WaitForChild("AttachRequest")

remoteEvent.OnServerEvent:Connect(function(player, targetObject)
    if not player.Character then return end

    local character = player.Character
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    if targetObject and (targetObject:IsA("Part") or targetObject:IsA("MeshPart")) then
        print("[Server] Attaching object:", targetObject.Name, "to player:", player.Name)

        -- 캐릭터 전체 BasePart 투명화
        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
        end
        print("[Server] All character parts set to transparency 1")

        -- 충돌 비활성화
        targetObject.CanCollide = false

        -- 부모를 HumanoidRootPart로 설정
        targetObject.Parent = rootPart

        -- 위치를 겹치게 이동
        targetObject.CFrame = rootPart.CFrame

    else
        warn("[Server] Invalid object or not Part/MeshPart")
    end
end)