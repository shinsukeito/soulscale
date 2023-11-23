extends Node2D

var global: Global
	
@export var room_scenes:Array[PackedScene]

var rng = RandomNumberGenerator.new()

var modules = []
var screen_size
var map_size

# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_node("/root/Global")
	
	screen_size = get_viewport_rect().size
	map_size = generate_room(1920 +  global.progress * 200)
	
	$Camera.clamp_area = Area.new(
		screen_size.x / 2,
		map_size.x - screen_size.x / 2,
		screen_size.y / 2 + map_size.y,
		screen_size.y / 2
	)
	
	if !global.is_artifact_collected():
		spawn_artifact()
	
	$GUI.update_stamina()

# Called every frame. 'delta' is the elapsed time since the previ ous frame.
func _process(delta):
	if Input.is_action_pressed("menu"):
		get_tree().change_scene_to_file("res://scenes/start.tscn")
		
	change_stamina(-delta)
	
	# TODO: Remove this
	if Input.is_action_pressed("jump") && Input.is_action_pressed("shield") && Input.is_action_just_pressed("left"):
		change_stamina(-20)
	if Input.is_action_pressed("jump") && Input.is_action_pressed("shield") && Input.is_action_just_pressed("right"):
		change_room()
	
	if $Giant.position.x >= map_size.x:
		change_room()

# ROOM GENERATION:

func generate_room(width):
	var offset = Vector2(0, 0)
	var n = 0
	
	while offset.x < width:
		offset = generate_module(n, offset)
		n += 1
		
	return offset
	
func generate_module(value, offset):		
	if value in modules: return
	
	var index = rng.randi_range(0, room_scenes.size() - 1)
	
	var new_room = room_scenes[index].instantiate()
	new_room.position = offset
	new_room.name = "room_" + str(index)
	$Terrain.add_child(new_room)
	
	modules.push_front(new_room)
	
	return offset + Vector2(new_room.width(), -new_room.height_difference())

func change_stamina(value):
	global.change_stamina(global.stamina + value)
	$GUI.update_stamina()
	
	if global.stamina <= 0:
		if global.day < 8:
			get_tree().change_scene_to_file("res://scenes/camp.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/start.tscn")

func change_currency(value):
	global.change_currency(global.currency + value)
	$GUI.update_currency()
		
func change_room():
	change_stamina(5)
	global.progress += 1
	$Giant.refresh_shield()
	
	if global.progress < 8:
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene_to_file("res://scenes/ending.tscn")
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

func _on_giant_artifact_collected():
	global.artifact_collected()
	$GUI.update_inventory()
