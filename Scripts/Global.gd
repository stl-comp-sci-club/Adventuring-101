extends Node

var pauseMenuOpened = false
var mapOpened = false
var invOpened = false
var questMenuOpened = false

var scene = ""
var selected_save = ""
var available_saves = []

var paused = false
var in_dialogue = false

var camera_zoom = 1.5
var sound_effect_volume = 100
var music_volume = 100
var master_volume = 100
var full_screen = false
var auto_pickup = true

onready var body_spritesheet = {
	0 : load("res://Player/caywalksheet.png")
}

onready var shirt_spritesheet = {
	0 : load("res://Assets/CayClothes/Shirts/shirt-default.png"),
	1 : load("res://Assets/CayClothes/Shirts/shirt-blue.png"),
	2 : load("res://Assets/CayClothes/Shirts/shirt-steelblue.png"),
	3 : load("res://Assets/CayClothes/Shirts/shirt-teal.png"),
	4 : load("res://Assets/CayClothes/Shirts/shirt-lime.png"),
	5 : load("res://Assets/CayClothes/Shirts/shirt-green.png"),
	6 : load("res://Assets/CayClothes/Shirts/shirt-peach.png"),
	7 : load("res://Assets/CayClothes/Shirts/shirt-orange.png"),
	8 : load("res://Assets/CayClothes/Shirts/shirt-white.png"),
	9 : load("res://Assets/CayClothes/Shirts/shirt-pink.png"),
	10 : load("res://Assets/CayClothes/Shirts/shirt-yellow.png"),
	11 : load("res://Assets/CayClothes/Shirts/shirt-purple.png"),
	12 : load("res://Assets/CayClothes/Shirts/shirt-maroon.png"),
	13 : load("res://Assets/CayClothes/Shirts/shirt-brown.png")
}

onready var attack_shirt_spritesheet = {
	0 : load("res://Assets/CayClothes/Attacks/attack-default.png"),
	1 : load("res://Assets/CayClothes/Attacks/attack-blue.png"),
	2 : load("res://Assets/CayClothes/Attacks/attack-steelblue.png"),
	3 : load("res://Assets/CayClothes/Attacks/attack-teal.png"),
	4 : load("res://Assets/CayClothes/Attacks/attack-lime.png"),
	5 : load("res://Assets/CayClothes/Attacks/attack-green.png"),
	6 : load("res://Assets/CayClothes/Attacks/attack-peach.png"),
	7 : load("res://Assets/CayClothes/Attacks/attack-orange.png"),
	8 : load("res://Assets/CayClothes/Attacks/attack-white.png"),
	9 : load("res://Assets/CayClothes/Attacks/attack-pink.png"),
	10 : load("res://Assets/CayClothes/Attacks/attack-yellow.png"),
	11 : load("res://Assets/CayClothes/Attacks/attack-purple.png"),
	12 : load("res://Assets/CayClothes/Attacks/attack-maroon.png"),
	13 : load("res://Assets/CayClothes/Attacks/attack-brown.png")
}

var shirt_color: int = 0

onready var master_bus = AudioServer.get_bus_index("Master")
onready var music_bus = AudioServer.get_bus_index("Music")
onready var sound_effect_bus = AudioServer.get_bus_index("Sound Effects")

var data = { # Empty for now, future data can be added
	"Inventory": [],
	"Hour": 10,
	"Minute": 0
}

var HOUR = data["Hour"]
var MINUTES = data["Minute"]

var save_password = "b5^E%2fZJkX%ho&d&^"

func map(val, in_min, in_max, out_min, out_max):
	return (val - in_min) * (out_max - out_min) / (in_max - in_min) + out_min

func second_value_sort(a):
	return a[1]


func get_saves():
	var save_dir = Directory.new()
	if not save_dir.dir_exists("user://saves"):
		save_dir.make_dir("user://saves")
	save_dir.open("user://saves")
	var files = []
	save_dir.list_dir_begin()

	while true:
		var file = File.new()
		var file_name = save_dir.get_next()
		if file_name == "":
			break
		elif not file_name.begins_with("."):
			files.append([file_name, file.get_modified_time("user://saves/" + file_name)])
			
	save_dir.list_dir_end()

	files.sort_custom(self, "second_value_sort")
	

	return files


