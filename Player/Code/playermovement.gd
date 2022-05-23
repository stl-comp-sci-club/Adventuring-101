extends KinematicBody2D

onready var fade = get_node("/root/World/Player/Node2D/Fade")
onready var player : KinematicBody2D = get_node("/root/World/Player")

export (int) var speed = 30

var velocity = Vector2.ZERO
var last_direction = Vector2(0,1)

var last_input
var pressing = false
var input_allowed = true

signal fade_in_finished
signal fade_out_finished

signal new_dialogue
signal clear_dialogue

func fade_out():
	var fade_amount=0
	for i in range(0,10):
		fade_amount+=0.1
		fade.modulate.a = fade_amount
		yield(VisualServer, 'frame_pre_draw')
	fade.modulate.a = 1
	emit_signal("fade_in_finished")
	
func fade_in():
	var fade_amount=1
	for i in range(0,10):
		fade_amount-=0.1
		fade.modulate.a = fade_amount
		yield(VisualServer, 'frame_pre_draw')
	fade.modulate.a = 0
	emit_signal("fade_out_finished")

func _ready():
	print(Global.scene)
	input_allowed = true
	if Global.scene == "upstairs":
		position = Vector2(48, 34)
		last_direction = Vector2(0,-1)
		yield(fade_in(), "completed")
	elif Global.scene == "downstairs":
		position = Vector2(47, 53)
		last_direction = Vector2(0,1)
		yield(fade_in(), "completed")
	elif Global.scene == "downstairs (from outside)":
		position = Vector2(176, 194)
		last_direction = Vector2(0,-1)
		yield(fade_in(), "completed")
	elif Global.scene == "Level 1":
		position = Vector2(65, 32)
		last_direction = Vector2(0,1)
		yield(fade_in(), "completed")

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
		$player.play("walk_"+d)
	else:
		var d = get_animation_direction(last_direction)
		$player.play(d+"_resting")

func _process(delta):
	var direction: Vector2
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if input_allowed:
		if Input.is_action_pressed("ui_right"):
			velocity.x += speed
		if Input.is_action_pressed("ui_left"):
			velocity.x -= speed
		if Input.is_action_pressed("ui_down"):
			velocity.y += speed
		if Input.is_action_pressed("ui_up"):
			velocity.y -= speed
			
		if (Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left")) or (Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_right")) or (Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_left")) or (Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_right")):
			speed = 21
		else:
			speed = 30

		animate(direction)
		
		
	if velocity.length() > 0:
		velocity *= 0.8
		
	move_and_slide(velocity)


func _on_Area2D_body_entered(body):
	if (Global.scene == "upstairs" or Global.scene == "") and (body == player):
		input_allowed = false
		
		$player.play("walk_down")
		last_input = "down"
		for i in range(position.y,105):
			position.y = i
			yield(VisualServer, 'frame_pre_draw')
		
		yield(fade_out(), "completed")
		get_tree().change_scene("res://Scenes/bottom of home.tscn")
		
		$player.play("down_resting")
		
		Global.scene = "downstairs"
		yield(VisualServer, 'frame_pre_draw')
		input_allowed = true

	elif (Global.scene == "downstairs" or Global.scene == "downstairs (from outside)") and (body == player):
		input_allowed = false
		$player.play("walk_up")
		last_input = "up"
		for i in range(position.y, -5, -1):
			position.y = i
			yield(VisualServer, 'frame_pre_draw')
			
		yield(fade_out(), "completed")
		get_tree().change_scene("res://Scenes/Upstairs of house.tscn")
		$player.play("up_resting")
		
		Global.scene = "upstairs"
		yield(VisualServer, 'frame_pre_draw')
		
		input_allowed = true
		

func _on_Exit_Door_body_entered(body):
	if body == player:
		input_allowed = false
		Global.scene = "Level 1"
		yield(fade_out(), "completed")
		get_tree().change_scene("res://Scenes/Level 1.tscn")
		input_allowed = true
	
func _on_Enter_House_body_entered(body):
	if body == player:
		input_allowed = false
		Global.scene = "downstairs (from outside)"
		yield(fade_out(), "completed")
		get_tree().change_scene("res://Scenes/bottom of home.tscn")
		input_allowed = true
