extends KinematicBody2D

onready var fade = get_node("/root/World/Player/Node2D/Fade")
onready var player : KinematicBody2D = get_node("/root/World/Player")
onready var dialogue = get_node("/root/World/Dialogue/PopupDialog")
export (int) var speed = 30

var velocity = Vector2.ZERO
var last_direction = Vector2(0,1)

var input_allowed = true
var attacking = false

func new_dialogue(text, npc_name):
	var d = get_animation_direction(last_direction)
	$player.play(d+"_resting")	
	input_allowed = false
	dialogue.dialogue_set(text)
	dialogue.name_set(npc_name)
	dialogue.open()

func continue_dialogue(text, npc_name, order):
	var counter = 1
	while true:
		if Input.is_action_just_pressed("ui_accept") and not Global.paused:
			if order == counter:
				new_dialogue(text, npc_name)
				break
			else:
				counter+=1
		yield(VisualServer, 'frame_pre_draw')
#
func end_dialogue(text, npc_name, order):
	var counter = 1
	while true:
		if Input.is_action_just_pressed("ui_accept") and not Global.paused:
			if order == counter:
				new_dialogue(text, npc_name)
				break
			else:
				counter+=1
		yield(VisualServer, 'frame_pre_draw')
	yield(VisualServer, 'frame_pre_draw')
	while true:
		if Input.is_action_just_pressed("ui_accept") and not Global.paused:
			if not Global.paused:
				input_allowed = true
			dialogue.close()
			break
		yield(VisualServer, 'frame_pre_draw')

func fade_out():
	var fade_amount=0
	for i in range(0,10):
		fade_amount+=0.1
		fade.modulate.a = fade_amount
		yield(VisualServer, 'frame_pre_draw')
	fade.modulate.a = 1
#	emit_signal("fade_in_finished")
	
func fade_in():
	var fade_amount=1
	for i in range(0,10):
		fade_amount-=0.1
		fade.modulate.a = fade_amount
		yield(VisualServer, 'frame_pre_draw')
	fade.modulate.a = 0

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
		position = Vector2(140, -20)
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
		
		get_node("./Attack Area/Weapon Swipe").look_at(get_global_mouse_position())

		if Input.is_action_just_pressed("Attack") and not attacking:
			get_node("Attack Area/Weapon Swipe").disabled = false
			attacking = true
			print("attacking")
			get_node("Attack Area/Weapon Swipe/Weapon").modulate.a = 0.5

			var t = Timer.new()
			t.set_wait_time(0.1)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			t.queue_free()

			get_node("Attack Area/Weapon Swipe/Weapon").modulate.a = 1			
			print("attack finished")
			get_node("Attack Area/Weapon Swipe").disabled = true
			attacking = false
			
			
		
	if velocity.length() > 0:
		velocity *= 0.8
		
	move_and_slide(velocity)
