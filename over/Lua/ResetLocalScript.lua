local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remoteEvent = ReplicatedStorage:WaitForChild("DetachRequest")

script.Parent.Activated:Connect(function()
    print("[Client] Sending reset/morph cancel request")
    remoteEvent:FireServer(nil) -- nil이면 서버가 '변신 해제'로 인식함
end)