extends KinematicBody2D

export (int) var speed = 35

var velocity = Vector2.ZERO
onready var player : KinematicBody2D = get_node("/root/World/Player")


func _process(delta):
	velocity = position.direction_to(player.position) * speed
	velocity *= speed
	#velocity = velocity.normalized() * speed
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		collision.get_collider().health -= 1
		print(collision.get_collider().health)
	
