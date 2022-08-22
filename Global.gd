extends Node

var scene = ""

var paused = false
var in_dialogue = false

# Vectors define the points the NPC should walk to
# Integers define pauses between the points (in seconds)

# "hide" hides the npc
# "show" shows the npc
# used when NPC enters or exits house, seperated by a timer

# Arrays define teleport points for the npc
# ex. [Vector2(40, 30)]
# teleports npc to 40x 30y

# "enter_house" allows player to enter the house
# "leave_house" prevents player from entering the house

# "stop" makes the NPC un-responsive (basically just a static object)
# "start" re-enables the NPC

# Avoid using floats cause it like breaks it
var NPC_paths = {"Elijah": [Vector2(0,0), 1, Vector2(-906, 713), 3, Vector2(0,0), 3, Vector2(-35, -60), "enter_house", [Vector2(495, -1828)], "stop", 30, "start", Vector2(401, -1789), [Vector2(-35, -60)]], "Mom": [Vector2(272,80)]}

var VMusic = 0;
var VSFX = 0;

var PMusic = 0.0;
var PSFX = 0.0;

# true means npc is inside their house
# false means npc is not inside their house
var NPC_houses = {"Elijah": false}

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
