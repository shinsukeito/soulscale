extends Area2D

enum CollectibleType {
	CURRENCY,
	POTION,
	ARTIFACT
}

@export var type: CollectibleType = CollectibleType.CURRENCY

var giant
var collected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delt  a' is the elapsed time since the previous frame.
func _process(delta):
	if !collected: return
	
	var diff = (giant.global_position - global_position) * 0.3
	global_position = global_position + diff
	
	var time = $CollectTimer.time_left / $CollectTimer.wait_time
	$Sprite2D.modulate.a = time
	$Glow.modulate.a = time

func _on_body_entered(body):
	if collected: return
	
	if body.name == "Giant":
		collected = true
		giant = body
		$CollectTimer.start()
		match type:
			CollectibleType.CURRENCY:
				body.on_currency(self)
			CollectibleType.POTION:
				body.on_potion(self)
			CollectibleType.ARTIFACT:
				body.on_artifact(self)


func _on_collect_timer_timeout():
	queue_free()
