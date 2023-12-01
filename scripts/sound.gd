extends Node2D

func play_sound(name, variate):
	var stream = find_child(name)
	if !stream: return
	
	if variate:
		stream.pitch_scale = 0.9 + randf() * 0.2
	
	stream.play()
