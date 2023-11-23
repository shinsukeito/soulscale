extends Node2D

class_name Camp

var global

var current_npc = ""


# Called when the node enters the scene tree for t he first time.
func _ready():
	global = get_node("/root/Global")
	$CanvasLayer/DayLabel.text = "NIGHT " + str(global.day)
	$CanvasLayer/ProgressLabel.text = "PROGRESS " + str(global.progress)

	var screen_size = get_viewport_rect().size
	var screen_offset = screen_size / 2

	$Camera.clamp_area = Area.new(
		screen_size.x / 2, screen_size.x / 2 + 1120, screen_size.y / 2, screen_size.y / 2
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("menu"):
		get_tree().change_scene_to_file("res://scenes/start.tscn")

	if Input.is_action_just_pressed("shield"):
		if $Dialogue/DialogueBox.visible:
			$Dialogue.trigger()
		else:
			if current_npc != "":
				talk_to_npc()


func on_npc_meet(npc_name):
	current_npc = npc_name


func on_npc_leave():
	current_npc = ""


func talk_to_npc():
	var artifact: Artifact = global.artifact_map[current_npc]

	if artifact.collected:
		if artifact.returned == null:
			$Dialogue.show_messages(Companions.dialogue[current_npc].found_messages[0])
		elif artifact.returned:
			$Dialogue.show_messages(Companions.dialogue[current_npc].after_messages[0])
		else:
			$Dialogue.show_messages(Companions.dialogue[current_npc].after_messages[1])
	else:
		$Dialogue.show_messages(Companions.dialogue[current_npc].daily_messages[global.day - 1])


func _on_sleep_button_pressed():
	global.new_day()
	get_tree().change_scene_to_file("res://scenes/climb.tscn")


func _on_dialogue_artifact_returned(value: bool):
	if current_npc == "":
		return

	var artifact = global.artifact_map[current_npc] as Artifact
	artifact.returned = value
