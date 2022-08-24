extends Popup
onready var player : KinematicBody2D = get_node("/root/World/Player")
var already_paused
var selected_menu


func _ready():
	if Global.paused:
		var d = player.get_animation_direction(player.last_direction)
		get_node("/root/World/Player/player").play(d+"_resting")
		already_paused = get_tree().paused
		get_tree().paused = true
		player.input_allowed = false
		popup()
		Global.paused = true

func _input(event):
	if not visible:
		if Input.is_action_just_pressed("ui_cancel"):
			var d = player.get_animation_direction(player.last_direction)
			get_node("/root/World/Player/player").play(d+"_resting")
			already_paused = get_tree().paused
			get_tree().paused = true
			player.input_allowed = false
			popup()
			Global.paused = true
	elif visible:
		if Input.is_action_just_pressed("ui_cancel"):
#			if not already_paused:
			get_tree().paused = false
			if not Global.in_dialogue:
				player.input_allowed = true
			hide()
			Global.paused = false


func _on_Resume_button_up():
#	if not already_paused:
	get_tree().paused = false
	if not Global.in_dialogue:
		player.input_allowed = true
	hide()
	Global.paused = false
	
func _on_Exit_button_up():
	Global.paused = false
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/Main Menu.tscn")


func _on_Pause_button_button_up():
	var d = player.get_animation_direction(player.last_direction)
	get_node("/root/World/Player/player").play(d+"_resting")
	already_paused = get_tree().paused
	get_tree().paused = true
	player.input_allowed = false
	popup()
	Global.paused = true


func _on_Settings2_button_up():
	get_node("MusicMenu").show()
