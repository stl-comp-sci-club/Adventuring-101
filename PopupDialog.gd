extends PopupDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var health = get_node("/root/World/Health N Mana/helf")
var dialogue setget dialogue_set
var npc_name setget name_set


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func dialogue_set(new_value):
	dialogue = new_value
	$DialogueBox/Label.text = new_value

func name_set(new_value):
	npc_name = new_value
	$Name.text = new_value

func open():
#	get_tree().paused = true
	popup()
	health.modulate.a = 0
	Global.in_dialogue = true
	$DialogueBox/Label/AnimationPlayer.playback_speed = 60.0/dialogue.length()
	$DialogueBox/Label/AnimationPlayer.play("Typewriter")
	
func close():
#	get_tree().paused = false
	Global.in_dialogue = false
	health.modulate.a = 1
	hide()
	
#func _input(event):
#	if event is InputEventKey:
#		if event.pressed and event.scancode == KEY_SPACE:
#			close()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
