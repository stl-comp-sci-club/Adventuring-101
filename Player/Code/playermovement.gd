extends KinematicBody2D


export (int) var speed = 150

var velocity = Vector2.ZERO

var last_input

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
		$player.flip_h = true
		$player.play("walk_x")
		last_input = "right"
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed
		$player.flip_h = false		
		$player.play("walk_x")
		last_input = "left"
	if Input.is_action_pressed("ui_down"):
		velocity.y += speed
		$player.play("walk_down")
		last_input = "down"
	if Input.is_action_pressed("ui_up"):
		velocity.y -= speed
		$player.play("walk_up")
		last_input = "up"
	
	if not Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_up"):
		if last_input == "down":
			$player.play("down_resting")
		if last_input == "up":
			$player.play("up_resting")
		if last_input == "right":
			$player.flip_h = true
			$player.play("x_resting")
		if last_input == "left":
			$player.flip_h = false	
			$player.play("x_resting")
			
		
		
	if velocity.length() > 0:
		velocity *= 0.8
		
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity *= -0.1
		#velocity = velocity.bounce(collision.normal)
