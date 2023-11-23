extends Area2D

@export var npc_name = "Mercenary"

var camp: Camp

# Called when the node enters the scene tree for the first time.
func _ready():
	camp = get_parent()

func _on_body_entered(body):
	if body.name == "Giant":
		$Indicator.visible = true
		camp.on_npc_meet(npc_name)

func _on_body_exited(body):
	if body.name == "Giant":
		$Indicator.visible = false
		camp.on_npc_leave()
