extends KinematicBody2D

onready var player : KinematicBody2D = get_node("/root/World/Player")

export (int) var speed = 150

var velocity = Vector2.ZERO

var last_input
var pressing = false
var input_allowed = true

# Health bar 
var health = 100 # health 
var healthMax = 100 # max health 
var healthRegen = 1 # health regeneration 

# Mana bar 
var mana = 100 # health 
var manaMax = 100 # max health 
var manaRegen = 1 # health regeneration 

signal player_stats_changed

func _ready():
	emit_signal("player_stats_changed", self)

func _process(delta):
	# print("PLAYER HEALTH: ", health)
	var newHealth = min(health + healthRegen * delta, healthMax); 
	if health != newHealth: 
		health = newHealth 
		emit_signal("player_stats_changed", self); 
	if health < 0:
		health = 0; 
	var newMana = min(mana + manaRegen * delta, manaMax); 
	if mana != newMana: 
		mana = newMana 
		emit_signal("player_stats_changed", self); 
	if mana < 0:
		mana = 0; 
	
	
	if input_allowed:
		if Input.is_action_pressed("ui_right"):
			velocity.x += speed
			$player.flip_h = true
			$player.play("walk_x")
			last_input = "right"
			emit_signal("player_stats_changed", self)
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
			
		if Input.is_action_just_released("mana_attack"): 
			mana = mana - 10 
		
	if velocity.length() > 0:
		velocity *= 0.8
		
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity *= -0.1
		#velocity = velocity.bounce(collision.normal)


# func _on_Area2D_switch_downstairs():
# 	#position = Vector2(48, 31)
# 	input_allowed = false
# 	$player.play("walk_down")
# 	for i in range(position.y,105):
# 		position.y = i
# 		yield(VisualServer, 'frame_pre_draw')
# 	$player.play("down_resting")
# 	get_tree().change_scene("res://Scenes/bottom of home.tscn")
	
# 	input_allowed = true


# func _on_Area2D_switch_upstairs():
# 	input_allowed = false
# 	$player.play("walk_up")
# 	for i in range(position.y, -5, -1):
# 		position.y = i
# 		yield(VisualServer, 'frame_pre_draw')
# 	$player.play("up_resting")
# 	get_tree().change_scene("res://Scenes/X1.tscn")
	
# 	input_allowed = true



func switch_scene(s):
	print("switching from " + GlobalVars.scene + " to: " + s) 
	GlobalVars.scene = s
	


func _on_Area2D_body_entered(body):
	if (GlobalVars.scene == "upstairs") and (body == player):
		print("going down")
		input_allowed = false
		$player.play("walk_down")
		last_input = "down"
		for i in range(position.y,105):
			position.y = i
			yield(VisualServer, 'frame_pre_draw')
		$player.play("down_resting")
		get_tree().change_scene("res://Scenes/bottom of home.tscn")
		
		switch_scene("downstairs")
		yield(VisualServer, 'frame_pre_draw')
		set_position(Vector2(49, 72))
		input_allowed = true

	elif (GlobalVars.scene == "downstairs") and (body == player):
		print("going up")
		input_allowed = false
		$player.play("walk_up")
		last_input = "up"
		for i in range(position.y, -5, -1):
			position.y = i
			yield(VisualServer, 'frame_pre_draw')
		$player.play("up_resting")
		get_tree().change_scene("res://Scenes/X1.tscn")

		switch_scene("upstairs")
		yield(VisualServer, 'frame_pre_draw')
		set_position(Vector2(48, 38))
		input_allowed = true
		
