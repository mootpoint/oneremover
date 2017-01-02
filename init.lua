-- adds nodes to allow players with creative to remove 1 x 1 pillars and fill in 1 x 1 holes.
-- Copyright 2017 mootpoint

-- from minetest default mod
oneremover = {}
local function dig_up(pos, node, digger)
	if digger == nil then return end
	local np = {x = pos.x, y = pos.y + 1, z = pos.z}
	local nn = minetest.get_node(np)
	
	while nn.name == 'default:cobble' or nn.name == 'default:stone' or nn.name == 'default:dirt' or nn.name == 'default:dirt_with_grass' or nn.name == 'default:dirt_with_snow' do
		minetest.node_dig(np, nn, digger)
		np = {x = np.x, y = np.y + 1, z = np.z}
		nn = minetest.get_node(np)
	end
end

minetest.register_node('oneremover:stone_filler', {
	description = 'Stone that fills holes',
	tiles = {'default_stone.png'},
	groups = {stone, cracky = 1},
	drop = 'default:cobble',
})
	
minetest.register_abm({
	--name = 'oneremover:fill_hole',
	nodenames = {'oneremover:stone_filler'},
	chance = 1,
	interval = 1,
	run_at_every_load = true,
	action = function(pos, node)
	if minetest.get_node({x = pos.x,y = pos.y-1,z = pos.z}).name ~= 'air'  then return end
		minetest.add_node({x = pos.x,y = pos.y-1,z = pos.z}, {name = 'oneremover:stone_filler'})
		minetest.after(0.1, function()
			if minetest.get_node({x = pos.x, y = pos.y+1, z = pos.z}).name ~= 'oneremover:stone_filler' then return end
				minetest.add_node({x = pos.x,y = pos.y+1,z = pos.z}, {name = 'default:stone'})
				
			end
		)
			
	end
	
})


minetest.register_node('oneremover:remover_stone', {
	description = 'Used to remove 1x1 pillars',
	tiles = {'default_stone.png'},
	groups = {oddly_breakable_by_hand = 3, not_in_creative_inventory = 1},
	on_punch = function(pos, node, puncher, pointed_thing)
		dig_up(pos, 'default:stone', puncher)
	end

})
