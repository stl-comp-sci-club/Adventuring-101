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
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		collision.collider.set("health", collision.collider.get("health") - 1)
		print(collision.collider.get("health"))
