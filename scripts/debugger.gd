extends CanvasLayer

var global

var on = false

# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_node("/root/Global")
	on = global.debug
	visible = on

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("debug"):
		_toggle()
	
	if !on: return
	
	var text = "Artifacts\n"
	for i in global.artifact_list.size():
		var a = global.artifact_list[i]
		if i == global.progress:
			text += "> " + a.name + "\n"
		else:
			text += a.name + "\n"
		text += " - collected: " + str(a.collected) + "\n"
	
	$Label.text = text

func _toggle():
	on = !on
	visible = on
	global.debug = on
