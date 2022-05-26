extends PopupDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var dialogue setget dialogue_set

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func dialogue_set(new_value):
	dialogue = new_value
	$DialogueBox/Label.text = new_value

func open():
	get_tree().paused = true
	popup()
	$DialogueBox/Label/AnimationPlayer.playback_speed = 60.0/dialogue.length()
	$DialogueBox/Label/AnimationPlayer.play("Typewriter")
	
func close():
	get_tree().paused = false
	hide()
	
func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_SPACE:		
			close()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
