extends CanvasLayer

signal fade_in_completed
signal fade_out_completed

@export var fade_in_time: float
@export var fade_out_time: float

var fade_in = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $FadeTimer.is_stopped(): return
	
	if fade_in:
		var pct = $FadeTimer.time_left / fade_in_time
		$Colour.color.a = pct
	else:
		var pct = $FadeTimer.time_left / fade_out_time
		$Colour.color.a = 1 - pct

func fade(fade_in):
	if !$FadeTimer.is_stopped(): return
	
	self.fade_in = fade_in
	if fade_in:
		$FadeTimer.start(fade_in_time)
	else:
		$FadeTimer.start(fade_out_time)
	
func _on_fade_timer_timeout():
	if fade_in:
		fade_in_completed.emit()
	else:
		fade_out_completed.emit()
