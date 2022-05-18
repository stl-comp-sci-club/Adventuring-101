extends KinematicBody2D

onready var fade = get_node("/root/World/Node2D/Fade")
onready var player : KinematicBody2D = get_node("/root/World/Player")

export (int) var speed = 200

var velocity = Vector2.ZERO
var last_direction = Vector2(0,1)

var last_input
var pressing = false
var input_allowed = true

func _ready():
	if Global.scene == "upstairs":
		position = Vector2(48, 34)
		last_direction = Vector2(0,-1)
		$player.play("up_resting")
		var fade_amount=1
		for i in range(0,10):
			fade_amount-=0.1
			fade.modulate.a = fade_amount
			yield(VisualServer, 'frame_pre_draw')
		fade.modulate.a = 0
	elif Global.scene == "downstairs":
		position = Vector2(47, 53)
		last_direction = Vector2(0,1)
		$player.play("down_resting")
		var fade_amount=1
		for i in range(0,10):
			fade_amount-=0.1
			fade.modulate.a = fade_amount
			yield(VisualServer, 'frame_pre_draw')
		fade.modulate.a = 0

func get_animation_direction(direction: Vector2):
	var norm_direction = direction.normalized()
	if norm_direction.y >= 0.707:
		return "down"
	elif norm_direction.y <= -0.707:
		return "up"
	elif norm_direction.x <= -0.707:
		return "left"
	elif norm_direction.x >= 0.707:
		return "right"
	return "down"

func animate(direction: Vector2):
	if direction != Vector2.ZERO:
		last_direction = direction
		
		var d = get_animation_direction(last_direction)
		if d == "down":
			$player.play("walk_down")
		elif d == "up":
			$player.play("walk_up")
		elif d == "left":
			$player.flip_h = false
			$player.play("walk_x")
		elif d == "right":
			$player.flip_h = true
			$player.play("walk_x")
	else:
		var d = get_animation_direction(last_direction)
		
		if d == "down":
			$player.play("down_resting")
		elif d == "up":
			$player.play("up_resting")
		elif d == "left":
			$player.flip_h = false
			$player.play("x_resting")
		elif d == "right":
			$player.flip_h = true
			$player.play("x_resting")

func _process(delta):
	var direction: Vector2
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if input_allowed:
		if Input.is_action_pressed("ui_right"):
			velocity.x += speed
#			if not $player.animation in ["walk_down", "walk_up"]:
#				$player.flip_h = true
#				$player.play("walk_x")
#			last_input = "right"
		if Input.is_action_pressed("ui_left"):
			velocity.x -= speed
#			if not $player.animation in ["walk_down", "walk_up"]:
#				$player.flip_h = false
#				$player.play("walk_x")
#			last_input = "left"
		if Input.is_action_pressed("ui_down"):
			velocity.y += speed
#			if not $player.animation == "walk_x":
#				$player.play("walk_down")
#			last_input = "down"
		if Input.is_action_pressed("ui_up"):
			velocity.y -= speed
#			if not $player.animation == "walk_x":
#				$player.play("walk_up")
#			last_input = "up"
	
		animate(direction)
#		if not Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_up"):
#			if last_input == "down":
#				$player.play("down_resting")
#			if last_input == "up":
#				$player.play("up_resting")
#			if last_input == "right":
#				$player.flip_h = true
#				$player.play("x_resting")
#			if last_input == "left":
#				$player.flip_h = false	
#				$player.play("x_resting")
			
		
		
	if velocity.length() > 0:
		velocity *= 0.8
		
	move_and_slide(velocity)
	#if collision:
#		velocity *= -0.1
		#velocity = velocity.bounce(collision.normal)



func _on_Area2D_body_entered(body):
	if (Global.scene == "upstairs" or Global.scene == "") and (body == player):
		print("going down")
		input_allowed = false
		
		$player.play("walk_down")
		last_input = "down"
		for i in range(position.y,105):
			position.y = i
			yield(VisualServer, 'frame_pre_draw')
			
		var fade_amount=0
		for i in range(0,10):
			fade_amount+=0.1
			fade.modulate.a = fade_amount
			yield(VisualServer, 'frame_pre_draw')
		fade.modulate.a = 1
		
		#Global.change_scene("res://Scenes/bottom of home.tscn", Vector2(49,72), player)
		get_tree().change_scene("res://Scenes/bottom of home.tscn")
		
		$player.play("down_resting")
		
		Global.scene = "downstairs"
		yield(VisualServer, 'frame_pre_draw')
		#global_position = Vector2(49, 72)
		#set_position(Vector2(49, 72))
		input_allowed = true

	elif (Global.scene == "downstairs") and (body == player):
		print("going up")
		input_allowed = false
		$player.play("walk_up")
		last_input = "up"
		for i in range(position.y, -5, -1):
			position.y = i
			yield(VisualServer, 'frame_pre_draw')
			
		var fade_amount=0
		for i in range(0,10):
			fade_amount+=0.1
			fade.modulate.a = fade_amount
			yield(VisualServer, 'frame_pre_draw')
		fade.modulate.a = 1
		#Global.change_scene("res://Scenes/Upstairs of house.tscn", Vector2(48,38), player)
		get_tree().change_scene("res://Scenes/Upstairs of house.tscn")
		$player.play("up_resting")
		
		Global.scene = "upstairs"
		yield(VisualServer, 'frame_pre_draw')
		
		#set_position(Vector2(48, 38))
		input_allowed = true
		
