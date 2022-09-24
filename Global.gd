extends Node

var scene = ""

var paused = false
var in_dialogue = false

var camera_zoom = 1.5
var sound_effect_volume = 100
var music_volume = 100
var master_volume = 100

var data = { # Empty for now, future data can be added
	"Inventory": []
}

var save_password = "b5^E%2fZJkX%ho&d&^"

func save_settings(): # I dont think its manditory to encrypt the settings file... so settings will remain unencrypted
	var save_file = File.new()
	var status = save_file.open_encrypted_with_pass("user://settings.dat", File.WRITE, save_password)
	if status != OK:
		print_debug("Save file failed to load")
		return "Error"
	save_file.store_line(str(camera_zoom))
	save_file.store_line(str(sound_effect_volume))
	save_file.store_line(str(music_volume))
	save_file.store_line(str(master_volume))
	save_file.store_var(data)
	save_file.close()
	return "Saved"
	
func load_settings():
	var save_file = File.new()
	if not save_file.file_exists("user://settings.dat"):
		print_debug("Save file does not exist, creating new file")
		save_settings()
	if not save_file.file_exists("user://settings.dat"):
		print_debug("Save file still does not existing, aborting")
		return "Error"
	var status = save_file.open_encrypted_with_pass("user://settings.dat", File.READ, save_password)
	if status != OK:
		print_debug("Save file failed to load")
		return "Error"
	camera_zoom = float(save_file.get_line())
	sound_effect_volume = int(save_file.get_line())
	music_volume = int(save_file.get_line())
	master_volume = int(save_file.get_line())
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
#var game_timer = null
func _increment_clock():
	self.MINUTES += 1

#func _increment_internal_time():
#	self.game_seconds += 0.1


# Called when the node enters the scene tree for the first time.
func _ready():
	load_settings()
	minute_timer = Timer.new()
	add_child(minute_timer)
	minute_timer.connect("timeout", self, "_increment_clock")
	minute_timer.set_wait_time(1)
	minute_timer.set_one_shot(false) # Make sure it loops
	minute_timer.start()

#	if !paused:

#func change_scene(new_scene, player_pos, player):
#	get_tree().change_scene(new_scene)
	#var player : KinematicBody2D = get_node("/root/World/Player")
	#var player = get_tree().get_root().get_child(0).get_node("Player")
#	print("Setting player position to " + str(player_pos))
#	player.set_position(player_pos)

var minutes = 0
var hours = 0

func time_map(val):
	return float(val) * 99 / 60

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
#	if paused:
#		minute_timer.stop()
	
#	if !paused:
#		minute_timer.start()
#		self.TIME += delta * timeConst
#		self.TIME += 0.01
	
	
#	print("ACC TIME: ", str(self.HOUR) + " " + str(self.MINUTES))
#	print(str(hours) + " " +str(minutes))
#	print(Global.HOUR+minutes)

#	if "." in (str(self.TIME).substr(0, 2)):
#		self.hours = str(self.TIME).substr(0, 1)
#		self.minutes = str(self.TIME).substr(2, 2)
#		self.seconds = str(self.TIME).substr(4, 2)
#	else: 
#		self.hours = str(self.TIME).substr(0, 2)
#		self.minutes = str(self.TIME).substr(3,2)
#		self.seconds = str(self.TIME).substr(5,2) 


#	self.minutes = int(self.minutes) * 60 / 100
#	self.seconds = int(self.seconds) * 60 / 100
	
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
	
	minutes = time_map(MINUTES)/100
	# These can be used for npc stuff
	
	
#	if self.TIME > 13:
#		print(int(self.hours)-12, ":", self.minutes, ":", self.seconds, " PM")
#	else: 
#		print(self.hours, ":", self.minutes, ":", self.seconds, " AM")
		
	
	
	
