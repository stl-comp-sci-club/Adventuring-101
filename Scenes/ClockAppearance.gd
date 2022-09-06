extends RichTextLabel



# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Clock updater started")

var upperLim = 1
var lowerLim = -1
var calc = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dayColor = Color("#fcf803")
	var nightColor = Color("#1e52fc")
	
	if int(Global.minutes) < 10:
		bbcode_text = str(Global.hours) + ":0" + str(Global.minutes) 
	else:
		bbcode_text = str(Global.hours) + ":" + str(Global.minutes) 
	
	if int(Global.TIME) > 12:
		bbcode_text = bbcode_text + " PM"
	else:
		bbcode_text = bbcode_text + " AM"
		
#	add_color_override("default_color", nightColor.linear_interpolate(dayColor, calc))
	
#	print(Global.TIME)
	
	var x = Global.TIME


	# desmos here: https://www.desmos.com/calculator/r6vrnsbskg
	calc = 0.00916*pow(x, 2)-0.000035*pow(x, 4)+0.000000072035*pow(x, 6)-0.0000000000675*pow(x, 8)
	
	
#	print(interpolate_factor/12)
	
	add_color_override("default_color", nightColor.linear_interpolate(dayColor, calc))

	
	
	
