local Character = script.Parent

repeat wait(0.1) until Character.Humanoid
local Humanoid = Character.Humanoid

Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)