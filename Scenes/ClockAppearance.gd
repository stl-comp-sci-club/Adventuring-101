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
	
	if sin(PI/12 * Global.TIME + (-PI/2)) + 0.25 < 0:
		calc = sin((PI/12 * Global.TIME) + (-PI/2)) + 0.25
	else: 
		calc = sin((PI/12 * Global.TIME) + (-PI/2)) + 0.25
	
	if calc > self.upperLim:
		calc = self.upperLim
	if calc < self.lowerLim:
		calc = self.lowerLim
	
	if int(Global.minutes) < 10:
		bbcode_text = str(Global.hours) + ":0" + str(Global.minutes) 
	else:
		bbcode_text = str(Global.hours) + ":" + str(Global.minutes) 
	
	if int(Global.TIME) > 13:
		bbcode_text = bbcode_text + " PM"
	else:
		bbcode_text = bbcode_text + " AM"
		
	add_color_override("default_color", nightColor.linear_interpolate(dayColor, calc))
	
	
	
