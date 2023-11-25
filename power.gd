class_name Power

var speed = 0
var jump = 0
var shield_length = 0
var max_stamina = 0
var armor = 0

func _init(speed, jump, shield_length, max_stamina, armor):
	self.speed = speed
	self.jump = jump
	self.shield_length = shield_length
	self.max_stamina = max_stamina
	self.armor = armor

func add(power: Power):
	self.speed += power.speed
	self.jump += power.jump
	self.shield_length += power.shield_length
	self.max_stamina += power.max_stamina
	self.armor += power.armor
