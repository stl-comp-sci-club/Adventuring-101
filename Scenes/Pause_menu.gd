extends Popup
onready var player : KinematicBody2D = get_node("/root/World/Player")
var already_paused
var selected_menu



func change_menu_color():
	$Resume.color = Color.goldenrod
	$Exit.color = Color.goldenrod
	
	match selected_menu:
		0:
			$Resume.color = Color.greenyellow
		1:
			$Exit.color = Color.greenyellow

func _input(event):
	if not visible:
		if Input.is_action_just_pressed("ui_cancel"):
			print("paused")
			already_paused = get_tree().paused
			get_tree().paused = true
			selected_menu = 0
			player.input_allowed = false
			popup()
	else:
		if Input.is_action_just_pressed("ui_down"):
			selected_menu = (selected_menu + 1) % 2;
			change_menu_color()
		elif Input.is_action_just_pressed("ui_up"):
			if selected_menu > 0:
				selected_menu = selected_menu - 1
			change_menu_color()
		elif Input.is_action_just_pressed("ui_accept"):
			match selected_menu:
				0:
					if not already_paused:
						get_tree().paused = false
					player.input_allowed = true
					hide()
				1:
					get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
