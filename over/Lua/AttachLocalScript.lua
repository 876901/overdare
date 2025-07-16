local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remoteEvent = ReplicatedStorage:WaitForChild("AttachRequest")

local player = Players.LocalPlayer
local character = nil
local humanoidRoot = nil

-- 캐릭터가 로딩된 후 설정
if player.Character then
	character = player.Character
	humanoidRoot = character:FindFirstChild("HumanoidRootPart")
else
	player.CharacterAdded:Connect(function(char)
		character = char
		humanoidRoot = character:FindFirstChild("HumanoidRootPart")
	end)
end

-- 근처 오브젝트 확인 함수
local function getNearbyObject()
	if not humanoidRoot then return nil end

	local nearbyRadius = 150
	for _, object in ipairs(workspace.InteractableObjects:GetChildren()) do
		if object:IsA("Part") or object:IsA("MeshPart") then
			if (object.Position - humanoidRoot.Position).Magnitude <= nearbyRadius then
				return object
			end
		end
	end
	return nil
end

-- 버튼 눌렀을 때 (Activated 이벤트 사용)
script.Parent.Activated:Connect(function()
	local targetObject = getNearbyObject()
	if targetObject then
		print("[Client] Found object to attach:", targetObject.Name)
		remoteEvent:FireServer(targetObject)
	else
		print("[Client] No nearby object found.")
	end
end)