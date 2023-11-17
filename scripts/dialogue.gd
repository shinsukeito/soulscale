extends CanvasLayer

var global

@export var box_offset = Vector2(558, 476)
@export var left = true

var current_npc = ""
var giant: CharacterBody2D

var message_queue = []
  
# Called when the node enters the scene tr ee for the first time.
func _ready():
	global = get_node("/root/Global")
	giant = get_parent().get_node("Giant")
	
	if left: 
		$DialogueBox.set_position(box_offset)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("shield"):
		if $DialogueBox.visible:
			trigger()
		else:
			if current_npc != "":
				show_messages(Party.companions[current_npc].daily_messages[global.day - 1])
		

func show_messages(messages):
	message_queue = messages.duplicate()
	_show_dialogue_box(true)
	_show_next_message()
 
func _show_next_message():
	var message = message_queue.pop_front()
	if message != null:
		$DialogueBox.say(message)

func trigger():
	if $DialogueBox.speaking():
		$DialogueBox.skip()
	else:
		if message_queue.size() > 0:
			_show_next_message()
		else:
			_show_dialogue_box(false)
		
func _show_dialogue_box(show):
	if show:
		$DialogueBox.visible = true 
		giant.frozen = true
	else:
		$DialogueBox.visible = false
		giant.frozen = false

func on_npc_meet(npc_name):
	current_npc = npc_name

func on_npc_leave():
	current_npc = ""
