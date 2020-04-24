class_name Selector

extends Sprite

func _ready():
	hide()

func select(tile_world_pos):
	position = tile_world_pos
	show()

func reset():
	hide()
