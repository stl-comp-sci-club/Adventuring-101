extends CanvasModulate


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const nightColor = Color("#281E56")
const dayColor = Color("#F4F1D9")
const timeConst = 0.1
var time = 0

# Called when the node enters the scene tree for the first time.

func _ready():
	pass

func _process(delta:float):
	self.time += delta * timeConst
	self.color = nightColor.linear_interpolate(dayColor, abs(sin(time)))
