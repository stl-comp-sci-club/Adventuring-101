extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$"Progress Bar".visible = false
	# pass # Replace with function body.

func show_cooldown(cooldown):
	if $"Progress Bar".visible:
		return
	$"Progress Bar".value = 0
	$"Progress Bar".visible = true
	for _i in range(100):
		yield(get_tree().create_timer(cooldown/100), "timeout")
		$"Progress Bar".value += 1
	$"Progress Bar".value = 100
	yield(VisualServer, 'frame_pre_draw')
	$"Progress Bar".visible = false

func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	global_position = (mouse_pos + Vector2(5, 20))
#	pass