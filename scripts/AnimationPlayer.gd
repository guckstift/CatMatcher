extends AnimationPlayer

signal slide_finished

var moveSounds = []

func _ready():
	moveSounds.append(load("res://sfx/move.ogg"))
	moveSounds.append(load("res://sfx/move2.ogg"))

func start_slide(sel_pos, adj_pos, sel_tile, adj_tile):
	$FakeSel.setup_slide(sel_pos, adj_pos, sel_tile)
	$FakeAdj.setup_slide(adj_pos, sel_pos, adj_tile)
	play("MoveFakes")
	$FakeSel/MoveSound.stream = moveSounds[randi() % 2]
	$FakeSel/MoveSound.play()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "MoveFakes":
		$FakeSel.deactivate()
		$FakeAdj.deactivate()
		emit_signal("slide_finished")
