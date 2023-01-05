extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var progress = 0
var cooldown = false
var cooldown_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$"Progress Bar".visible = false

func show_cooldown(cooldown_seconds):
	cooldown = true
	$"Progress Bar".visible = true
	cooldown_time = cooldown_seconds


func _process(delta):
	var mouse_pos = get_global_mouse_position()
	global_position = (mouse_pos + Vector2(5, 20))
	$"Progress Bar".value = progress
	if (cooldown):
		progress += cooldown_time*(delta*100)
		if progress >= 100:
			$"Progress Bar".visible = false
			progress = 0
			cooldown = false

#	pass
