extends Node2D

var global: Global

var count = 0
var weighed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_node("/root/Global")
	count = global.artifacts_returned()
	weighed = false
	
	$Dialogue.show_messages(Anubis.dialogue.initial_messages)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("shield"):
		if $Dialogue/DialogueBox.visible:
			$Dialogue.trigger()


func _on_dialogue_finished_speaking():
	if !weighed:
		$WeighingTimer.start()
	else:
		if count < 4:
			global.new_game()
			get_tree().change_scene_to_file("res://scenes/climb.tscn")
		elif count < 7:
			get_tree().change_scene_to_file("res://scenes/start.tscn")
		elif count == 8:
			get_tree().change_scene_to_file("res://scenes/start.tscn")

func _on_weighing_timer_timeout():
	weighed = true
	if count < 4:
		$Dialogue.show_messages(Anubis.dialogue.lose_messages)
	elif count < 7:
		$Dialogue.show_messages(Anubis.dialogue.win_messages)
	elif count == 8:
		$Dialogue.show_messages(Anubis.dialogue.big_win_messages)
