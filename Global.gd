extends Node

var scene = ""

var paused = false
var in_dialogue = false

var NPC_paths = {"Elijah": [Vector2(-906, 713)], "Mom": [Vector2(272,80)]}

var main_quests = []
var side_quests = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
