extends KinematicBody2D

onready var fade = get_node("/root/World/Player/Node2D/Fade")
onready var player : KinematicBody2D = get_node("/root/World/Player")
onready var enemy : KinematicBody2D = get_node("/root/World/Enemy")
onready var dialogue = get_node("/root/World/Dialogue/PopupDialog")
export (PackedScene) var fireball
var can_use_fireball = true
var fireball_cooldown = null
export (int) var speed = 30
export (int) var regen_rate = 2
export (int) var health_regen_amount = 5
export (int) var mana_regen_amount = 3
var health = 100
var can_regen_health = true
var mana = 100
var can_regen_mana = true
var mana_regen_cooldown = null
var velocity = Vector2.ZERO
var last_direction = Vector2(0,1)

var input_allowed = true
var attacking = false
var stunned = false

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

func allow_mana_regen():
	can_regen_mana = true

func health_mana_regen():
	if health != 100:
		for i in range(health_regen_amount):
			health += 1
			yield(VisualServer, 'frame_pre_draw')
#			yield(get_tree().create_timer(0.01), "timeout")
			get_node("../Health N Mana/Bars/Health").value = health
	if mana != 100 and can_regen_mana:
		for i in range(mana_regen_amount):
			mana += 1
			yield(VisualServer, 'frame_pre_draw')
#			yield(get_tree().create_timer(0.01), "timeout")
			get_node("../Health N Mana/Bars/Mana").value = mana

func allow_fireball():
	can_use_fireball = true

func _ready():
	
	var regen_timer = Timer.new()
	add_child(regen_timer)
	regen_timer.connect("timeout", self, "health_mana_regen")
	regen_timer.set_wait_time(regen_rate)
	regen_timer.set_one_shot(false) # Make sure it loops
	regen_timer.start()
	
	mana_regen_cooldown = Timer.new()
	add_child(mana_regen_cooldown)
	mana_regen_cooldown.connect("timeout", self, "allow_mana_regen")
	
	input_allowed = true

	fireball_cooldown = Timer.new()
	add_child(fireball_cooldown)
	fireball_cooldown.connect("timeout", self, "allow_fireball")


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
	if !attacking:
		if direction != Vector2.ZERO:
			last_direction = direction
			var d = get_animation_direction(last_direction)
			$player.play("walk_"+d)
		else:
			var d = get_animation_direction(last_direction)
			$player.play(d+"_resting")


func _process(delta):
	$Camera2D.zoom.x = Global.camera_zoom
	$Camera2D.zoom.y = Global.camera_zoom
	if stunned:
		var a = AudioStreamPlayer2D.new()
		a.bus = "Sound Effects"
		add_child(a)
		a.stop()
		a.volume_db = 23
		a.stream = load("res://Sounds/Effects/playerhurt.wav")
		a.play()
		velocity = position.direction_to(enemy.position) * -1
		velocity *= 500
		move_and_slide(velocity)
		stunned = false
		yield(get_tree().create_timer(0.1), "timeout")
	if health < 0:
		get_tree().change_scene("res://Scenes/Main Menu.tscn")
	var direction: Vector2
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	get_node("../Health N Mana/Bars/Health").value=health
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
		

#		get_node("./Attack Area/Weapon Swipe").look_at(get_global_mouse_position())
		if Input.is_action_just_pressed("Special Attack") and not attacking:
			# Get the currently selected special weapon
			# Ex. Fireball, bow
			# Basically anything that isn't the sword and shoots "something"
			if mana > 0 and can_use_fireball:
				for i in range(5):
					mana -= 1
					get_node("../Health N Mana/Bars/Mana").value = mana
					yield(VisualServer, 'frame_pre_draw')
				var new_fireball = fireball.instance()
				get_tree().get_root().add_child(new_fireball)
				new_fireball.attack(position)
				can_regen_mana = false
				can_use_fireball = false
				mana_regen_cooldown.set_wait_time(5)
				mana_regen_cooldown.start()
				fireball_cooldown.set_wait_time(1)
				fireball_cooldown.start()
				


		if Input.is_action_just_pressed("Attack") and not attacking:
#			print_debug("Ryan fix combat")
#
			get_node("Sword/Sword Collision/Sword Shape").disabled = false
			attacking = true
#			print("attacking")
			#var _temp = get_global_mouse_position()-position
			var d = get_animation_direction(last_direction)

			get_node("Sword Swipe").current_animation = "Attack " + d	

			$player.play("attack_"+d)
#
			var a = AudioStreamPlayer2D.new()
			a.bus = "Sound Effects"
			add_child(a)
			a.stop()
			a.stream = load("res://Sounds/Effects/swish-"+str(randi() % 3+1)+".wav")
			a.play()
			yield(a, "finished")

			yield($player, "animation_finished")
			get_node("Sword/Sword Collision/Sword Shape").disabled = true
			attacking = false
			
		
	if velocity.length() > 0:
		velocity *= 0.8
		
	move_and_slide(velocity)


func _input(event):
	if event.is_action_pressed("PickUp"):
		if $PickUpZone.items_in_range.size() > 0:
			var pickup_item = $PickUpZone.items_in_range.values()[0]
			pickup_item.pick_up_item(self)
			$PickUpZone.items_in_range.erase(pickup_item)
