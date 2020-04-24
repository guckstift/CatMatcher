class_name Fake

extends StaticBody2D

export var way = 0.0 setget set_way

var start_pos = position
var end_pos = position

func _ready():
	deactivate()

func set_way(val):
	way = val
	position = lerp(start_pos, end_pos, way)

func setup_slide(start, end, tile):
	$Sprite.frame = tile
	position = start
	start_pos = start
	end_pos = end
	way = 0.0
	show()
	$CollisionShape2D.disabled = false

func deactivate():
	hide()
	$CollisionShape2D.disabled = true
	
