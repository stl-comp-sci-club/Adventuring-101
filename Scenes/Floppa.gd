extends Sprite

onready var player : KinematicBody2D = get_node("/root/World/Player")

func _on_floppa_body_entered(body):
	if body == player:
		player.new_dialogue("Hi, im floppa!", "floppa")
		player.continue_dialogue("Welcome to Adventuring 101", "floppa",1)
		player.continue_dialogue("Your dad gon", "floppa",2)
		player.end_dialogue("This dialogue system is pretty cool isn't it?", "floppa", 3)
