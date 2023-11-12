extends Node2D

var global

# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_node("/root/Global")
	$CanvasLayer/DayLabel.text = "NIGHT " + str(global.day)
	$CanvasLayer/ProgressLabel.text = "PROGRESS " + str(global.progress)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_sleep_button_pressed():
	global.new_day()
	
	get_tree().change_scene_to_file("res://scenes/climb/climb.tscn")
