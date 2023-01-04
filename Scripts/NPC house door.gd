extends StaticBody2D

onready var player : KinematicBody2D = get_node("/root/World/Player")
onready var dialogue = get_node("/root/World/Dialogue/PopupDialog")
#onready var health = get_node("/root/World/Health N Mana/Bars")
#onready var quest = get_node("/root/World/Quests/Quest_button")

export (String) var NPC_name = ""
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player_interact_area = false
#var NPC_in_house
func center_camera():
#	player.get_node("./Camera2D").position = pos
	player.get_node("./Camera2D").drag_margin_v_enabled = false
	player.get_node("./Camera2D").drag_margin_h_enabled = false
	player.get_node("./Camera2D").smoothing_speed = 50

func smooth_camera():
	player.get_node("./Camera2D").drag_margin_v_enabled = true
	player.get_node("./Camera2D").drag_margin_h_enabled = true
	player.get_node("./Camera2D").smoothing_speed = 3.5

func go_to(var pos):
	yield(player.fade_out(), "completed")
	center_camera()
	player.position = pos
	yield(get_tree().create_timer(0.2), "timeout")
	yield(player.fade_in(), "completed")
	smooth_camera()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if player_interact_area and Input.is_action_just_pressed("Interact"):
		if Global.NPC_houses[NPC_name]:
			print("enter house of "+ NPC_name)
			Global.scene = NPC_name+" house"
			go_to(Global.NPC_house_positions[NPC_name])
		else:
			player.new_dialogue("You knock on the door", "")
			player.end_dialogue("No one seems to be home...", "", 1)
		
		

func _on_Interact_Area_body_entered(body):
	if body == player:
		player_interact_area = true
		get_node("/root/World/Interact Menu/Popup").open()


func _on_Interact_Area_body_exited(body):
	if body == player:
		player_interact_area = false
		get_node("/root/World/Interact Menu/Popup").close()
