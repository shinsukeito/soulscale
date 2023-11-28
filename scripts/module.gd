
extends Node2D

var global

var artifact_scene: PackedScene = load("res://scenes/climb/collectibles/artifact.tscn")

@export var tile_size = 32
@export var start_height = 17
@export var end_height = 13

var area: Area

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_node("/root/Global")
	var cells = $Terrain.get_used_cells(0)
	var a = Area.new(0, 0, 0, 0)
	for cell in cells:
		if cell.x < a.x_min:
			a.x_min = cell.x
		if cell.x > a.x_max:
			a.x_max = cell.x
		if cell.y < a.y_min:
			a.y_min = cell.x
		if cell.y > a.y_max:
			a.y_max = cell.x
	
	area = a

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func spawn_artifact():
	if $ArtifactSpawner == null: return
	
	var a = artifact_scene.instantiate()
	a.get_child(0).texture = global.current_artifact_texture()
	
	if $ArtifactSpawner.get_children().size() > 1:
		$ArtifactSpawner.get_children().shuffle()
		
	a.position = $ArtifactSpawner.get_children()[0].position
	add_child(a)
	
func height_difference():
	return (start_height - end_height) * tile_size

func width():
	return (area.x_max - area.x_min) * tile_size
