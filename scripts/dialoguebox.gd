extends Node2D

var index = 0
var message = ""
var displayMessage = ""

var waitLetters = ".,!?-"

func say(msg):
	$Message.text = ""
	index = 0
	message = msg
	$LetterTimer.start()
	
func skip(): 
	$Message.text = message
	index = message.length()
	$LetterTimer.stop() 

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
		if waitLetters.contains(message[index]):
			$LetterTimer.start(0.2)
		else:
			$LetterTimer.start(0.02)
	
	index += 1  
