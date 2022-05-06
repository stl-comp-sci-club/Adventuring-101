extends KinematicBody2D

export (int) var speed = 150

var velocity = Vector2.ZERO

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed
	if Input.is_action_pressed("ui_down"):
		velocity.y += speed
	if Input.is_action_pressed("ui_up"):
		velocity.y -= speed

	if velocity.length() > 0:
		velocity *= 0.8
		
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
