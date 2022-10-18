	extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var master_bus = AudioServer.get_bus_index("Master")
onready var music_bus = AudioServer.get_bus_index("Music")
onready var sound_effect_bus = AudioServer.get_bus_index("Sound Effects")

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		$Popup.hide()
		Global.save_game()
#		get_tree().change_scene("res://Scenes/Main Menu.tscn")

func map(val, in_min, in_max, out_min, out_max):
	return (val - in_min) * (out_max - out_min) / (in_max - in_min) + out_min

# Called when the node enters the scene tree for the first time.
func show():
	$"Popup/ScrollContainer/Scroll background/Camera Zoom/Zoom Value".text = str(map(Global.camera_zoom, 1.5, 3, 3, 1.5)) + "x"
	$"Popup/ScrollContainer/Scroll background/Camera Zoom/Camera Zoom Slider".value = Global.camera_zoom
	
	$"Popup/ScrollContainer/Scroll background/Master/Master Volume Value".text = str(Global.master_volume) + "%"
	$"Popup/ScrollContainer/Scroll background/Master/Master Slider".value = Global.master_volume
	
	$"Popup/ScrollContainer/Scroll background/Music/Music Volume Value".text = str(Global.music_volume) + "%"
	$"Popup/ScrollContainer/Scroll background/Music/Music Slider".value = Global.music_volume

	$"Popup/ScrollContainer/Scroll background/Sound Effects/Sound Effect Value".text = str(Global.sound_effect_volume) + "x"
	$"Popup/ScrollContainer/Scroll background/Sound Effects/Sound Effect Slider".value = Global.sound_effect_volume

	$"Popup/ScrollContainer/Scroll background/Fullscreen Toggle/Fullscreen Toggle".pressed = Global.full_screen
	$"Popup/ScrollContainer/Scroll background/Fullscreen Toggle/Fullscreen Value".text = "On" if Global.full_screen else "Off"

	$Popup.popup()


func _on_Camera_Zoom_Slider_value_changed(value):
	Global.camera_zoom = value
	$"Popup/ScrollContainer/Scroll background/Camera Zoom/Zoom Value".text = str(map(value, 1.5, 3, 3, 1.5))+"x"


func _on_Sound_Effect_Slider_value_changed(value):
	Global.sound_effect_volume = value
	$"Popup/ScrollContainer/Scroll background/Sound Effects/Sound Effect Value".text = str(value)+"%"
	if value == 0:
		AudioServer.set_bus_mute(sound_effect_bus, true)
	else:
		AudioServer.set_bus_mute(sound_effect_bus, false)
		AudioServer.set_bus_volume_db(sound_effect_bus, map(value, 0, 100, -20, 0))

func _on_Music_Slider_value_changed(value):
	Global.music_volume = value
	$"Popup/ScrollContainer/Scroll background/Music/Music Volume Value".text = str(value)+"%"
	if value == 0:
		AudioServer.set_bus_mute(music_bus, true)
	else:
		AudioServer.set_bus_mute(music_bus, false)
		AudioServer.set_bus_volume_db(music_bus, map(value, 0, 100, -20, 0))
		

func _on_Master_Slider_value_changed(value):
	Global.master_volume = value
	$"Popup/ScrollContainer/Scroll background/Master/Master Volume Value".text = str(value)+"%"
	if value == 0:
		AudioServer.set_bus_mute(master_bus, true)
#		print("muted")
	else:
		AudioServer.set_bus_mute(master_bus, false)
		AudioServer.set_bus_volume_db(master_bus, map(value, 0, 100, -20, 0))
#		print(map(value, 0, 100, -30, 0))
	
func _on_Back_button_up():
	$Popup.hide()
	Global.save_game()
#	get_tree().change_scene("res://Scenes/Main Menu.tscn")


func _on_Fullscreen_Toggle_button_up():
	Global.full_screen = !Global.full_screen
	$"Popup/ScrollContainer/Scroll background/Fullscreen Toggle/Fullscreen Value".text = "On" if Global.full_screen else "Off"
	if Global.full_screen:
		OS.window_fullscreen = true
	else:
		OS.window_fullscreen = false
	
