-- Subscribes for Client Event for welding an object into another
Events:Subscribe("Weld", function(player, welding_start, welding_end, welding_end_location)
	-- Spawns the cable
	local cable = Cable(welding_end_location)

	-- Configures the Cable Physics Limits to be rigid
	cable:SetLinearLimits(ConstraintMotion.Locked, ConstraintMotion.Locked, ConstraintMotion.Locked)
	cable:SetAngularLimits(ConstraintMotion.Locked, ConstraintMotion.Locked, ConstraintMotion.Locked)

	-- Makes the cable almost invisible
	cable:SetRenderingSettings(10, 1, 1)

	-- Attaches the cable to the two objects
	cable:AttachEndTo(welding_start)

	-- If there is an end object, attaches to it otherwise the cable keeps attached to the ground
	if (welding_end) then
		cable:AttachStartTo(welding_end)
	end

	-- Calls the client to update it's action history
	Events:CallRemote("SpawnedItem", player, {cable})

	Events:BroadcastRemote("SpawnParticle", {welding_start:GetLocation(), Rotator(), "NanosWorld::P_OmnidirectionalBurst"})
	Events:BroadcastRemote("SpawnParticle", {welding_end_location, Rotator(), "NanosWorld::P_OmnidirectionalBurst"})
end)

-- Adds this tool to the Sandbox Spawn Menu
AddSpawnMenuItem("NanosWorld", "tools", "WeldTool", function() return SpawnGenericToolGun(Vector(), Rotator(), Color.CHARTREUSE) end)