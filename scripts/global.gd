extends Node

var max_stamina = 40
var stamina = max_stamina
var day = 1
var progress = 0
var currency = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func new_day():
	stamina = max_stamina
	day += 1

func change_stamina(value):
	stamina = clamp(value, 0, max_stamina)
	
func change_currency(value):
	currency = max(value, 0)
	
