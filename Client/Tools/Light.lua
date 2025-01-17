-- Method to handle when Player picks up the Tool
function HandleLightTool(weapon)
	-- Subscribe when the player fires with this weapon
	weapon:Subscribe("Fire", function(weapon, shooter)
		-- Makes a trace 10000 units ahead
		local trace_result = TraceFor(10000, CollisionChannel.WorldStatic | CollisionChannel.WorldDynamic | CollisionChannel.PhysicsBody | CollisionChannel.Vehicle | CollisionChannel.Pawn)

		if (trace_result.Success) then
			local distance_trace_object = Vector()
			if (trace_result.Entity) then
				-- If hit an entity, then calculates the offset distance from the Hit and the Object
				distance_trace_object = trace_result.Entity:GetLocation() - trace_result.Location
			end

			-- Calls remote to spawn the Light
			Events:CallRemote("SpawnLight", {trace_result.Location, trace_result.Normal, trace_result.Entity, distance_trace_object})
		else
			-- If didn't hit anything, plays a negative sound
			Sound(Vector(), "NanosWorld::A_Invalid_Action", true, true, SoundType.SFX, 1)
		end
	end)

	-- Sets some notification when grabbing the Light Tool
	SetNotification("LIGHTS_PERFORMANCE", 5000, "too many lights can cause severe lag", 5000)
end

Events:Subscribe("PickUpToolGun_LightTool", function(tool)
main_hud:CallEvent("UpdateToolgun", {"Lights", "'Left Mouse' = Create a light with a random color"})
	HandleLightTool(tool)
end)

Events:Subscribe("DropToolGun_LightTool", function(tool)
	main_hud:CallEvent("UpdateToolgun", {false, false})
	tool:Unsubscribe("Fire")
end)

-- Adds this tool to the Sandbox Spawn Menu
AddSpawnMenuItem("NanosWorld", "tools", "LightTool", "Lights", "assets///NanosWorld/Thumbnails/SK_Blaster.jpg")