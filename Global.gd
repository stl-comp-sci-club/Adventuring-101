extends Node

var scene = ""

var paused = false
var in_dialogue = false


# Vectors define the points the NPC should walk to
# Integers define pauses between the points (in seconds)
# Avoid using floats cause it like breaks it
var NPC_paths = {"Elijah": [1, Vector2(-906, 713), 3, Vector2(0,0), 3], "Mom": [Vector2(272,80)]}


var main_quests = []
var side_quests = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#func change_scene(new_scene, player_pos, player):
#	get_tree().change_scene(new_scene)
	#var player : KinematicBody2D = get_node("/root/World/Player")
	#var player = get_tree().get_root().get_child(0).get_node("Player")
#	print("Setting player position to " + str(player_pos))
#	player.set_position(player_pos)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
