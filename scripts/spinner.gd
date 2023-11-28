extends Node2D

var projectile_scene: PackedScene = load("res://scenes/climb/hazards/projectile.tscn")

@export var radius = 100
@export var projectile_count = 9
@export var frequency = 5 
@export var t = 0
@export var clockwise = false

var projectiles: Array[Projectile] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	create_projectiles()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var angle = (t / frequency) * 2 * PI
	var x = sin(angle) * radius
	var y = cos(angle) * radius
	
	for i in projectile_count:
		var h = projectiles[i]
		var ratio = float(i) / projectile_count
		h.position = Vector2(x * ratio, y * ratio)
	
	if clockwise:
		t -= delta
	else:
		t += delta
		
	if t > frequency:
		t -= frequency
	if t < 0:
		t += frequency

func create_projectiles():
	for i in projectile_count:
		var projectile = projectile_scene.instantiate() as Projectile
		var ratio = (i + 1 / projectile_count) * radius
		projectile.position = Vector2(0, ratio)
		projectiles.push_front(projectile)
		add_child(projectile)
