extends CharacterBody2D

signal hazard_hit
signal currency_collected
signal potion_collected
signal artifact_collected

var global
	
@export var speed = 90
@export var friction = 0.6
@export var jump = 400
@export var gravity = 20
@export var shield_length = 0.2
@export var shield_cooldown = 1
@export var flinch_length = 0.05
@export var flinch_force = 5

var armor = 0

var flinching =  false
var shielding =  false
var cooldown = false

var frozen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_node("/root/Global")
	global.calculate_artifact_power(self)
	
	$ShieldTimer.wait_time = shield_length
	$ShieldTimer.wait_time = shield_cooldown
	
	$Sprite2D/AnimationPlayer.play("idle")

func _process(delta):
	update_animation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):	
	velocity.y += gravity
	velocity.x *= friction
	
	if !flinching && !frozen:
		if Input.is_action_pressed("right"):
			velocity.x += speed
			$Sprite2D.scale.x = abs($Sprite2D.scale.x)
		if Input.is_action_pressed("left"):
			velocity.x -= speed
			$Sprite2D.scale.x = -abs($Sprite2D.scale.x)

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

func on_hazard(projectile):
	if shielding || flinching: return
	
	var posDiff = projectile.global_position - global_position
	velocity = Vector2(-flinch_force * posDiff.x, -flinch_force * posDiff.y)
	
	var dmg = min(0, -5 + armor)
	hazard_hit.emit(dmg)
	set_flinch(true)

func on_currency(collectible):
	currency_collected.emit(1)

func on_potion(collectible):
	potion_collected.emit(8)
	
func on_artifact(collectible):
	artifact_collected.emit()
	global.calculate_artifact_power(self)
	
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

# ANIMATIONS

enum State {
	IDLE,
	RUN,
	JUMP,
	FALL,
	LAND,
}

var state = State.IDLE
	
func update_animation():
	match(state):
		State.IDLE:
			if abs(velocity.x) > 10:
				$Sprite2D/AnimationPlayer.play("run")
				state = State.RUN
			if velocity.y < 0:
				$Sprite2D/AnimationPlayer.play("jump")
				state = State.JUMP
			if velocity.y > 0:
				$Sprite2D/AnimationPlayer.play("fall")
				state = State.FALL
		State.RUN:
			if abs(velocity.x) < 10:
				$Sprite2D/AnimationPlayer.play("idle")
				state = State.IDLE
			if velocity.y < 0:
				$Sprite2D/AnimationPlayer.play("jump")
				state = State.JUMP
			if velocity.y > 0:
				$Sprite2D/AnimationPlayer.play("fall")
				state = State.FALL
		State.JUMP:
			if is_on_floor():
				$Sprite2D/AnimationPlayer.play("land")
				state = State.LAND
			else:
				if velocity.y > 0:
					$Sprite2D/AnimationPlayer.play("fall")
					state = State.FALL
		State.FALL:
			if is_on_floor():
				if  Input.is_action_pressed("jump"):
					$Sprite2D/AnimationPlayer.play("jump")
					state = State.JUMP
				else:
					$Sprite2D/AnimationPlayer.play("land")
					state = State.LAND

func _on_animation_player_animation_finished(anim_name):
	match(anim_name):
		"land":
			if abs(velocity.x) > 10:
				$Sprite2D/AnimationPlayer.play("run")
				state = State.RUN
			else:
				$Sprite2D/AnimationPlayer.play("idle")
				state = State.IDLE
