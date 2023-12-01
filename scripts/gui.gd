extends CanvasLayer

var global

# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_node("/root/Global")
	$DayLabel.text = "DAY " + str(global.day) + "/8"
	$ProgressLabel.text = "PROGRESS " + str(global.progress + 1) + "/8"
	$StaminaBar.max_value = global.max_stamina
	$CurrencyLabel.text = str(global.currency)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func update_progress_label():
	$ProgressLabel.text = "PROGRESS " + str(global.progress)

func update_stamina():
	$StaminaBar.value = global.stamina
	$StaminaBar.max_value = global.max_stamina
	$StaminaLabel.text = str(ceil(global.stamina))

func update_currency():
	$CurrencyLabel.text = str(global.currency)

func update_inventory():
	$Inventory.refresh()
