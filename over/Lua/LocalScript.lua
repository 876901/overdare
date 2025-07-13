-- StarterPlayerScripts 안에 넣기
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local MorphRequest = ReplicatedStorage:WaitForChild("MorphRequest")
local target = workspace:FindFirstChild("MorphTarget")

UserInputService.InputBegan:Connect(function(input, isProcessed)
	if isProcessed then return end
	if input.KeyCode == Enum.KeyCode.F then
		if target then
			print("[Client] F key pressed - sending Morph request to server")
			MorphRequest:FireServer(target)
		else
			warn("[Client] Morph target not found in workspace")
		end
	end
end)