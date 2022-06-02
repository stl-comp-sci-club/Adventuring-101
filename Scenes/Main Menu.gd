extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Music.get_node("AudioStreamPlayer").playMusic() # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_start_button_up():
	get_tree().change_scene("res://Scenes/Upstairs of house.tscn")


func _on_quit_button_up():
	get_tree().quit()
