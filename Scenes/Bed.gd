extends Area2D
onready var player : KinematicBody2D = get_node("/root/World/Player")
onready var dialogue = get_node("/root/World/Dialogue/PopupDialog")
onready var health = get_node("/root/World/Health N Mana/Bars")
onready var quest = get_node("/root/World/Quests/Quest_button")


var inside_interact_area = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _input(event):
	if inside_interact_area and Input.is_action_just_pressed("Interact") and not Global.in_dialogue:
		player.fade_out()
		health.modulate.a = 0
		quest.modulate.a = 0
		dialogue.dialogue_set("You take a nice long nap...")
		dialogue.name_set("")
		dialogue.open()
		Global.in_dialogue = true
		player.input_allowed = false
		while true:
			if Input.is_action_just_pressed("ui_accept") and not Global.paused:
				dialogue.close()
				if not Global.paused:
					player.input_allowed = true
					player.fade_in()
					health.modulate.a = 1
					quest.modulate.a = 1
					Global.in_dialogue = false
			yield(VisualServer, 'frame_pre_draw')
		
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Bed_body_entered(body):
	if body == player:
		inside_interact_area = true
		get_node("/root/World/Bed/Interact_Menu/Popup").open()


func _on_Bed_body_exited(body):
	if body == player:
		inside_interact_area = false
		get_node("/root/World/Bed/Interact_Menu/Popup").close()

