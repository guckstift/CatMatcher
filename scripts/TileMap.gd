extends TileMap

signal tile_clicked(tile_world_pos, tile_coord)
signal tile_hovered(tile_world_pos)
signal tile_unhovered

func _ready():

	for x in range(256):
		for y in range(256):
			set_cell(x, y, randi() % 4)
	
	for x in range(1,4):
		for y in range(1,4):
			set_cell(x, y, -1)

func _input(event):
	var world_pos = get_global_mouse_position()
	var tile_coord = world_to_map(world_pos)
	var tile = get_cellv(tile_coord)
	var tile_world_pos = map_to_world(tile_coord)
	
	if event is InputEventMouseButton:
		if (event.pressed == true and event.button_index == BUTTON_LEFT
			and tile != -1
		):
			emit_signal("tile_clicked", tile_world_pos, tile_coord)
	
	if event is InputEventMouseMotion:
		if tile == -1:
			emit_signal("tile_unhovered")
		else:
			emit_signal("tile_hovered", tile_world_pos)

func erase_tile(coord):
	set_cellv(coord, -1)

func swap_tiles(sel, adj):
	var sel_tile = get_cellv(sel)
	var adj_tile = get_cellv(adj)
	set_cellv(sel, adj_tile)
	set_cellv(adj, sel_tile)

func calc_floodfill(point, tile = -1, list = []):

	if tile == -1:
		tile = get_cellv(point)
	
	if tile == -1:
		return list
	
	var point_tile = get_cellv(point)
	
	if point_tile != tile:
		return list
	
	list.append(point)
	
	var l = point - Vector2(-1,0)
	var r = point - Vector2(+1,0)
	var u = point - Vector2(0,-1)
	var d = point - Vector2(0,+1)
	
	if not list.has(l):
		calc_floodfill(l, tile, list)
	if not list.has(r):
		calc_floodfill(r, tile, list)
	if not list.has(u):
		calc_floodfill(u, tile, list)
	if not list.has(d):
		calc_floodfill(d, tile, list)
	
	return list
