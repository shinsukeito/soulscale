extends Node2D

var global

# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_node("/root/Global")
	
	$Lamp/Artifact.texture = global.artifact_textures["Oil Lamp"]
	$Knife/Artifact.texture = global.artifact_textures["Flint Knife"]
	$Menat/Artifact.texture = global.artifact_textures["Menat"]
	$Bust/Artifact.texture = global.artifact_textures["Bust of a God"]
	$Mirror/Artifact.texture = global.artifact_textures["Mirror"]
	$Amulet/Artifact.texture = global.artifact_textures["Amulet"]
	$Jewellery/Artifact.texture = global.artifact_textures["Jewellery"]
	$Chalice/Artifact.texture = global.artifact_textures["Chalice"]
	
	refresh()

func refresh():
	for a in global.artifact_list as Array[Artifact]:
		if a.collected:
			set_collected(a.name)
		
		if a.returned:
			set_returned(a.name)

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
				$Chalice/Artifact.visible = true

func set_returned(name):
		match name:
			"Oil Lamp":
				$Lamp/Tick.visible = true
			"Flint Knife":
				$Knife/Tick.visible = true
			"Menat":
				$Menat/Tick.visible = true
			"Bust of a God":
				$Bust/Tick.visible = true
			"Mirror":
				$Mirror/Tick.visible = true
			"Amulet":
				$Amulet/Tick.visible = true
			"Jewellery":
				$Jewellery/Tick.visible = true
			"Chalice":
				$Chalice/Tick.visible = true
