-- Method to handle when Player picks up the Tool
function HandleRemoverTool(weapon)
	weapon:Subscribe("Fire", function(weapon, shooter)
		-- Makes a trace 5000 units ahead to spawn the balloon
		local trace_result = TraceFor(5000, CollisionChannel.WorldStatic | CollisionChannel.WorldDynamic | CollisionChannel.PhysicsBody | CollisionChannel.Vehicle)

		-- If hit an object, calls the server to destroy it
		if (trace_result.Success and trace_result.Entity and not NanosWorld:IsA(trace_result.Entity, Character)) then
			Events:CallRemote("DestroyItem", {trace_result.Entity})
		else
			-- If didn't hit anything, plays a negative sound
			Sound(Vector(), "NanosWorld::A_Invalid_Action", true, true, SoundType.SFX, 1)
		end
	end)
end

Events:Subscribe("PickUpToolGun_RemoverTool", function(tool, character)
	main_hud:CallEvent("UpdateToolgun", {"Remover", "'Left Mouse' = Remove object"})
	HandleRemoverTool(tool)
end)

Events:Subscribe("DropToolGun_RemoverTool", function(tool, character)
	main_hud:CallEvent("UpdateToolgun", {false, false})
	tool:Unsubscribe("Fire")
end)

-- Adds this tool to the Sandbox Spawn Menu
AddSpawnMenuItem("NanosWorld", "tools", "RemoverTool", "Remover", "assets///NanosWorld/Thumbnails/SK_Blaster.jpg")