-- Method to handle when Player picks up the Tool
function HandleThrusterTool(weapon)
	-- Subscribe when the player fires with this weapon
	weapon:Subscribe("Fire", function(weapon, shooter)
		-- Makes a trace 10000 units ahead to spawn the balloon
		local trace_result = TraceFor(10000, CollisionChannel.WorldStatic | CollisionChannel.WorldDynamic | CollisionChannel.PhysicsBody | CollisionChannel.Vehicle | CollisionChannel.Pawn)

		-- If hit some object, then spawns a thruster on attached it
		if (trace_result.Success and trace_result.Entity) then
			local distance_trace_object = trace_result.Entity:GetLocation() - trace_result.Location
			Events:CallRemote("SpawnThruster", {trace_result.Location, trace_result.Normal, trace_result.Entity, distance_trace_object})
		else
			-- If didn't hit anything, plays a negative sound
			Sound(Vector(), "NanosWorld::A_Invalid_Action", true, true, SoundType.SFX, 1)
		end
	end)
end

-- Event from server when a Thruster is spawned
Events:Subscribe("SpawnThruster", function(thruster_prop)
	-- Spawns a 'Thruster Sound' and attaches it to the prop
	local sound = Sound(Vector(), "NanosWorld::A_VR_WorldMove_Loop_01", false, false, SoundType.SFX, 0.25, math.random(10) / 100 + 1)
	sound:AttachTo(thruster_prop)

	thruster_prop:SetValue("Sound", sound)

	-- When the Prop is destroyed, destroy the sound as well
	thruster_prop:Subscribe("Destroy", function(p)
		thruster_prop:GetValue("Sound"):Destroy()
	end)
end)

Events:Subscribe("PickUpToolGun_ThrusterTool", function(tool, character)
	main_hud:CallEvent("UpdateToolgun", {"Thruster", "'Left Mouse' = Create a always-on Thruster"})
	HandleThrusterTool(tool)
end)

Events:Subscribe("DropToolGun_ThrusterTool", function(tool, character)
	main_hud:CallEvent("UpdateToolgun", {false, false})
	tool:Unsubscribe("Fire")
end)

-- Adds this tool to the Sandbox Spawn Menu
AddSpawnMenuItem("NanosWorld", "tools", "ThrusterTool", "Thruster", "assets///NanosWorld/Thumbnails/SK_Blaster.jpg")