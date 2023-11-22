extends Node2D

var global

# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_node("/root/Global")
	refresh()

func refresh():
	for a in global.artifact_list as Array[Artifact]:
		if a.collected:
			set_collected(a.name)
		
		if a.returned:
			pass

func set_collected(name):
		match name:
			"Oil Lamp":
				$Lamp/Artifact.visible = true
			"Flint Knife":
				$Knife/Artifact.visible = true
			"Menat":
				$Menat/Artifact.visible = true
			"Bust of a God":
				$Bust/Artifact.visible = true
			"Mirror":
				$Mirror/Artifact.visible = true
			"Amulet":
				$Amulet/Artifact.visible = true
			"Jewellery":
				$Jewellery/Artifact.visible = true
			"Chalice":
				$KChalice/Artifact.visible = true