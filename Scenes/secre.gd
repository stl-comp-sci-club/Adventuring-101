extends Node2D
onready var player : KinematicBody2D = get_node("Player")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Music.get_node("AudioStreamPlayer").stopMusic()
	
func _on_SecretRoomExit_body_entered(body):
	if body == player:
		get_tree().change_scene("res://Scenes/Upstairs of house.tscn")
