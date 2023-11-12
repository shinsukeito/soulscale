
extends Node2D

@export var tile_size = 32
@export var start_height = 17
@export var end_height = 13
@export var hazard_scene: PackedScene

var tile_width = 0

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var cells = $Terrain.get_used_cells(0)
	var minx = 0
	var maxx = 0
	var miny = 0
	var maxy = 0
	for cell in cells:
		if cell.x < minx:
			minx = cell.x
		if cell.x > maxx:
			maxx = cell.x
		if cell.y < miny:
			miny = cell.x
		if cell.y > maxy:
			maxy = cell.x
	
	tile_width = maxx - minx
	
	for n in 2:
		create_hazards()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func create_hazards():
	var hazard = hazard_scene.instantiate()
	var spawn_path = get_node("HazardPath/HazardSampler")
	spawn_path.progress_ratio = randf()
	
	hazard.position = spawn_path.position
	
	add_child(hazard)

func height_difference():
	return (start_height - end_height) * tile_size

func width():
	return tile_width * tile_size
