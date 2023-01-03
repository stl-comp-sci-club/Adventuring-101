extends KinematicBody2D

const ACCELERATION = 5000
const MAX_SPEED = 2000
var velocity = Vector2.ZERO
var item_name

onready var player : KinematicBody2D = get_node("/root/World/Player")
var being_picked_up = false
var item_quantity = 1

func _ready():
	item_name = "Health Potion"

 
func _physics_process(delta):
	if being_picked_up == false:
		velocity = Vector2.ZERO
	else:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		
		var distance = global_position.distance_to(player.global_position)
		if distance < 20:
			PlayerInventory.add_item(item_name, item_quantity)
			queue_free()
	velocity = move_and_slide(velocity, Vector2.UP)

func pick_up_item(body):
	player = body
	being_picked_up = true
