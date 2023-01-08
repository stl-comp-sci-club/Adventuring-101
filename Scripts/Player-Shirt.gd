extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
# pass # Replace with function body.

onready var current_shirt = Global.shirt_color
onready var current_shirt_texture = Global.shirt_spritesheet[current_shirt]
onready var current_attack_shirt_texture = Global.attack_shirt_spritesheet[current_shirt]


func _ready():
	$".".texture = current_shirt_texture
	$"../Attack Shirt".texture = current_attack_shirt_texture

var frame_indexes = {
	"walk_down":[0,1,2,3],
	"walk_right":[4,5,6,7],
	"walk_left":[8,9,10,11],
	"walk_up":[12,13,14,15],
	"down_resting":[1],
	"right_resting":[5],
	"left_resting":[9],
	"up_resting":[13],
	
	"attack_down":[0,1,2,3,4],
	"attack_right":[5,6,7,8,9],
	"attack_left":[10,11,12,13,14],
	"attack_up":[15,16,17,18,19],
}

func _process(delta):
	if Global.shirt_color != current_shirt:
		current_shirt = Global.shirt_color
		current_shirt_texture = Global.shirt_spritesheet[current_shirt]
		current_attack_shirt_texture = Global.attack_shirt_spritesheet[current_shirt]
		$".".texture = current_shirt_texture
		$"../Attack Shirt".texture = current_attack_shirt_texture


	var animation = $"../player".animation
	var frame = $"../player".frame
	

	$".".visible = true
	$"../Attack Shirt".visible = false

	if "attack" in animation:
		$".".visible = false
		$"../Attack Shirt".visible = true
		if frame == 5:
			frame = 4
		$"../Attack Shirt".frame = frame_indexes[animation][frame]
	else:
		$"../Attack Shirt".visible = false
		$".".frame = frame_indexes[animation][frame]
	
