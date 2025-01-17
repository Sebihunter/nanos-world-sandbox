function SpawnTorch(location, rotation)
	local torch = Item(location or Vector(), rotation or Rotator(), "NanosWorld::SM_Torch")

	local light = Light(Vector(), Rotator(), Color(1, 0.7, 0.4), LightType.Point, 100, 1000)
	light:AttachTo(torch)
	light:SetRelativeLocation(Vector(0, 0, 75))

	local particle = Particle(Vector(), Rotator(), "NanosWorld::P_Fire", false)
	particle:AttachTo(torch)
	particle:SetRelativeLocation(Vector(0, 0, 50))

	torch:SetValue("Light", light)
	torch:SetValue("Particle", particle)

	return torch
end

-- Adds this tool to the Sandbox Spawn Menu
AddSpawnMenuItem("NanosWorld", "tools", "Torch", SpawnTorch)