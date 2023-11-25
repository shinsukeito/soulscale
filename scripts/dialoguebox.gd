extends Node2D

signal finished_speaking
signal yes
signal no

var index = 0
var message = ""
var pause_letters = ".,!?-"

func say(msg):
	$Message.text = ""
	index = 0
	message = msg
	$LetterTimer.start()
	$Indicator.appear(false)
	
func skip(): 
	$Message.text = message
	index = message.length()
	$LetterTimer.stop() 
	finished_speaking.emit()

func speaking():
	return index < message.length()

func _on_letter_timer_timeout():
	if message[index] == "[":
		index += 3
		$Message.text += "[i]"
		$LetterTimer.start(0)
		return
		
	$Message.text += message[index]
	
	if index < message.length() - 1:
		if pause_letters.contains(message[index]):
			$LetterTimer.start(0.2)
		else:
			$LetterTimer.start(0.02)
	elif index == message.length() - 1:
		finished_speaking.emit()
		$Indicator.appear(true)
			
	index += 1 

func _on_yes_button_pressed():
	yes.emit()
	$Answers.visible = false

func _on_no_button_pressed():
	no.emit()
	$Answers.visible = false
