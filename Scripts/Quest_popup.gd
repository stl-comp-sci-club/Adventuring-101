extends Popup

onready var player : KinematicBody2D = get_node("/root/World/Player") #used for pausing player actions

func open():
	get_node("./ColorRect/main quests/main quest list").text = PoolStringArray(Global.main_quests).join("\n")
	get_node("./ColorRect/side quests/side quest list").text = PoolStringArray(Global.side_quests).join("\n")
	popup()
	# pause game
	get_tree().paused = true
	Global.paused = true
	player.input_allowed = false
	Global.questMenuOpened = true
	
func close():
	hide()
	Global.questMenuOpened = false
	#resume game
	get_tree().paused = false
	Global.paused = false
	player.input_allowed = true
	Global.questMenuOpened = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if visible and Input.is_action_just_pressed("Interact"):
		close()


func _on_Quest_button_button_up():
	if !Global.pauseMenuOpened and !Global.invOpened and !Global.mapOpened:
		if !visible:
			open()
		else:
			close()
