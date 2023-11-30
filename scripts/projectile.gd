extends Area2D

class_name Projectile

var giant

var ignore_giant = true
var ignore_terrain = true

var bounces = 0
var bounced = 0

var homing = false
var homing_speed = 70

var velocity = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	giant = get_node("/root/Climb/Giant")

# Called every  frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if giant == null: return

	position += velocity * delta
	rotation = velocity.angle()
	
	if homing:
		home()

func home():
	var target = giant.global_position - global_position as Vector2
	var normal = target.normalized()
	var new_velocity = lerp(velocity, normal, 0.85).normalized()
	velocity = new_velocity * homing_speed

func _on_body_entered(body):
	if body.name == "Terrain":
		if ignore_terrain: return
		
		if bounces < 0:
			velocity = -velocity
		else:
			if bounced < bounces:
				velocity = -velocity
				bounced += 1
			else:
				queue_free()
	elif body.name == "Giant":
		body.on_hazard(self)
		if !ignore_giant:
			queue_free()
