extends Node

var scene = ""

var paused = false
var in_dialogue = false

var camera_zoom = 1.5
var sound_effect_volume = 100
var music_volume = 100
var master_volume = 100
var full_screen = false

var data = { # Empty for now, future data can be added
	"Inventory": [],
	"Hour": 10,
	"Minute": 0
}

var save_password = "b5^E%2fZJkX%ho&d&^"


func save_game(): # I dont think its manditory to encrypt the settings file... so settings will remain unencrypted
	var save_file = File.new()
	var status = save_file.open_encrypted_with_pass("user://save.dat", File.WRITE, save_password)
	if status != OK:
		print_debug("Save file failed to load")
		return "Error"
	save_file.store_line(str(camera_zoom))
	save_file.store_line(str(sound_effect_volume))
	save_file.store_line(str(music_volume))
	save_file.store_line(str(master_volume))
	save_file.store_line(str(full_screen))
	save_file.store_var(data)
	save_file.close()
	return "Saved"
	
func load_game():
	var save_file = File.new()
	if not save_file.file_exists("user://save.dat"):
		print_debug("Save file does not exist, creating new file")
		save_game()
	if not save_file.file_exists("user://save.dat"):
		print_debug("Save file still does not existing, aborting")
		return "Error"
	var status = save_file.open_encrypted_with_pass("user://save.dat", File.READ, save_password)
	if status != OK:
		print_debug("Save file failed to load")
		return "Error"
	camera_zoom = float(save_file.get_line())
	sound_effect_volume = int(save_file.get_line())
	music_volume = int(save_file.get_line())
	master_volume = int(save_file.get_line())
	full_screen = true if save_file.get_line() == "True" else false
	data = save_file.get_var()
	save_file.close()
	return "Loaded"
	

# Vectors define the points the NPC should walk to
# Integers define pauses between the points (in seconds)

# "hide" hides the npc
# "show" shows the npc
# used when NPC enters or exits house, seperated by a timer

# Arrays define teleport points for the npc
# ex. [Vector2(40, 30)]
# teleports npc to 40x 30y

# "enter_house" allows player to enter the house
# "leave_house" prevents player from entering the house

# "stop" makes the NPC un-responsive (basically just a static object)
# "start" re-enables the NPC

# Avoid using floats cause it like breaks it
var NPC_paths = {"Elijah": [Vector2(0,0), 1, Vector2(-906, 713), 3, Vector2(0,0), 3, Vector2(-35, -60), "enter_house", [Vector2(495, -1828)], "stop", 30, "start", Vector2(401, -1789), [Vector2(-35, -60)]], "Mom": [Vector2(272,80)], "Elijah2": [Vector2(-200,0), 1, Vector2(-906, 800), 3, Vector2(-200,0), 3, Vector2(-210, -60), "enter_house", [Vector2(495, -1828)], "stop", 30, "start", Vector2(401, -1789), [Vector2(-210, -60)]], "Elijah3": [Vector2(-400,0), 1, Vector2(-906, 900), 3, Vector2(-400,0), 3, Vector2(-387, -60), "enter_house", [Vector2(495, -1828)], "stop", 30, "start", Vector2(401, -1789), [Vector2(-387, -60)]], "Elijah4": [Vector2(-500,0), 1, Vector2(-906, 1000), 3, Vector2(-500,0), 3, Vector2(-560, -60), "enter_house", [Vector2(495, -1828)], "stop", 30, "start", Vector2(401, -1789), [Vector2(-560, -60)]]}


# true means npc is inside their house
# false means npc is not inside their house

var NPC_houses = {"Elijah": false, "Elijah2": false, "Elijah3": false, "Elijah4": false}

var main_quests = []
var side_quests = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var HOUR = 10
var MINUTES = 0
#var game_seconds = 0

var minute_timer = null
func _increment_clock():
	if scene != "":
		self.MINUTES += 1

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_game()
		yield(VisualServer, 'frame_pre_draw')
		get_tree().quit() # default behavior

# Called when the node enters the scene tree for the first time.
func _ready():
	load_game()
	HOUR = data["Hour"]
	MINUTES = data["Minute"]
	print(Global.full_screen)
	if Global.full_screen:
		OS.window_fullscreen = true
	else:
		OS.window_fullscreen = false
	minute_timer = Timer.new()
	add_child(minute_timer)
	minute_timer.connect("timeout", self, "_increment_clock")
	minute_timer.set_wait_time(1)
	minute_timer.set_one_shot(false) # Make sure it loops
	minute_timer.start()

var minutes = 0
var hours = 0

func time_map(val):
	return float(val) * 99 / 60

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if HOUR >= 13:
		hours = HOUR - 12
	else:
		hours = HOUR
	
	
	if HOUR > 24: 
		HOUR = 1
		
	if MINUTES > 59:
		MINUTES = 0
		HOUR += 1
	
	if self.HOUR < 1:
		self.HOUR = 1
		
	data["Hour"] = HOUR
	data["Minute"] = MINUTES
	
	minutes = time_map(MINUTES)/100

	
