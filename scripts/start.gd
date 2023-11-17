extends Node2D

var global

# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_node("/root/Global")
	global.new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/climb/climb.tscn")

func _on_quit_button_pressed():
	get_tree().quit() 
