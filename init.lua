local players_in_bed = {}
local force_check = false

local beds_list = {
	{ "Red Bed", "red"},
	{ "Orange Bed", "orange"},	
	{ "Yellow Bed", "yellow"},
	{ "Green Bed", "green"},
	{ "Blue Bed", "blue"},
	{ "Violet Bed", "violet"},
	{ "Black Bed", "black"},
	{ "Grey Bed", "grey"},
	{ "White Bed", "white"},
}

for i in ipairs(beds_list) do
	local beddesc = beds_list[i][1]
	local colour = beds_list[i][2]

	minetest.register_node("beds:bed_bottom_"..colour, {
		description = beddesc,
		drawtype = "nodebox",
		tiles = {"beds_bed_top_bottom_"..colour..".png", "default_wood.png",  "beds_bed_side_"..colour..".png",  "beds_bed_side_"..colour..".png",  "beds_bed_side_"..colour..".png",  "beds_bed_side_"..colour..".png"},
		paramtype = "light",
		paramtype2 = "facedir",
		stack_max = 1,
		groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
		sounds = default.node_sound_wood_defaults(),
		node_box = {
			type = "fixed",
			fixed = {
						-- bed
						{-0.5, 0.0, -0.5, 0.5, 0.3125, 0.5},
						
						-- legs
						{-0.5, -0.5, -0.5, -0.4, 0.0, -0.4},
						{0.4, 0.0, -0.4, 0.5, -0.5, -0.5},
					}
		},
		selection_box = {
			type = "fixed",
			fixed = {
						{-0.5, -0.5, -0.5, 0.5, 0.3125, 1.5},
					}
		},

		after_place_node = function(pos, placer, itemstack)
			local node = minetest.env:get_node(pos)
			local p = {x=pos.x, y=pos.y, z=pos.z}
			local param2 = node.param2
			node.name = "beds:bed_top_"..colour
			if param2 == 0 then
				pos.z = pos.z+1
			elseif param2 == 1 then
				pos.x = pos.x+1
			elseif param2 == 2 then
				pos.z = pos.z-1
			elseif param2 == 3 then
				pos.x = pos.x-1
			end
			if minetest.registered_nodes[minetest.env:get_node(pos).name].buildable_to  then
				minetest.env:set_node(pos, node)
			else
				minetest.env:remove_node(p)
				return true
			end
		end,
			
		on_destruct = function(pos)
			local node = minetest.env:get_node(pos)
			local param2 = node.param2
			if param2 == 0 then
				pos.z = pos.z+1
			elseif param2 == 1 then
				pos.x = pos.x+1
			elseif param2 == 2 then
				pos.z = pos.z-1
			elseif param2 == 3 then
				pos.x = pos.x-1
			end
			if( minetest.env:get_node({x=pos.x, y=pos.y, z=pos.z}).name == "beds:bed_top_"..colour ) then
				if( minetest.env:get_node({x=pos.x, y=pos.y, z=pos.z}).param2 == param2 ) then
					minetest.env:remove_node(pos)
				end	
			end
		end,
		
		on_rightclick = function(pos, node, clicker)
			if not clicker:is_player() then
				return
			end
			local meta = minetest.env:get_meta(pos)
			local param2 = node.param2
			if param2 == 0 then
				pos.z = pos.z+1
			elseif param2 == 1 then
				pos.x = pos.x+1
			elseif param2 == 2 then
				pos.z = pos.z-1
			elseif param2 == 3 then
				pos.x = pos.x-1
			end
			if clicker:get_player_name() == meta:get_string("player") or players_in_bed[clicker:get_player_name()] then
				if param2 == 0 then
					pos.x = pos.x-1
				elseif param2 == 1 then
					pos.z = pos.z+1
				elseif param2 == 2 then
					pos.x = pos.x+1
				elseif param2 == 3 then
					pos.z = pos.z-1
				end
				pos.y = pos.y-0.5
				clicker:set_physics_override(1, 1, 1)
				clicker:setpos(pos)
				meta:set_string("player", "")
				players_in_bed[clicker:get_player_name()] = nil
			elseif meta:get_string("player") == "" then
				pos.y = pos.y-1
				clicker:set_physics_override(0, 0, 0)
				clicker:setpos(pos)
				if param2 == 0 then
					clicker:set_look_yaw(math.pi)
				elseif param2 == 1 then
					clicker:set_look_yaw(0.5*math.pi)
				elseif param2 == 2 then
					clicker:set_look_yaw(0)
				elseif param2 == 3 then
					clicker:set_look_yaw(1.5*math.pi)
				end
				
				meta:set_string("player", clicker:get_player_name())
				players_in_bed[clicker:get_player_name()] = true
				force_check = true
			end
		end,
		
		can_dig = function(pos, player)
			local meta = minetest.env:get_meta(pos)
			return player:get_player_name() ~= meta:get_string("player")
		end
	})
	
	minetest.register_node("beds:bed_top_"..colour, {
		drawtype = "nodebox",
		tiles = {"beds_bed_top_top_"..colour..".png", "default_wood.png",  "beds_bed_side_top_r_"..colour..".png",  "beds_bed_side_top_l_"..colour..".png",  "beds_bed_top_front.png",  "beds_bed_side_"..colour..".png"},
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
		sounds = default.node_sound_wood_defaults(),
		node_box = {
			type = "fixed",
			fixed = {
						-- bed
						{-0.5, 0.0, -0.5, 0.5, 0.3125, 0.5},
						{-0.4375, 0.3125, 0.1, 0.4375, 0.4375, 0.5},
						
						-- legs
						{-0.4, 0.0, 0.4, -0.5, -0.5, 0.5},
						{0.5, -0.5, 0.5, 0.4, 0.0, 0.4},
					}
		},
		selection_box = {
			type = "fixed",
			fixed = {
						{0, 0, 0, 0, 0, 0},
					}
		},
	})
	
	minetest.register_alias("beds:bed_"..colour, "beds:bed_bottom_"..colour)
	
	minetest.register_craft({
		output = "beds:bed_"..colour,
		recipe = {
			{"wool:"..colour, "wool:"..colour, "wool:white", },
			{"default:stick", "", "default:stick", }
		}
	})
	
	minetest.register_craft({
		output = "beds:bed_"..colour,
		recipe = {
			{"wool:white", "wool:"..colour, "wool:"..colour, },
			{"default:stick", "", "default:stick", }
		}
	})
	
end

minetest.register_alias("beds:bed_bottom", "beds:bed_bottom_blue")
minetest.register_alias("beds:bed_top", "beds:bed_top_blue")
minetest.register_alias("beds:bed", "beds:bed_bottom_blue")

local timer = 0
local wait = false
minetest.register_globalstep(function(dtime)
	if timer < 5 and not force_check then
		timer = timer + dtime
		return
	end
	timer = 0
	force_check = false

	if wait then
		return
	end

	local time_of_day = minetest.env:get_timeofday()
	if minetest.env:get_timeofday() < 0.2 or minetest.env:get_timeofday() > 0.805 then
		local online_count = #minetest.get_connected_players()
		local slept_count = 0
		for _,player in ipairs(minetest.get_connected_players()) do
			if players_in_bed[player:get_player_name()] then
				slept_count = slept_count + 1
			end
		end

		if slept_count == online_count and online_count ~= 0 then
			minetest.chat_send_all("[zzz] " .. slept_count .. " of " .. online_count .. " players slept, skipping to day.")
			minetest.after(2, function()
				minetest.env:set_timeofday(0.23)
				wait = false
			end)
			wait = true
		end
	end
end)

if minetest.setting_get("log_mods") then
	minetest.log("action", "beds loaded")
end
