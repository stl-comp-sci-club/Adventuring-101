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
	
#	calc = -0.5*cos((PI*Global.TIME)/12)+0.5

#	print(Global.TIME)
	
	var x = Global.HOUR+Global.minutes-2
	

#	var x = 17

	# desmos here: https://www.desmos.com/calculator/r6vrnsbskg
	calc = pow(3, -0.0333333*pow(x-11.5, 2))
	
	
#	if sin(PI/12 * Global.TIME + (-PI/2)) + 0.25 < 0:
#		calc = 0.5*sin((PI*Global.TIME)/12)+0.5
#	else: 
#		calc = sin((PI/12 * Global.TIME) + (-PI/2)) + 0.25
#
#	if calc > self.upperLim:
#		calc = self.upperLim
#	if calc < self.lowerLim:
#		calc = self.lowerLim
	
#	print("CALC:" ,calc)

#	var interpolate_factor = 0
#
#	if (Global.TIME > 12): # night time, start deicrementing
#		interpolate_factor = 24-Global.TIME
#	else: # day time, start incrementing
#		interpolate_factor = Global.TIME
#
#	print(interpolate_factor/12)
	
#	add_color_override("default_color", nightColor.linear_interpolate(dayColor, interpolate_factor/12))

		
	self.color = nightColor.linear_interpolate(dayColor, calc)
