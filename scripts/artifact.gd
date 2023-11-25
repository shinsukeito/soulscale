class_name Artifact

var name
var power: Power
var collected
var returned

func _init(name: String, power: Power):
	self.name = name
	self.power = power
	collected = false
