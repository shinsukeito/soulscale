extends Node2D

var global
var sound

# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_node("/root/Global")
	sound = get_node("/root/Sound")
	
	global.new_game()
	
	$Transition.fade(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_start_button_pressed():
	$Transition.fade(false)
	get_node("/root/Music").switch_music("climb", 2)
	sound.play_sound("Click", false)

func _on_quit_button_pressed():
	get_tree().quit() 
	sound.play_sound("Click", false)

func _on_transition_fade_in_completed():
	$GUI/StartButton.disabled = false
	$GUI/QuitButton.disabled = false

func _on_transition_fade_out_completed():
	get_tree().change_scene_to_file("res://scenes/climb.tscn")


