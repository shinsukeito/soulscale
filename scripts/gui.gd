extends CanvasLayer

var global

# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_node("/root/Global")
	$DayLabel.text = "DAY " + str(global.day) + "/8"
	update_stamina()
	update_currency()
	update_potions()
	update_inventory()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func update_stamina():
	$StaminaBar.value = global.stamina
	$StaminaBar.max_value = global.max_stamina
	$StaminaLabel.text = str(ceil(global.stamina))

func update_currency():
	$CurrencyLabel.text = "x" + str(global.currency)
	update_score()
	
func update_potions():
	$PotionLabel.text = "x" + str(global.potions_collected)
	update_score()

func update_inventory():
	$Inventory.refresh()
	update_score()
	
func update_score():
	$ScoreLabel.text = "SCORE: " + str(global.calculate_score())
