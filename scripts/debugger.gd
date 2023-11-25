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
	
	var text = ""
	for i in global.artifact_list.size():
		var a = global.artifact_list[i] as Artifact
		if i == global.progress:
			text += ">> " + a.name
		else:
			text += a.name
		text += " - Collected: " + str(a.collected) + "; Returned: " + str(a.returned) + ";\n"
	
	text += "POWERS \n"
	text += " -speed: " + str(global.current_power.speed) + " \n"
	text += " -jump: " + str(global.current_power.jump) + " \n"
	text += " -shield: " + str(global.current_power.shield_length) + " \n"
	text += " -stamina: " + str(global.current_power.max_stamina) + " \n"
	text += " -armor: " + str(global.current_power.armor) + " \n"
		
	$Label.text = text

func _toggle():
	on = !on
	visible = on
	global.debug = on
