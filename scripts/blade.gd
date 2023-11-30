extends Area2D

class_name Blade

func _process(delta):
	rotation += 5 * delta

func _on_body_entered(body):
	if body.name == "Giant":
		body.on_hazard(self)
