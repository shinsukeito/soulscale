extends CanvasLayer

signal finished_speaking
signal artifact_returned

var global: Global

@export var left = true
@export var left_offset = Vector2(20, 476)
@export var right_offset = Vector2(558, 476)

var giant: CharacterBody2D

var questioning = false

var message_queue = []

var portrait_map = {
	"Mercenary": preload("res://assets/visual/Characters/Mercenary.png"),
	"Dad": preload("res://assets/visual/Characters/Dad.png"),
	"Girl": preload("res://assets/visual/Characters/Girl.png"),
	"Grandma": preload("res://assets/visual/Characters/Grandma.png"),
	"Teen": preload("res://assets/visual/Characters/Teen.png"),
	"Cat": preload("res://assets/visual/Characters/Cat.png"),
	"Boy": preload("res://assets/visual/Characters/Boy.png"),
	"Servant": preload("res://assets/visual/Characters/Servant.png"),
	"Anubis": preload("res://assets/visual/Characters/Anubis.png"),
}

# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_node("/root/Global")
	giant = get_parent().get_node("Giant")

	if left:
		$DialogueBox.set_position(left_offset)
	else:
		$DialogueBox.set_position(right_offset)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func show_messages(companion, messages):
	message_queue = messages.duplicate()
	_show_dialogue_box(true)
	_show_next_message()
	
	$Companion.texture = portrait_map[companion]


func _show_next_message():
	var message = message_queue.pop_front() as String
	if message.begins_with("-return"):
		questioning = true

	if message != null:
		$DialogueBox.say(message)


func trigger():
	if $DialogueBox.speaking():
		$DialogueBox.skip()
	elif !questioning:
		if message_queue.size() > 0:
			_show_next_message()
		else:
			_show_dialogue_box(false)
			finished_speaking.emit()


func _show_dialogue_box(show):
	if show:
		$DialogueBox.visible = true
		$Companion.visible = true
		if giant: giant.frozen = true
	else:
		$DialogueBox.visible = false
		$Companion.visible = false
		if giant: giant.frozen = false


func _on_dialogue_box_finished_speaking():
	if questioning:
		$DialogueBox/Answers.visible = true


func _on_dialogue_box_no():
	_set_returned(false)
	_show_dialogue_box(false)
	questioning = false


func _on_dialogue_box_yes():
	_set_returned(true)
	_show_dialogue_box(false)
	questioning = false


func _set_returned(value):
	if !questioning:
		return

	artifact_returned.emit(value)
