extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func change(song):
	get_node(".").stream=load(song)
	get_node(".").play()

func playMusic():
	get_node(".").play()

func pause():
	get_node(".").stream_paused=true

func resume():
	get_node(".").stream_paused=false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
