extends KinematicBody2D

onready var player : KinematicBody2D = get_node("/root/World/Player")
onready var weapon = get_node("/root/World/Player/Attack Area")

export (int) var speed = 20
var player_in_detection_area = false

var health = 100.0

var rng = RandomNumberGenerator.new()

var stunned = false

func _ready():
	rng.randomize()

func _input(event):
	if Input.is_action_just_pressed("Interact"):
		print(player.position)
		print(position)



var velocity = Vector2.ZERO
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_in_detection_area and not stunned and not Global.paused:
		velocity = position.direction_to(player.position)
		velocity *= speed
		move_and_slide(velocity)
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if(collision.get_collider().name == "Player"):
				collision.get_collider().health -= 1
			
				
	elif stunned:
		velocity = position.direction_to(player.position) * -1
		velocity *= 500
		move_and_slide(velocity)
		


func _on_Detection_Area_body_entered(body):
	if body == player:
		player_in_detection_area = true


func _on_Detection_Area_body_exited(body):
	if body == player:
		player_in_detection_area = false

func _on_Hitbox_area_entered(area):
	if area == weapon:
		print("hit")
		stunned = true
		
		health -= rng.randf_range(0.0, 5.0)
		
		if health <= 0:
			print("die")
			var a = AudioStreamPlayer2D.new()
			print(a)
			add_child(a)
			a.stop()
			a.stream = load("res://die.wav")
			print(a.stream)
			a.play()
			return
		
		var a = AudioStreamPlayer2D.new()
		print(a)
		add_child(a)
		a.stop()
		a.stream = load("res://ouch.wav")
		print(a.stream)
		a.play()
			
		get_node("ProgressBar").value = health
		
		print(health)
		
		var t = Timer.new()
		t.set_wait_time(0.1)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		
		stunned = false
		print(position.direction_to(player.position) * -1)
		print(velocity)
		move_and_slide(velocity)
