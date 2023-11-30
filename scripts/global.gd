extends Node

var debug = false

var max_stamina = 40
var stamina = max_stamina
var day = 1
var day_start_progress = 0
var progress = 0
var currency = 0
var artifact_map: Dictionary = {
	# speed, jump, shield length, max stamina, armor
	"Mercenary": Artifact.new(
		"Flint Knife", 
		Power.new(20, 80, 0, 0, 0)
	),
	"Dad": Artifact.new(
		"Menat",
		Power.new(15, 50, 0.3, 0, 0)
	),
	"Girl": Artifact.new(
		"Oil Lamp",
		Power.new(10, 30, 0, 20, 0)
	),
	"Grandma": Artifact.new(
		"Bust of a God",
		Power.new(10, 30, 0.5, 5, 0)
	),
	"Teen": Artifact.new(
		"Mirror",
		Power.new(10, 20, 1.7, 5, 3)
	),
	"Boy": Artifact.new(
		"Amulet",
		Power.new(10, 40, 0, 5, 5)
	),
	"Cat": Artifact.new(
		"Jewellery",
		Power.new(10, 40, 0, 10, 0)
	),
	"Servant": Artifact.new(
		"Chalice",
		Power.new(10, 0, 0, 20, 0)
	),
}
var artifact_list = []

var artifact_textures = {
	"Amulet": preload("res://assets/visual/Trinkets/amulet.png"),
	"Bust of a God": preload("res://assets/visual/Trinkets/bust.png"),
	"Chalice": preload("res://assets/visual/Trinkets/chalice.png"),
	"Flint Knife": preload("res://assets/visual/Trinkets/flint knife.png"),
	"Jewellery": preload("res://assets/visual/Trinkets/jewellery.png"),
	"Menat": preload("res://assets/visual/Trinkets/menat_rattle.png"),
	"Mirror": preload("res://assets/visual/Trinkets/mirror.png"),
	"Oil Lamp": preload("res://assets/visual/Trinkets/oil lamp.png"),
}
# speed, jump, shield length, max stamina, armor
var base_power: Power = Power.new(160, 800, 1, 40, 0)
var current_power

# Called when the node enters the scene tree for the first time. 
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func new_game():
	max_stamina = 40
	stamina = max_stamina
	day = 1
	progress = 0
	currency = 0
	
	for a in artifact_list as Array[Artifact]:
		a.collected = false
		a.returned = null
			
	# Shuffle artifacts:
	artifact_list = artifact_map.values()
	artifact_list.shuffle()

func new_day():
	stamina = max_stamina
	day += 1
	day_start_progress = progress

func change_stamina(value):
	stamina = clamp(value, 0, max_stamina)
	
func change_currency(value):
	currency = max(value, 0)

func current_artifact_texture():
	return artifact_textures[artifact_list[progress].name]

func artifact_collected():
	artifact_list[progress].collected = true
	
func is_artifact_collected():
	return artifact_list[progress].collected

func artifacts_returned():
	var count = 0
	
	for a in artifact_list as Array[Artifact]:
		if a.returned != null && a.returned == true:
			count += 1

	return count

func calculate_artifact_power(giant):
	var cumulative_power = Power.new(
		base_power.speed,
		base_power.jump,
		base_power.shield_length,
		base_power.max_stamina,
		base_power.armor,
	)
	
	for a in artifact_list as Array[Artifact]:
		if a.returned == null:
			if a.collected:
				cumulative_power.add(a.power)
		else:
			if a.returned == false:
				cumulative_power.add(a.power)
				
	giant.speed = cumulative_power.speed
	giant.jump = cumulative_power.jump
	giant.shield_length = cumulative_power.shield_length
	max_stamina = cumulative_power.max_stamina
	giant.armor = cumulative_power.armor
	
	current_power = cumulative_power
