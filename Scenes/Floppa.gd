extends Sprite

onready var player : KinematicBody2D = get_node("/root/World/Player")

var encounters = 0

func _on_floppa_body_entered(body):
	if body == player:
		if encounters == 0:
			player.new_dialogue("Hi, im floppa!", "floppa")
			player.continue_dialogue("Welcome to Adventuring 101", "floppa",1)
			player.continue_dialogue("This dialogue system is pretty cool isn't it?", "floppa", 2)
			player.continue_dialogue("Hey, why don't I show you how the quest system works", "floppa", 3)
			Global.main_quests.push_front("Find your dad :)")
			player.continue_dialogue("I've added a new main quest for you, you can check it with the quest button in the top right", "floppa", 4)
			player.end_dialogue("Talk with me when you finish it :)", "floppa", 5)
			encounters = 1
		else:
			player.new_dialogue("Oh you completed the quest?", "floppa")
			player.continue_dialogue("But the first level hasn't even been finished!?!?!", "floppa",1)
			player.end_dialogue("Oh well, I guess I'll give you a side quest", "floppa",2)
			Global.side_quests.push_front("Go pick flowers idk")
			encounters = 0
			
			
		
		
