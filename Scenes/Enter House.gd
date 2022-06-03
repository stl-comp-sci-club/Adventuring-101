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



func _on_Enter_House_body_entered(body):
	if body == player:
		player.input_allowed = false
		Global.scene = "downstairs (from outside)"
		yield(player.fade_out(), "completed")
		get_tree().change_scene("res://Scenes/bottom of home.tscn")
		player.input_allowed = true
