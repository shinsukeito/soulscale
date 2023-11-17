extends Area2D

@export var npc_name = "Mercenary"

var dialogue: CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	dialogue = get_parent().get_node("Dialogue")

func _on_body_entered(body):
	if body.name == "Giant":
		$Indicator.visible = true
		dialogue.on_npc_meet(npc_name)

func _on_body_exited(body):
	if body.name == "Giant":
		$Indicator.visible = false
		dialogue.on_npc_leave()
