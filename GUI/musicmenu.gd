extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	Global.VMusic=get_node("VSlider").value
	if get_node("PSlider").value >= 0:
		Global.PMusic = get_node("PSlider").value
	else:
		Global.PMusic = 1 / (get_node("PSlider").value * -1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Exit2_button_up():
	get_node(".").hide()
