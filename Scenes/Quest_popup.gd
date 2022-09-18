extends Popup


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func open():
	get_node("./ColorRect/main quests/main quest list").text = PoolStringArray(Global.main_quests).join("\n")
	get_node("./ColorRect/side quests/side quest list").text = PoolStringArray(Global.side_quests).join("\n")
	popup()
	
func close():
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if visible and Input.is_action_just_pressed("Interact"):
		close()


func _on_Quest_button_button_up():
	if !visible:
		open()
	else:
		close()

