extends Node2D

var global: Global

var count = 0
var weighed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_node("/root/Global")
	count = global.artifacts_returned()
	weighed = false
	
	$Transition.fade(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("shield"):
		if $Dialogue/DialogueBox.visible:
			$Dialogue.trigger()


func _on_dialogue_finished_speaking():
	if !weighed:
		$WeighingTimer.start()
	else:
		$Transition.fade(false)
		if count < 4:
			get_node("/root/Music").switch_music("climb", 2)
		elif count < 8:
			get_node("/root/Music").switch_music("title", 2)
		elif count == 8:
			get_node("/root/Music").switch_music("title", 2)

func _on_weighing_timer_timeout():
	weighed = true
	if count < 4:
		$Dialogue.show_messages("Anubis", Anubis.dialogue.lose_messages)
	elif count < 8:
		$Dialogue.show_messages("Anubis", Anubis.dialogue.win_messages)
	elif count == 8:
		$Dialogue.show_messages("Anubis", Anubis.dialogue.big_win_messages)


func _on_transition_fade_in_completed():
	$Dialogue.show_messages("Anubis", Anubis.dialogue.initial_messages)


func _on_transition_fade_out_completed():
	if count < 4:
		global.new_game()
		get_tree().change_scene_to_file("res://scenes/climb.tscn")
	elif count < 8:
		get_tree().change_scene_to_file("res://scenes/start.tscn")
	elif count == 8:
		get_tree().change_scene_to_file("res://scenes/start.tscn")
