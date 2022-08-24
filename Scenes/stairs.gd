extends Area2D
onready var player : KinematicBody2D = get_node("/root/World/Player")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_stairs_collide(body):
	if (Global.scene == "upstairs" or Global.scene == "") and body == player:
		player.input_allowed = false
		get_node("/root/World/Player/player").play("walk_down")
		for i in range(player.position.y,40):
			player.position.y = i
			yield(VisualServer, 'frame_pre_draw')
		
		yield(player.fade_out(), "completed")
		get_tree().change_scene("res://Scenes/bottom of home.tscn")
		
		get_node("/root/World/Player/player").play("down_resting")
		
		Global.scene = "downstairs"
		yield(VisualServer, 'frame_pre_draw')
		player.input_allowed = true
	elif (Global.scene == "downstairs" or Global.scene == "downstairs (from outside)") and (body == player):
		player.input_allowed = false
		get_node("/root/World/Player/player").play("walk_up")
		for i in range(player.position.y, 15, -1):
			player.position.y = i
			yield(VisualServer, 'frame_pre_draw')

		yield(player.fade_out(), "completed")
		get_tree().change_scene("res://Scenes/Upstairs of house.tscn")
		get_node("/root/World/Player/player").play("up_resting")

		Global.scene = "upstairs"
		yield(VisualServer, 'frame_pre_draw')

		player.input_allowed = true
