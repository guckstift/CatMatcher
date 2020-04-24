extends Camera2D

var zoom_mult = 0.75
var dragging = false
var smooth_pos = Vector2()
var smooth_zoom = 1.0

func _ready():
	smooth_pos = position
	smooth_zoom = zoom.x

func _input(event):
	if event is InputEventMouseButton:
		var diff = get_global_mouse_position() - position
		var old_zoom = smooth_zoom
		
		if event.pressed == true and event.button_index == BUTTON_RIGHT:
			dragging = true
		elif event.pressed == false and event.button_index == BUTTON_RIGHT:
			dragging = false
		elif event.pressed == true and event.button_index == BUTTON_WHEEL_UP:
			smooth_zoom *= zoom_mult
			smooth_zoom = clamp(smooth_zoom, 0.5, 4.0)
			var mult = smooth_zoom / old_zoom
			smooth_pos += diff * (1.0 - mult)
		elif event.pressed == true and event.button_index == BUTTON_WHEEL_DOWN:
			smooth_zoom /= zoom_mult
			smooth_zoom = clamp(smooth_zoom, 0.5, 3.0)
			var mult = old_zoom / smooth_zoom
			smooth_pos -= diff * (1.0 - mult) / mult
	
	if dragging and event is InputEventMouseMotion:
		smooth_pos -= event.relative * zoom

func _process(delta):
	position = lerp(position, smooth_pos, 4.0 * delta)
	zoom.x = lerp(zoom.x, smooth_zoom, 4.0 * delta)
	zoom.y = zoom.x
