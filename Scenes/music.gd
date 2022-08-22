extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	get_node(".").volume_db=Global.VMusic
	get_node(".").pitch_scale=Global.PMusic

func change(song):
	if get_node(".").stream==load(song):
		pass
	else:
		get_node(".").stream=load(song)
		get_node(".").play()

func playMusic():
	get_node(".").play()

func stopMusic():
	get_node(".").stop()

func pauseMusic():
	get_node(".").stream_paused=true

func resumeMusic():
	get_node(".").stream_paused=false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
