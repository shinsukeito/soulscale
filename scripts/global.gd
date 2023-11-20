extends Node

var max_stamina = 40
var stamina = max_stamina
var day = 1
var progress = 0
var currency = 0
var artifact_list: Array[Artifact] = [
	 Artifact.new("Flint Knife", "Mercenary"),
	 Artifact.new("Menat", "Dad"),
	 Artifact.new("Oil Lamp", "Firl"),
	 Artifact.new("Bust of a God", "Grandma"),
	 Artifact.new("Mirror", "Teen"),
	 Artifact.new("Amulet", "Boy"),
	 Artifact.new("Jewellery", "Cat"),
	 Artifact.new("Chalice", "Servant"),
]

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
	
	# Shuffle artifacts:
	artifact_list = [
		 Artifact.new("Flint Knife", "Mercenary"),
		 Artifact.new("Menat", "Dad"),
		 Artifact.new("Oil Lamp", "Girl"),
		 Artifact.new("Bust of a God", "Grandma"),
		 Artifact.new("Mirror", "Teen"),
		 Artifact.new("Amulet", "Boy"),
		 Artifact.new("Jewellery", "Cat"),
		 Artifact.new("Chalice", "Servant"),
	]
	artifact_list.shuffle()

func new_day():
	stamina = max_stamina
	day += 1

func change_stamina(value):
	stamina = clamp(value, 0, max_stamina)
	
func change_currency(value):
	currency = max(value, 0)

func artifact_collected():
	artifact_list[progress].collected = true
