extends CPUParticles2D

func fire(pos):
	position = pos
	$Timer.start()
	restart()

func _on_Timer_timeout():
	queue_free()
