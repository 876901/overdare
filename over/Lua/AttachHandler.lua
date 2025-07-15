local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvent = ReplicatedStorage:WaitForChild("MorphRequest")
local TargetModel = workspace:WaitForChild("TargetModel")

-- 거리 기준 (캐릭터와 오브젝트가 이 거리 이하일 때만 변신 가능)
local MAX_DISTANCE = 10

RemoteEvent.OnServerEvent:Connect(function(player)
	local character = player.Character
	if not character then return end
	if not character.PrimaryPart then
		warn("[SERVER] Character has no PrimaryPart.")
		return
	end

	-- 캐릭터 투명화
	for _, part in pairs(character:GetChildren()) do
		if part:IsA("BasePart") then
			part.Transparency = 1
		end
	end

	print("[SERVER] Morph request received from " .. player.Name)

	-- 가장 가까운 오브젝트 찾기
	local closestTemplate = nil
	local shortestDistance = MAX_DISTANCE

	for _, obj in pairs(TargetModel:GetChildren()) do
		if obj:IsA("Model") and obj.PrimaryPart then
			local dist = (obj.PrimaryPart.Position - character.PrimaryPart.Position).Magnitude
			if dist < shortestDistance then
				shortestDistance = dist
				closestTemplate = obj
			end
		elseif obj:IsA("BasePart") then
			local dist = (obj.Position - character.PrimaryPart.Position).Magnitude
			if dist < shortestDistance then
				shortestDistance = dist
				closestTemplate = obj
			end
		end
	end

	if not closestTemplate then
		print("[SERVER] No nearby morph target found.")
		return
	end

	-- 복제 및 부착
	local morphObject = closestTemplate:Clone()
	morphObject.Name = "MorphObject"
	morphObject.Parent = workspace

	local attachChar = Instance.new("Attachment")
	attachChar.Parent = character.PrimaryPart

	local attachMorph = Instance.new("Attachment")
	if morphObject:IsA("Model") then
		if not morphObject.PrimaryPart then
			print("[SERVER] Morph model has no PrimaryPart.")
			return
		end
		attachMorph.Parent = morphObject.PrimaryPart
	else
		attachMorph.Parent = morphObject
	end

	local velocity = Instance.new("LinearVelocity")
	velocity.MaxForce = math.huge
	velocity.Attachment0 = attachMorph
	velocity.Attachment1 = attachChar
	velocity.RelativeTo = Enum.ActuatorRelativeTo.Attachment0
	velocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Line
	velocity.VectorVelocity = Vector3.new(0, 0, 0)
	velocity.Parent = morphObject

	local targetCFrame = character.PrimaryPart.CFrame
	if morphObject:IsA("Model") then
		morphObject:SetPrimaryPartCFrame(targetCFrame)
	else
		morphObject.CFrame = targetCFrame
	end

	print("[SERVER] Morph successful into: " .. closestTemplate.Name)
end)