func save_game():
	var save_file = File.new()
	var status = save_file.open_encrypted_with_pass("user://saves/" + selected_save + ".dat", File.WRITE, save_password)
	if status != OK:
		print_debug("Save file failed to load")
		return "Error"

	print(data)

	save_file.store_line(str(camera_zoom))
	save_file.store_line(str(sound_effect_volume))
	save_file.store_line(str(music_volume))
	save_file.store_line(str(master_volume))
	save_file.store_line(str(full_screen))
	save_file.store_line(str(auto_pickup))
	save_file.store_line(str(shirt_color))
	save_file.store_var(data)
	save_file.close()
	return "Saved"
	
func load_game():
	var save_file = File.new()
	if not save_file.file_exists("user://saves/" + selected_save + ".dat"):
		print_debug("Save file does not exist")
		return "Error"
	var status = save_file.open_encrypted_with_pass("user://saves/" + selected_save + ".dat", File.READ, save_password)
	if status != OK:
		print_debug("Save file failed to load")
		return "Error"
	
	
	camera_zoom = float(save_file.get_line())
	sound_effect_volume = int(save_file.get_line())
	music_volume = int(save_file.get_line())
	master_volume = int(save_file.get_line())
	full_screen = true if save_file.get_line() == "True" else false
	auto_pickup = true if save_file.get_line() == "True" else false
	shirt_color = int(save_file.get_line())
	data = save_file.get_var()
	
	HOUR = data["Hour"]
	MINUTES = data["Minute"]

	save_file.close()
	set_sound()
	
	return "Loaded"
	
func set_sound():
	if master_volume == 0:
		AudioServer.set_bus_mute(master_bus, true)
	else:
		AudioServer.set_bus_mute(master_bus, false)
		AudioServer.set_bus_volume_db(master_bus, map(master_volume, 0, 100, -20, 0))
		
	if music_volume == 0:
		AudioServer.set_bus_mute(music_bus, true)
	else:
		AudioServer.set_bus_mute(music_bus, false)
		AudioServer.set_bus_volume_db(music_bus, map(music_volume, 0, 100, -20, 0))
		
	if sound_effect_volume == 0:
		AudioServer.set_bus_mute(sound_effect_bus, true)
	else:
		AudioServer.set_bus_mute(sound_effect_bus, false)
		AudioServer.set_bus_volume_db(sound_effect_bus, map(sound_effect_volume, 0, 100, -20, 0))


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
var NPC_paths = {
"Elijah": [Vector2(150, 0), 1, Vector2(-906, 713), 3, Vector2(150, 0), 3, Vector2(140, -60), "enter_house", [Vector2(495, -1828)], "stop", 30, "start", Vector2(401, -1789), [Vector2(140, -60)]], "Mom": [Vector2(272,80)], 
"Elijah2": [Vector2(-200, 0), 1, Vector2(-906, 800), 3, Vector2(-200,0), 3, Vector2(-210, -60), "enter_house", [Vector2(495, -1828)], "stop", 30, "start", Vector2(401, -1789), [Vector2(-210, -60)]], 
"Elijah3": [Vector2(-550,0), 1, Vector2(-906, 900), 3, Vector2(-550,0), 3, Vector2(-560, -60), "enter_house", [Vector2(495, -1828)], "stop", 30, "start", Vector2(401, -1789), [Vector2(-560, -60)]]
}


# true means npc is inside their house
# false means npc is not inside their house

var NPC_houses = {"Elijah": false, "Elijah2": false, "Elijah3": false}
var NPC_house_positions = {"Elijah": Vector2(400, -1801), "Blacksmith": Vector2()}

var main_quests = []
var side_quests = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

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
	available_saves = get_saves()
	# var load_status = load_game()
	# if load_status == "Error" or data == null or data.has("Hour") == false or data.has("Minute") == false:
	# 	print_debug("Corrupted save file!!")
	# 	var dir = Directory.new()
	# 	dir.remove("user://save.dat")
	# 	print_debug("Please restart game to create new save file")
	# 	get_tree().quit()
	# 	return
		# print("Attempting to reset to default save file")
		# var status = load_game()
		# if status == "Error":
		# 	print("Failed to reset save file, bailing out")
		# 	get_tree().quit()
		# else:
		# 	print("Reset save file")

	# self.HOUR = data["Hour"]
	# self.MINUTES = data["Minute"]
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
func _process(_delta):
	if self.HOUR >= 13:
		hours = self.HOUR - 12
	else:
		hours = self.HOUR
	
	
	if self.HOUR > 24: 
		self.HOUR = 1
		
	if self.MINUTES > 59:
		self.MINUTES = 0
		self.HOUR += 1
	
	if self.HOUR < 1:
		self.HOUR = 1
		
	data["Hour"] = self.HOUR
	data["Minute"] = self.MINUTES
	
	minutes = time_map(self.MINUTES)/100

	
