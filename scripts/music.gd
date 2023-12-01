extends Node2D

var prev_music = "title"
var next_music = "title"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $TransitionTimer.is_stopped(): return
	if next_music == prev_music: return
	
	var pct = $TransitionTimer.time_left / $TransitionTimer.wait_time
	
	match(next_music):
		"title":
			$MusicCamp.volume_db = -80 * pct
		"climb":
			$MusicClimb.volume_db = -80 * pct
		"camp":
			$MusicCamp.volume_db = -80 * pct
		"ending":
			$MusicCamp.volume_db = -80 * pct
	
	match(prev_music):
		"title":
			$MusicCamp.volume_db = -80 + (80 * pct)
		"climb":
			$MusicClimb.volume_db = -80 + (80 * pct)
		"camp":
			$MusicCamp.volume_db = -80 + (80 * pct)
		"ending":
			$MusicCamp.volume_db = -80 + (80 * pct)

func switch_music(music, time):
	prev_music = next_music
	next_music = music
	$TransitionTimer.start(time)
