extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Music.get_node("AudioStreamPlayer").change("res://bgm.ogg") # Replace with function body.
	Music.get_node("AudioStreamPlayer").play() # Replace with function body.

func _on_start_button_up():
	get_tree().change_scene("res://Scenes/Upstairs of house.tscn")
#	get_tree().change_scene("res://Scenes/Test_combat_scene.tscn") # THIS LINE IS JUST FOR TESTING, MAKE SURE TO REMOVE LATER


func _on_quit_button_up():
	get_tree().quit()

func _on_customize_button_up():
	get_tree().change_scene("res://Scenes/Customize_menu.tscn")


func _on_Settings_button_up():
#	get_tree().change_scene("res://Scenes/Settings.tscn")
	$Settings.show()
