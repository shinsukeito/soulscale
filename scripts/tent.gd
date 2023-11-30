extends Area2D

var global: Global
var camp: Camp

func _ready():
	global = get_node("/root/Global")
	camp = get_parent()
	refresh_marker()
		
func refresh_marker():
	for a in global.artifact_list:
		if a.collected && a.returned == null:
			$Marker.visible = false
			return

	$Marker.visible = true
	
func _on_body_entered(body):
	if body.name == "Giant":
		$Indicator.visible = true
		camp.on_npc_meet(self.name)

func _on_body_exited(body):
	if body.name == "Giant":
		$Indicator.visible = false
		camp.on_npc_leave()
