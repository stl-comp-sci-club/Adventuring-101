extends KinematicBody2D

export (int) var speed = 35

var velocity = Vector2()
onready var player : KinematicBody2D = get_node("/root/World/Player")


func move():
	velocity = Vector2()
	velocity = position.direction_to(player.position)
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	move()
	velocity = move_and_slide(velocity)
	
