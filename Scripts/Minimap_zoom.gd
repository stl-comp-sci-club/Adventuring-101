extends Button

onready var player : KinematicBody2D = get_node("/root/World/Player")
onready var border : Sprite = get_node("/root/World/Map/Border")
onready var head : Sprite = get_node("/root/World/Map/Border/Minimap/Viewport/Player Head")


# default scale 0.225
# default position 53, 53

var zoomed = false

func map():
	if !Global.paused:
		if !zoomed:
			var d = player.get_animation_direction(player.last_direction)
			get_node("/root/World/Player/player").play(d+"_resting")
			#pause
			#get_tree().paused = true
			#player.input_allowed = false
			#Global.paused = true
			
			Global.mapOpened = true
			
			border.scale.x = 0.75
			border.scale.y = 0.75
			
			border.position.x = get_viewport().get_visible_rect().size.x / 2
			border.position.y = get_viewport().get_visible_rect().size.y / 2
			zoomed = !zoomed
			
			head.scale.x = 5
			head.scale.y = 5
			
		else:
			#unpause
			#get_tree().paused = false
			#player.input_allowed = true
			#Global.paused = false
			Global.mapOpened = false
			
			border.scale.x = 0.225
			border.scale.y = 0.225
			
			head.scale.x = 7
			head.scale.y = 7
			
			border.position.x = 53
			border.position.y = 53
			zoomed = !zoomed

func _on_Map_Button_button_up():
	map()
	
func _input(ev):
	if Input.is_action_just_pressed("Map") and !Global.pauseMenuOpened and !Global.invOpened and !Global.questMenuOpened:
		map()
