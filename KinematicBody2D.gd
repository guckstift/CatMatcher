extends KinematicBody2D

signal started_moving

var gravity = 2048
var vel = Vector2()

func _physics_process(delta):
	vel += Vector2(0, gravity) * delta
	vel.x = 0
	
	var signaling = false
	
	if Input.is_action_pressed("ui_right"):
		vel.x += 256
		signaling = true
	if Input.is_action_pressed("ui_left"):
		vel.x -= 256
		signaling = true
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		vel.y -= 750
		signaling = true
	
	if signaling:
		emit_signal("started_moving")
	
	move_and_slide(vel, Vector2(0,-1))
	
	if is_on_floor() or is_on_ceiling():
		vel.y = 0
	if is_on_wall():
		vel.x = 0
	
	if vel.x != 0 and not $AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.play()
	
	if vel.x == 0 or not is_on_floor():
		$AudioStreamPlayer2D.stop()
