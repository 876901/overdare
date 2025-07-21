local ReplicatedStorage = game:GetService("ReplicatedStorage")
local freezeEvent = ReplicatedStorage:WaitForChild("FreezeRequest")

script.Parent.Activated:Connect(function()
	print("[Client] Freeze button clicked")
	freezeEvent:FireServer()
end)