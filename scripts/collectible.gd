extends Area2D

enum CollectibleType {
	CURRENCY,
	POTION,
	ARTIFACT
}

@export var type: CollectibleType = CollectibleType.CURRENCY

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delt  a' is the elapsed time since the previous frame.
func _process(delta):
	pass 

func _on_body_entered(body):
	if body.name == "Giant":
		match type:
			CollectibleType.CURRENCY:
				body.on_currency(self)
			CollectibleType.POTION:
				body.on_potion(self)
		queue_free()
