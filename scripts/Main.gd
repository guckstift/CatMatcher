extends Node2D

export (PackedScene) var Particles

var sel = null
var sel_pos = null

func _on_TileMap_tile_clicked(tile_world_pos, tile_coord):
	if sel == null:
		select(tile_coord, tile_world_pos)
	else:
		var diff = (sel - tile_coord).abs()
		var dist = diff.x + diff.y
		
		if dist == 1:
			exec_move_if_valid(sel, tile_coord, sel_pos, tile_world_pos)
			select(null, null)
			$Picker.reset()
		else:
			select(tile_coord, tile_world_pos)

func _on_TileMap_tile_hovered(tile_world_pos):
	$Picker.select(tile_world_pos)

func _on_TileMap_tile_unhovered():
	$Picker.reset()

func select(tile_coord, tile_world_pos):
	if tile_coord == null:
		$Selector.reset()
		sel = null
		sel_pos = null
	else:
		$Selector.select(tile_world_pos)
		sel = tile_coord
		sel_pos = tile_world_pos

func exec_move_if_valid(sel, adj, sel_pos, adj_pos):

	var sel_tile = $TileMap.get_cellv(sel)
	var adj_tile = $TileMap.get_cellv(adj)
	
	if sel_tile == adj_tile:
		return

	$TileMap.swap_tiles(sel, adj)
	
	var flood_sel = $TileMap.calc_floodfill(sel)
	var flood_adj = $TileMap.calc_floodfill(adj)
	
	if len(flood_sel) >= 3 or len(flood_adj) >= 3:
		$TileMap.erase_tile(sel)
		$TileMap.erase_tile(adj)
		$TileSwapper.start_slide(sel_pos, adj_pos, sel_tile, adj_tile)
		yield($TileSwapper, "slide_finished")
		$TileMap.set_cellv(sel, adj_tile)
		$TileMap.set_cellv(adj, sel_tile)
		$BlopSound.pitch_scale = 1
		
		if len(flood_sel) >= 3:
			break_tiles(flood_sel)
		
		if len(flood_adj) >= 3:
			break_tiles(flood_adj)
	else:
		$TileMap.set_cellv(sel, sel_tile)
		$TileMap.set_cellv(adj, adj_tile)

func break_tiles(tiles):
	for tile in tiles:
		$BreakDelay.wait_time = rand_range(0.025, 0.075)
		$BreakDelay.start()
		yield($BreakDelay, "timeout")
		$TileMap.erase_tile(tile)
		var world_pos = $TileMap.map_to_world(tile)
		$BlopSound.position = world_pos
		$BlopSound.pitch_scale += rand_range(-0.5, 0.5)
		$BlopSound.pitch_scale = clamp($BlopSound.pitch_scale, 0.5, 2.0)
		$BlopSound.play()
		var particles = Particles.instance()
		add_child(particles)
		particles.fire($TileMap.map_to_world(tile) + Vector2(32, 32))
		particles.restart()
