extends StaticBody2D

onready var player : KinematicBody2D = get_node("/root/World/Player")
onready var dialogue = get_node("/root/World/Dialogue/PopupDialog")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player_interact_area = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if player_interact_area and Input.is_action_just_pressed("Interact"):
		player.new_dialogue("You knock on the door", "")
		player.end_dialogue("No one seems to be home...", "", 1)
		
		

func _on_Interact_Area_body_entered(body):
	if body == player:
		player_interact_area = true
		get_node("/root/World/Bed/Interact_Menu/Popup").open()


func _on_Interact_Area_body_exited(body):
	if body == player:
		player_interact_area = false
		get_node("/root/World/Bed/Interact_Menu/Popup").close()
