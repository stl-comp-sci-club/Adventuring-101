extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Clock updater started")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bbcode_text = str(Global.hours) + ":" + str(Global.minutes) + ":" + str(Global.seconds)
