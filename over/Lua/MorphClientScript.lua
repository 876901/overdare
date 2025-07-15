local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvent = ReplicatedStorage:WaitForChild("MorphRequest")

local morphButton = player:WaitForChild("PlayerGui"):WaitForChild("MorphGui"):WaitForChild("MorphButton")

morphButton.Activated:Connect(function()
	print("[CLIENT] Morph button clicked.")
	RemoteEvent:FireServer() -- 더 이상 targetName 안 보냄
end)