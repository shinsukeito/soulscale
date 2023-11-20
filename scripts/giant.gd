extends CharacterBody2D

signal hazard_hit
signal currency_collected
signal potion_collected
signal artifact_collected

@export var speed = 90
@export var friction = 0.7
@export var jump = 400
@export var gravity = 20
@export var shield_length = 0.2
@export var shield_cooldown = 1
@export var flinch_length = 0.05
@export var flinch_force = 5

var flinching =  false
var shielding =  false
var cooldown = false

var frozen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$ShieldTimer.wait_time = shield_length
	$ShieldTimer.wait_time = shield_cooldown

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):	
	velocity.y += gravity
	velocity.x *= friction
	
	if !flinching && !frozen:
		if Input.is_action_pressed("right"):
			velocity.x += speed
			$Sprite2D.flip_h = false
		if Input.is_action_pressed("left"):
			velocity.x -= speed
			$Sprite2D.flip_h = true

		if Input.is_action_pressed("jump") && is_on_floor():
			velocity.y = -jump
			
		if Input.is_action_pressed("shield") && !cooldown:
			set_shielding(true)
			cooldown = true

	move_and_slide()

func set_shielding(value):
	shielding = value
	if value:
		$Sprite2D.set_modulate(Color(0.7, 1, 0.7, 1))
		$ShieldTimer.start(shield_length)
	else:
		$Sprite2D.set_modulate(Color(0.75, 0.75, 0.75, 1))
		$ShieldCooldownTimer.start(shield_cooldown)
	
func set_flinch(value):
	flinching = value
	
	if value:
		$Sprite2D.set_modulate(Color(0.75, 0.75, 0.75, 1))
		$FlinchTimer.start(flinch_length)
	else:
		$Sprite2D.set_modulate(Color(1, 1, 1, 1))

func on_hazard(hazard):
	if shielding || flinching: return
	
	var posDiff = hazard.global_position - global_position
	velocity = Vector2(-flinch_force * posDiff.x, -flinch_force * posDiff.y)
		
	hazard_hit.emit(-5)
	set_flinch(true)

func on_currency(collectible):
	currency_collected.emit(1)

func on_potion(collectible):
	potion_collected.emit(8)
	
func on_artifact(collectible):
	artifact_collected.emit()
	
func refresh_shield():
	shielding = false
	cooldown = false
	$ShieldTimer.stop()
	$ShieldCooldownTimer.stop()
	$Sprite2D.set_modulate(Color(1, 1, 1, 1))

func _on_shield_timer_timeout():
	set_shielding(false)

func _on_shield_cooldown_timer_timeout():
	$Sprite2D.set_modulate(Color(1, 1, 1, 1))
	cooldown = false

func _on_flinch_timer_timeout():
	set_flinch(false)
