extends Node

var debug = false

var max_stamina = 40
var stamina = max_stamina
var day = 1
var day_start_progress = 0
var progress = 0
var currency = 0
var artifact_map: Dictionary = {
	"Mercenary": Artifact.new("Flint Knife"),
	"Dad": Artifact.new("Menat"),
	"Girl": Artifact.new("Oil Lamp"),
	"Grandma": Artifact.new("Bust of a God"),
	"Teen": Artifact.new("Mirror"),
	"Boy": Artifact.new("Amulet"),
	"Cat": Artifact.new("Jewellery"),
	"Servant": Artifact.new("Chalice"),
}
var artifact_list = []

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
