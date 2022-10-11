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
	var nightColor = Color("#4262c9")
	
	if int(Global.MINUTES) < 10:
		bbcode_text = str(Global.hours) + ":0" + str(Global.MINUTES) 
	else:
		bbcode_text = str(Global.hours) + ":" + str(Global.MINUTES) 
	
	if int(Global.HOUR) > 12:
		bbcode_text = bbcode_text + " PM"
	else:
		bbcode_text = bbcode_text + " AM"
		
	if int(Global.HOUR) > 22 or int(Global.HOUR) < 6:
		get_node("../Day Night").play("Night")
	else:
		get_node("../Day Night").play("Day")
	
#	add_color_override("default_color", nightColor.linear_interpolate(dayColor, calc))
	
#	print(Global.TIME)
	
	var x = Global.HOUR+Global.minutes-2


	# desmos here: https://www.desmos.com/calculator/r6vrnsbskg
	calc = pow(3, -0.0333333*pow(x-11.5, 2))
	
	
#	print(interpolate_factor/12)
	
	add_color_override("default_color", nightColor.linear_interpolate(dayColor, calc))

	
	
	
