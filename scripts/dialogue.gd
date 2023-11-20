extends CanvasLayer

var global: Global

@export var left = true
@export var left_offset = Vector2(20, 476)
@export var right_offset = Vector2(558, 476)

var current_npc = ""
var giant: CharacterBody2D

var message_queue = []
  
# Called when the node enters the scene tr ee for the first time.
func _ready():
	global = get_node("/root/Global")
	giant = get_parent().get_node("Giant")
	
	if left: 
		$DialogueBox.set_position(left_offset)
	else:
		$DialogueBox.set_position(right_offset)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("shield"):
		if $DialogueBox.visible:
			trigger()
		else:
			if current_npc != "":
				talk_to_npc()

func talk_to_npc():
	var artifact: Artifact
	for a in global.artifact_list:
		if a.companion == current_npc:
			artifact = a
			break
			
	if artifact.collected:
		if artifact.returned == null:
			show_messages(Companions.dialogue[current_npc].found_messages[0])
		elif artifact.returned:
			show_messages(Companions.dialogue[current_npc].after_messages[0])
		else:
			show_messages(Companions.dialogue[current_npc].after_messages[1])
	else:
		show_messages(Companions.dialogue[current_npc].daily_messages[global.day - 1])
	

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
		$Companion.visible = true
		giant.frozen = true
	else:
		$DialogueBox.visible = false
		$Companion.visible = false
		giant.frozen = false

func on_npc_meet(npc_name):
	current_npc = npc_name

func on_npc_leave():
	current_npc = ""
