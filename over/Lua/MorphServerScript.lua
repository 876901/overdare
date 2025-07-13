-- ServerScriptService에 넣기
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 리모트 이벤트 생성 또는 참조
local MorphRequest = ReplicatedStorage:FindFirstChild("MorphRequest")
if not MorphRequest then
    MorphRequest = Instance.new("RemoteEvent")
    MorphRequest.Name = "MorphRequest"
    MorphRequest.Parent = ReplicatedStorage
end

-- Morph 기능 함수
local function MorphToObject(player, target)
    local character = player.Character
    if not character or not target then return end

    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    print("[Server] Morph start for", player.Name)

    -- 기존 Morph 모델 제거
    local prev = character:FindFirstChild("MorphModel")
    if prev then
        print("[Server] Removing existing MorphModel")
        prev:Destroy()
    end

    -- 캐릭터 숨기기 (투명하게 하고 충돌 비활성화)
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
            part.CanCollide = false
        end
    end

    -- 대상 복제 및 부착
    local clone = target:Clone()
    clone.Name = "MorphModel"
    clone.Parent = character

    -- PrimaryPart 위치 정렬
    if clone.PrimaryPart then
        clone:SetPrimaryPartCFrame(root.CFrame)
    end

    -- 각 파트 부착 처리 및 물리 설정
    for _, part in pairs(clone:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Anchored = false -- 물리적 상호작용은 가능하게 함
            part.CanCollide = true -- **다른 오브젝트와 충돌할 수 있도록 true로 변경**

            -- HumanoidRootPart에 WeldConstraint로 고정
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = root -- 캐릭터의 HumanoidRootPart
            weld.Part1 = part -- MorphModel의 각 파트
            weld.Parent = part -- 파트 아래에 WeldConstraint를 넣습니다.

            -- LinearVelocity는 더 이상 필요 없으므로 제거 (혹은 주석 처리)
            -- local attachment = Instance.new("Attachment")
            -- attachment.Parent = part

            -- local lv = Instance.new("LinearVelocity")
            -- lv.Attachment0 = attachment
            -- lv.RelativeTo = Enum.ActuatorRelativeTo.World
            -- lv.VectorVelocity = Vector3.zero
            -- lv.MaxForce = 100000
            -- lv.Parent = part
        end
    end

    print("[Server] Morph completed for", player.Name)
end

MorphRequest.OnServerEvent:Connect(MorphToObject)