extends StaticBody2D

var projectile_scene: PackedScene = load("res://scenes/climb/hazards/projectile.tscn")

var giant

@export var shoot_frequency = 1.35
@export var t = 0

@export var projectile_speed = 160
@export var projectile_homing = false

@export var targeting = false
@export var detect_radius = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	giant = get_node("/root/Climb/Giant")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if giant == null: return
	if detect_radius != 0 && global_position.distance_to(giant.global_position) > detect_radius: return
	
	t += delta
	
	if t > shoot_frequency:
		shoot()
		t -= shoot_frequency
	
	if targeting:
		look_at(giant.position)

func shoot():
	print('shoot')
	var projectile = projectile_scene.instantiate() as Projectile
	var velocity = Vector2(cos(rotation), sin(rotation)) * projectile_speed
	
	projectile.position = position
	projectile.velocity = velocity
	projectile.ignore_giant = false
	projectile.ignore_terrain = false
	projectile.homing = projectile_homing
	projectile.homing_speed = projectile_speed
	
	get_parent().add_child(projectile)
