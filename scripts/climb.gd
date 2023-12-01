extends Node2D

var global: Global
	
@export var room_scenes:Array[PackedScene]

var rng = RandomNumberGenerator.new()

var modules = [] 
var screen_size
var map_area = Area.new(0, 0, 0, 0)

var starting = true

# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_node("/root/Global")
	
	screen_size = get_viewport_rect().size
	generate_room(1920 + global.progress * 350)
	
	$Camera.clamp_area = Area.new(
		map_area.x_min + screen_size.x / 2,
		map_area.x_max - screen_size.x / 2,
		map_area.y_min + screen_size.y / 2,
		map_area.y_max - screen_size.y / 2,
	)
	
	if !global.is_artifact_collected():
		spawn_artifact()
	
	if global.day_start_progress != global.progress:
		$Transition.fade_in_time = 0.2
	
	$Transition.fade(true)
	$Giant.frozen = true

# Called every frame. 'delta' is the elapsed time since the previ ous frame.
func _process(delta):
	if Input.is_action_pressed("menu"):
		get_tree().change_scene_to_file("res://scenes/start.tscn")
		get_node("/root/Music").switch_music("title", 2)
		
	if starting || global.stamina <= 0: return
		
	change_stamina(-delta)
	
	if $Giant.position.x >= map_area.x_max:
		change_room()
		
	if $Giant.position.y >= map_area.y_max:
		change_stamina(-1000)

# ROOM GENERATION:

func generate_room(width):
	var offset = Vector2(0, 0)
	var n = 0
	
	while offset.x < width:
		offset = generate_module(n, offset)
		n += 1
	
	map_area.x_max = offset.x
	
func generate_module(value, offset):
	if value in modules: return
	
	var index = rng.randi_range(0, room_scenes.size() - 1)
	
	var new_room = room_scenes[index].instantiate()
	new_room.position = offset
	new_room.name = "room_" + str(index)
	$Terrain.add_child(new_room)
	
	modules.push_front(new_room)
	
	var top = new_room.position.y
	var bot = new_room.position.y + new_room.height()
	
	if bot > map_area.y_max: map_area.y_max = bot
	if top < map_area.y_min: map_area.y_min = top
	
	return offset + Vector2(new_room.width(), new_room.height_difference())

func change_stamina(value):
	if !$Transition/FadeTimer.is_stopped(): return
	
	global.change_stamina(global.stamina + value)
	$GUI.update_stamina()
	
	if global.stamina <= 0:
		$Transition.fade(false)
		get_node("/root/Music").switch_music("camp", 2)

func change_currency(value):
	global.change_currency(global.currency + value)
	$GUI.update_currency()
		
func change_room():
	if global.progress == 7:
		$Transition.fade(false)
		get_node("/root/Music").switch_music("camp", 2)
		return
		
	change_stamina(5)
	global.progress += 1
	$Giant.refresh_shield()
	get_tree().reload_current_scene()
# 

func spawn_artifact():
	modules.shuffle()
	modules[0].spawn_artifact()

# SIGNALS:

func _on_giant_hazard_hit(amount):
	change_stamina(amount)

func _on_giant_currency_collected(amount):
	change_currency(amount)

func _on_giant_potion_collected(amount):
	change_stamina(amount)
	$GUI.update_potions()

func _on_giant_artifact_collected():
	global.artifact_collected()
	$GUI.update_inventory()


func _on_transition_fade_in_completed():
	$Giant.frozen = false
	starting = false


func _on_transition_fade_out_completed():
	get_tree().change_scene_to_file("res://scenes/camp.tscn")
	global.stamina = global.max_stamina
