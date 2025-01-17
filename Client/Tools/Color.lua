-- Method to handle when Player picks up the Tool
function HandleColorTool(tool)
	-- Subscribe when the player fires with this weapon
	tool:Subscribe("Fire", function(weapon, shooter)
		-- Makes a trace 10000 units ahead
		local trace_result = TraceFor(10000, CollisionChannel.WorldStatic | CollisionChannel.WorldDynamic | CollisionChannel.PhysicsBody | CollisionChannel.Vehicle | CollisionChannel.Pawn)

		-- If hit an object, then get a random Color and call server to update the color for everyone
		if (trace_result.Success and trace_result.Entity) then
			local color = Color.RandomPalette()
			Events:CallRemote("ColorObject", {trace_result.Entity, trace_result.Location, trace_result.Normal, color})
		else
			-- If didn't hit anything, plays a negative sound
			Sound(Vector(), "NanosWorld::A_Invalid_Action", true, true, SoundType.SFX, 1)
		end
	end)
end

Events:Subscribe("PickUpToolGun_ColorTool", function(tool)
	main_hud:CallEvent("UpdateToolgun", {"Color", "'Left Mouse' = Change an objects color randomly"})
	HandleColorTool(tool)
end)

Events:Subscribe("DropToolGun_ColorTool", function(tool)
	main_hud:CallEvent("UpdateToolgun", {false, false})
	tool:Unsubscribe("Fire")
end)

-- Adds this tool to the Sandbox Spawn Menu
AddSpawnMenuItem("NanosWorld", "tools", "ColorTool", "Colors", "assets///NanosWorld/Thumbnails/SK_Blaster.jpg")