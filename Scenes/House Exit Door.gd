extends Area2D
onready var player : KinematicBody2D = get_node("/root/World/Player")

func _on_Exit_Door_body_entered(body):
	if body == player:
		player.input_allowed = false
		Global.scene = "Level 1"
		yield(player.fade_out(), "completed")
#		get_tree().change_scene("res://Scenes/Test_combat_scene.tscn") # THIS LINE IS JUST FOR TESTING, MAKE SURE TO REMOVE LATER
		get_tree().change_scene("res://Scenes/Level 1.tscn")
		player.input_allowed = true
