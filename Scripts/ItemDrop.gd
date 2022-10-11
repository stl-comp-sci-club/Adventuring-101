extends KinematicBody2D

const ACCELERATION = 1000
const MAX_SPEED = 1500
var velocity = Vector2.ZERO
var item_name

var player = null
var being_picked_up = false

func _ready():
	item_name = "Health Potion"

 
func _physics_process(delta):
	if being_picked_up == false:
		velocity = velocity.move_toward(Vector2(0,MAX_SPEED), ACCELERATION * 0)
	else:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		
		var distance = global_position.distance_to(player.global_position)
		if distance < 20:
			PlayerInventory.add_item(item_name, 1)
			queue_free()
	velocity = move_and_slide(velocity, Vector2.UP)

func pick_up_item(body):
	player = body
	being_picked_up = true
