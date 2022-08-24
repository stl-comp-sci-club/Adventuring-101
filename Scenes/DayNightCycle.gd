extends CanvasModulate


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const nightColor = Color("#281E56")
const dayColor = Color("#F4F1D9")
var calc = 0
# Called when the node enters the scene tree for the first time.

func _ready():
	pass
	
	# sus (does nothing rn) 
var upperLim = 1
var lowerLim = 0

func _process(delta:float):
	# Dividing by twelve makes each half of the day 12 minutes long. 
	# Imagine a circle with circumfrence 2PI, and the TIME variable as each minute 
	# if you do sin(PI * TIME) the speed at period of the sine wave is 1 
	# If you want to see what it does just go on desmos and put sin(PI * x) and play around with it 
	
	if sin(PI/12 * Global.TIME + (-PI/2)) + 0.25 < 0:
		calc = sin((PI/12 * Global.TIME) + (-PI/2)) + 0.25
	else: 
		calc = sin((PI/12 * Global.TIME) + (-PI/2)) + 0.25
	
	if calc > self.upperLim:
		calc = self.upperLim
	if calc < self.lowerLim:
		calc = self.lowerLim
	
	print("CALC:" ,calc)
		
	self.color = nightColor.linear_interpolate(dayColor, calc)
