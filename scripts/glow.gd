extends Sprite2D


@export var gradient: Gradient
@export var timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start()
	modulate = gradient.sample(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mod = (timer.time_left / timer.wait_time) * 2 * PI
	var offset = (sin(mod) + 1) / 2
	var s = offset * 0.3 + 0.7
	var a = modulate.a
	
	modulate = gradient.sample(offset)
	modulate.a = a
	scale = Vector2(s, s)
