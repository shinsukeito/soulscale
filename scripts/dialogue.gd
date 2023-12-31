extends CanvasLayer

signal finished_speaking
signal artifact_returned

var sound
var global: Global

@export var left = true
@export var left_offset = Vector2(20, 476)
@export var right_offset = Vector2(558, 476)

var giant: CharacterBody2D

var questioning = false

var message_queue = []

# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_node("/root/Global")
	sound = get_node("/root/Sound")
	giant = get_parent().get_node("Giant")

	if left:
		$DialogueBox.set_position(left_offset)
	else:
		$DialogueBox.set_position(right_offset)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !questioning: return
	
	if Input.is_action_just_pressed("left"):
		sound.play_sound("Hover", false)
		$DialogueBox.left_pressed()
	elif Input.is_action_just_pressed("right"):
		sound.play_sound("Hover", false)
		$DialogueBox.right_pressed()


func show_messages(companion, messages):
	message_queue = messages.duplicate()
	_show_dialogue_box(true)
	_show_next_message()
	
	for p in $Portraits.get_children():
		if p.name == companion:
			p.visible = true
		else:
			p.visible = false


func _show_next_message():
	var message = message_queue.pop_front() as String
	if message.begins_with("-return"):
		$DialogueBox.set_selection(null)
		questioning = true

	if message != null:
		$DialogueBox.say(message)


func trigger():
	sound.play_sound("Click", false)
	if $DialogueBox.speaking():
		$DialogueBox.skip()
	elif questioning:
		$DialogueBox.select_pressed()
	elif !questioning:
		if message_queue.size() > 0:
			_show_next_message()
		else:
			_show_dialogue_box(false)
			finished_speaking.emit()


func _show_dialogue_box(show):
	if show:
		$DialogueBox.visible = true
		$Portraits.visible = true
		if giant: giant.frozen = true
	else:
		$DialogueBox.visible = false
		$Portraits.visible = false
		if giant: giant.frozen = false


func _on_dialogue_box_finished_speaking():
	if questioning:
		$DialogueBox/Answers.visible = true


func _on_dialogue_box_no():
	_set_returned(false)
	questioning = false


func _on_dialogue_box_yes():
	_set_returned(true)
	questioning = false


func _set_returned(value):
	if !questioning: return

	artifact_returned.emit(value)
