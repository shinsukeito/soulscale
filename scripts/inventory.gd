extends Node2D

var global

const return_color = Color(0, 0, 0, 0.6)

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
	
	for i in global.artifact_list.size():
		var a = global.artifact_list[i] as Artifact
		match a.name:
			"Oil Lamp":
				$Lamp.position.x = i * 50
			"Flint Knife":
				$Knife.position.x = i * 50
			"Menat":
				$Menat.position.x = i * 50
			"Bust of a God":
				$Bust.position.x = i * 50
			"Mirror":
				$Mirror.position.x = i * 50
			"Amulet":
				$Amulet.position.x = i * 50
			"Jewellery":
				$Jewellery.position.x = i * 50
			"Chalice":
				$Chalice.position.x = i * 50
	
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
				$Lamp/Artifact.modulate = return_color
			"Flint Knife":
				$Knife/Artifact.modulate = return_color
			"Menat":
				$Menat/Artifact.modulate = return_color
			"Bust of a God":
				$Bust/Artifact.modulate = return_color
			"Mirror":
				$Mirror/Artifact.modulate = return_color
			"Amulet":
				$Amulet/Artifact.modulate = return_color
			"Jewellery":
				$Jewellery/Artifact.modulate = return_color
			"Chalice":
				$Chalice/Artifact.modulate = return_color
