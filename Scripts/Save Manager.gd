extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var save_element = preload("res://Scenes/Save.tscn")

func parse_date(datetime):

	var month = datetime['month']
	var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
	month = months[month-1]

	print(datetime)

	if datetime['hour'] == 0:
		datetime['hour'] = 24

	if len(str(datetime['minute'])) == 1:
		datetime['minute'] = "0" + str(datetime['minute'])
	else:
		datetime['minute'] = str(datetime['minute'])

	if datetime['hour'] > 12:
		return str(datetime['year']) + " " +month + " " + str(datetime['day']) + " " + str(datetime['hour']+(OS.get_time_zone_info()['bias']/60)-12) + ":" + datetime['minute'] + " PM"
	else:
		return str(datetime['year']) + " " +month + " " + str(datetime['day']) + " " + str(datetime['hour']+(OS.get_time_zone_info()['bias']/60)+12) + ":" + datetime['minute'] + " AM"

# Called when the node enters the scene tree for the first time.
func _ready():
	print(Global.available_saves)
	var nodes = $Popup.get_node("Background/Scroll background").get_children()
	for index in range(Global.available_saves.size()):
		var save = Global.available_saves[index]
		var elem = nodes[index]
		elem.get_node("./Save/Save name").text = save[0].trim_suffix(".dat")
		elem.get_node("./Save/Date").text = parse_date(OS.get_datetime_from_unix_time(save[1]))
	# 	# instance the save element
	# 	var save_instance = save_element.instance()
	# 	# set the save name
		# save_instance.get_node("./Save name").text = save[0].trim_suffix(".dat")
	# 	# set the save date
	# 	save_instance.get_node("./Date").text = parse_date(OS.get_datetime_from_unix_time(save[1]))
	# 	save_instance.set_position(Vector2(15 + (i*166), 15))
	# 	# on click, load the save
	# 	save_instance.connect("button_up", save_instance, "load_save", [save[0].trim_suffix(".dat")])
		# $"Popup/Background/Scroll background".add_child(save_instance)	

func show():
	$Popup.show()

func load_save(save_name):
	print("Loading save: " + save_name)
	Global.selected_save = save_name
	$Popup.hide()

	var load_status = Global.load_game()
	if load_status == "Error":
		print_debug("Corrupted or missing save file!!")
		get_tree().quit()
		return


	get_tree().change_scene("res://Scenes/Level 1.tscn")
	Global.scene = "upstairs"
		# print("Attempting to reset to default save file")
		# var status = load_game()
		# if status == "Error":
		# 	print("Failed to reset save file, bailing out")
		# 	get_tree().quit()
		# else:
		# 	print("Reset save file")


func _on_Back_button_up():
	$Popup.hide()


func _Save1_button_up():
	if Global.available_saves.size() > 0:
		load_save(Global.available_saves[0][0].trim_suffix(".dat"))

	
func _Save2_button_up():
	if Global.available_saves.size() > 1:
		load_save(Global.available_saves[1][0].trim_suffix(".dat"))
		
func _Save3_button_up():
	if Global.available_saves.size() > 2:
		load_save(Global.available_saves[2][0].trim_suffix(".dat"))
