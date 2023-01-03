extends KinematicBody2D

onready var player : KinematicBody2D = get_node("/root/World/Player")
onready var weapon = get_node("/root/World/Player/Sword/Sword Collision")

export (int) var speed = 30
var player_in_detection_area = false

var health = 100.0

var last_direction = Vector2(0,1)

var rng = RandomNumberGenerator.new()

var stunned = false
var alerted = false

var attack_timer = null
var on_attack_cooldown = false

func _ready():
	rng.randomize()

	attack_timer = Timer.new()
	add_child(attack_timer)
	attack_timer.connect("timeout", self, "attack_cool_down")
	

#func _input(event):
#	if Input.is_action_just_pressed("Interact"):
#		print(player.position)
#		print(position)

func take_damage(damage: int):
	health -= damage


func attack_cool_down():
	on_attack_cooldown = false

var velocity = Vector2.ZERO

func _process(delta):
	if player.position.y > position.y:
		get_node(".").z_index = 0
	else:
		get_node(".").z_index = 1
	if player_in_detection_area and not stunned and not Global.paused:
		if not alerted:
			var a = AudioStreamPlayer2D.new()
			add_child(a)
			a.bus = "Sound Effects"
			a.stop()
			a.stream = load("res://Sounds/Effects/alert.wav")
			a.play()
			alerted = true
		velocity = position.direction_to(player.position)
		velocity *= speed
		move_and_slide(velocity)
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if (collider.name == "Player") and not on_attack_cooldown:
				collider.stunned = true;
				collider.health -= rng.randf_range(0.0, 5.0)
				collider.can_regen_health = false
				collider.health_regen_cooldown.start(2)
				on_attack_cooldown = true
				attack_timer.start(0.3)



	elif stunned:
		velocity = position.direction_to(player.position) * -1
		velocity *= 500
		move_and_slide(velocity)
	animate(velocity)

	


#func _on_Detection_Area_body_exited(body):
#	if body == player:
#		player_in_detection_area = false

func _on_Detection_Area_body_entered(body):
	if body == player:
		player_in_detection_area = true
		
func hit():
	stunned = true
	health -= rng.randf_range(0.0, 15.0)
	
	$"./enemy/Blood Spurt".emitting = true
	
	if health <= 0:
		var a = AudioStreamPlayer2D.new()
		a.bus = "Sound Effects"
		add_child(a)
		a.stop()
		a.volume_db = 10
		a.stream = load("res://Sounds/Effects/die.wav")
		a.play()
		return
	
	var a = AudioStreamPlayer2D.new()
	add_child(a)
	a.bus = "Sound Effects"
	a.stop()
	a.stream = load("res://Sounds/Effects/ouch.wav")
	a.play()
		
	get_node("ProgressBar").value = health
	
	print(health)
	
	yield(get_tree().create_timer(0.2), "timeout")
	
	stunned = false
	print(position.direction_to(player.position) * -1)
	print(velocity)
	move_and_slide(velocity)
	$"./enemy/Blood Spurt".emitting = false

func _on_Hitbox_area_entered(area):
	if area == weapon:
		hit()


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
		$enemy.play("walk_"+d)
	else:
		var d = get_animation_direction(last_direction)
		$enemy.play(d+"_resting")
