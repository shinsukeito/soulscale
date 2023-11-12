extends Area2D

@export var initial_velocity = Vector2(0, -80)
@export var bounces = 0
@export var destroy_on_hit = true

var velocity = initial_velocity
var bounced = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity * delta
	pass


func _on_body_entered(body):
	if body.name == "Terrain":
		if bounces == 0:
			velocity = -velocity
		else:
			if bounced < bounces:
				velocity = -velocity
				bounced += 1
			else:
				queue_free()
	elif body.name == "Giant":
		body.on_hazard(self)
		if destroy_on_hit:
			queue_free()
