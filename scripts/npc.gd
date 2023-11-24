extends Area2D

var global: Global
var camp: Camp

# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_node("/root/Global")
	camp = get_parent()
	var a = global.artifact_map[self.name] as Artifact
	if a.collected && a.returned == null:
		$Marker.visible = true

func hide_marker():
	$Marker.visible = false

func _on_body_entered(body):
	if body.name == "Giant":
		$Indicator.visible = true
		camp.on_npc_meet(self.name)

func _on_body_exited(body):
	if body.name == "Giant":
		$Indicator.visible = false
		camp.on_npc_leave()
