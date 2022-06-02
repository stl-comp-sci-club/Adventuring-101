extends Area2D
onready var player : KinematicBody2D = get_node("/root/World/Player")
onready var dialogue = get_node("/root/World/Dialogue/PopupDialog")
var inside_interact_area = false


func _input(event):
	if inside_interact_area and Input.is_action_just_pressed("Interact") and not Global.in_dialogue:
		dialogue.dialogue_set("You throw a coin into the fountain...")
		dialogue.name_set("")
		dialogue.open()
		Global.in_dialogue = true
		player.input_allowed = false
		while true:
			if Input.is_action_just_pressed("ui_accept") and not Global.paused:
				dialogue.close()
				if not Global.paused:
					player.input_allowed = true
			yield(VisualServer, 'frame_pre_draw')
		Global.in_dialogue = false
#		player.input_allowed = true
		
		# Maybe play a sound here
		
	

func _on_Interact_Area_body_entered(body):
	if body == player:
		inside_interact_area = true
		get_node("/root/World/Fountain/Interact_Menu/Popup").open()
		


func _on_Interact_Area_body_exited(body):
	if body == player:
		inside_interact_area = false
		get_node("/root/World/Fountain/Interact_Menu/Popup").close()
