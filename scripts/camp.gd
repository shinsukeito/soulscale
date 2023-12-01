extends Node2D

class_name Camp

var global: Global

var current_npc = ""


# Called when the node enters the scene tree for t he first time.
func _ready():
	global = get_node("/root/Global")

	var screen_size = get_viewport_rect().size
	var screen_offset = screen_size / 2

	$Camera.clamp_area = Area.new(
		screen_size.x / 2, screen_size.x / 2 + 1120, screen_size.y / 2, screen_size.y / 2
	)
	
	$Transition.fade(true)
	$Giant.frozen = true


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
	if current_npc == "Tent":
		for a in global.artifact_list:
			if a.collected && a.returned == null:
				$Dialogue.show_messages(current_npc, ["[i]I can't go to sleep yet. Some people still want to talk to me."])
				return
		
		$Transition.fade(false)
		return
	
	var artifact: Artifact = global.artifact_map[current_npc]

	if artifact.collected:
		if artifact.returned == null:
			$Dialogue.show_messages(current_npc, Companions.dialogue[current_npc].found_messages[0])
		elif artifact.returned:
			$Dialogue.show_messages(current_npc, Companions.dialogue[current_npc].after_messages[0])
		else:
			$Dialogue.show_messages(current_npc, Companions.dialogue[current_npc].after_messages[1])
	else:
		$Dialogue.show_messages(current_npc, Companions.dialogue[current_npc].daily_messages[global.day - 1])


func _on_dialogue_artifact_returned(value: bool):
	if current_npc == "":
		return

	var artifact = global.artifact_map[current_npc] as Artifact
	artifact.returned = value
	
	var npc = find_child(current_npc, false)
	npc.hide_marker()
	
	if value:
		$Dialogue.show_messages(current_npc, Companions.dialogue[current_npc].after_messages[0])
	else:
		$Dialogue.show_messages(current_npc, Companions.dialogue[current_npc].after_messages[1])
	
	$Tent.refresh_marker()
	$GUI.update_inventory()
	
	global.calculate_artifact_power($Giant)


func _on_transition_fade_in_completed():
	$Giant.frozen = false 

func _on_transition_fade_out_completed():
	global.new_day()
	
	if global.day < 8 && global.progress < 7:
		get_tree().change_scene_to_file("res://scenes/climb.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/ending.tscn")
