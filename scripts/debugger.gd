extends CanvasLayer

var on = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("debug"):
		_toggle()
	
	if !on: return
	

func _toggle():
	on = !on
	visible = on
