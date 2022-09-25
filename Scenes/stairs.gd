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



func _on_stairs_collide(body):
	if (Global.scene == "upstairs" or Global.scene == "") and body == player:
		player.input_allowed = false
		go_to(Vector2(1648, -2781))

		get_node("/root/World/Player/player").play("down_resting")
		
		Global.scene = "downstairs"
		yield(VisualServer, 'frame_pre_draw')
		player.input_allowed = true
	elif(Global.scene == "downstairs" or Global.scene == "downstairs (from outside)") and (body == player):
		player.input_allowed = false
		go_to(Vector2(3110, -1960))

		get_node("/root/World/Player/player").play("up_resting")
		
		Global.scene = "upstairs"
		yield(VisualServer, 'frame_pre_draw')
		player.input_allowed = true
