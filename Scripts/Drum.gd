extends Sprite
onready var player : KinematicBody2D = get_node("/root/World/Player")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var touching = false

# Called when the node enters the scene tree for the first time.
func _input(event):
	if Input.is_action_just_pressed("Interact") and touching:
		var a = AudioStreamPlayer2D.new()
		a.bus = "Sound Effects"
		add_child(a)
		a.stop()
		a.stream = load("res://Sounds/Effects/vine-boom.wav")
		a.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_drum_body_entered(body):
	if body == player:
		touching = true
		get_node("Interact Menu/Popup").open()

func _on_drum_body_exited(body):
	if body == player:
		touching = false
		get_node("Interact Menu/Popup").close()

