extends Node2D

var prev_stream: AudioStreamPlayer
var current_stream: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	prev_stream = find_child("title")
	current_stream = find_child("title")
	current_stream.play(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $TransitionTimer.is_stopped(): return
	
	var pct = $TransitionTimer.time_left / $TransitionTimer.wait_time
	
	current_stream.volume_db = -80 * pct
	prev_stream.volume_db = -80 + (80 * pct)

func switch_music(music, time):
	if current_stream.name == music: return
	
	prev_stream = current_stream
	current_stream = find_child(music)
	
	# Sync music
	current_stream.play(prev_stream.get_playback_position())
	
	$TransitionTimer.start(time)


func _on_transition_timer_timeout():
	prev_stream.stop()
