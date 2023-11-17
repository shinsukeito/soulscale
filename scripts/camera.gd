extends Camera2D

var y_offset = -320
var clamp_area: Area
var giant: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	giant = get_parent().get_node("Giant")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var new_camera_position = Vector2(
		giant.position.x,
		giant.position.y + y_offset
	).clamp(
		Vector2(clamp_area.x_min, clamp_area.y_min),
		Vector2(clamp_area.x_max, clamp_area.y_max),
	)
	position = new_camera_position
