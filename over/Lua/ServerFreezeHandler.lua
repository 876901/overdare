local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local freezeEvent = ReplicatedStorage:WaitForChild("FreezeRequest")

-- AttachHandler에서 설정한 부착 객체 정보 접근용
local attachedObjects = {}

-- 외부에서 이 맵을 주입할 수 있게 설정
_G.SetAttachedObjectsMap = function(map)
    attachedObjects = map
end

freezeEvent.OnServerEvent:Connect(function(player)
    local character = player.Character
    if not character then return end

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    -- 현재 고정 여부 확인
    local shouldFreeze = not rootPart.Anchored

    -- HumanoidRootPart 토글 고정
    rootPart.Anchored = shouldFreeze
    print("[Server] HumanoidRootPart anchored:", shouldFreeze, "for", player.Name)

    -- 부착 오브젝트도 함께 토글
    local data = attachedObjects[player]
    if data and data.object then
        data.object.Anchored = shouldFreeze
        print("[Server] Attached object anchored:", shouldFreeze)
    end
end)