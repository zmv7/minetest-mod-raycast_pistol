local shoot = function(itemstack, player)
	local meta = itemstack:get_meta()
	local name = player:get_player_name()
	local count_meta = meta and meta:get("count_meta")
	local creative = core.check_player_privs(name, {creative = true})
	local ammo = tonumber(count_meta)
	if not ammo or ammo < 1 then
		core.sound_play("default_tool_breaks", {to_player=name})
		return
	end
	local raybegin = vector.add(player:get_pos(),
		{x=0, y=player:get_properties().eye_height, z=0})
	local rayend = vector.add(raybegin, vector.multiply(player:get_look_dir(), 150))
	local ray = core.raycast(raybegin, rayend, true, false)
	for pointed_thing in ray do
		if pointed_thing.type == "object" then
			local obj = pointed_thing.ref
			if obj ~= player then
				obj:punch(player, 1.0, {
					full_punch_interval = 1.0,
					damage_groups = {fleshy = 10},
				}, nil)
				break
			end
		end
	end
	meta:set_string("count_meta",tostring(ammo-1))
	if not creative then
		itemstack:add_wear(256)
	end
	core.sound_play("player_damage", {to_player=name})
	return itemstack
end

local reload = function(itemstack, player)
	local meta = itemstack:get_meta()
	local name = player:get_player_name()
	local inv = player:get_inventory()
	local creative = core.check_player_privs(name, {creative = true})
	if inv:contains_item("main", "raycast_pistol:magazine_full") or creative then
		if not creative then
			inv:remove_item("main", "raycast_pistol:magazine_full 1")
			inv:add_item("main", "raycast_pistol:magazine")
		end
		meta:set_string("count_meta", "8")
	end
	return itemstack
end

core.register_tool("raycast_pistol:pistol", {
	description = "Raycast Pistol",
	inventory_image = "raycast_pistol.png",
	on_use = shoot,
	on_secondary_use = reload,
	on_place = reload
})
core.register_craftitem("raycast_pistol:bullet",{
	description = "Raycast Pistol Bullet",
	inventory_image = "raycast_pistol_bullet.png"
})
core.register_craftitem("raycast_pistol:magazine",{
	description = "Empty Raycast Pistol Magazine",
	inventory_image = "raycast_pistol_magazine.png",
})
core.register_craftitem("raycast_pistol:magazine_full",{
	description = "Loaded Raycast Pistol Magazine",
	inventory_image = "raycast_pistol_magazine_full.png",
	stack_max = 16
})

core.register_craft({
	output = "raycast_pistol:pistol",
	recipe = {
		{"default:steel_ingot","default:steel_ingot","default:steel_ingot"},
		{"","","default:steel_ingot"},
		{"","",""}
	}
})
core.register_craft({
	output = "raycast_pistol:bullet",
	recipe = {
		{"","default:steel_ingot",""},
		{"","tnt:gunpowder",""},
		{"","default:steel_ingot",""}
	}
})
core.register_craft({
	output = "raycast_pistol:magazine",
	recipe = {
		{"default:steel_ingot","default:steel_ingot","default:steel_ingot"},
		{"default:steel_ingot","","default:steel_ingot"},
		{"default:steel_ingot","default:steel_ingot","default:steel_ingot"}
	}
})
core.register_craft({
	output = "raycast_pistol:magazine_full",
	recipe = {
		{"raycast_pistol:bullet","raycast_pistol:bullet","raycast_pistol:bullet"},
		{"raycast_pistol:bullet","","raycast_pistol:bullet"},
		{"raycast_pistol:bullet","raycast_pistol:bullet","raycast_pistol:bullet"}
	}
})

