extends StaticBody2D

onready var navMesh : Navigation2D = get_node("/root/World/NavMesh")
onready var path_line : Line2D = get_node("./Line2D")
onready var player : KinematicBody2D = get_node("/root/World/Player")

# 60
export (int) var editor_speed = 40
var speed
var path : = PoolVector2Array()

var waiting = false
var stopped = false

var last_direction = Vector2(0,1)

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
		$AnimatedSprite.play("walk_"+d)
	else:
		var d = get_animation_direction(last_direction)
		$AnimatedSprite.play(d+"_resting")
	


var points = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var path_index = 0
#var last_position

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = editor_speed
	points = Global.NPC_paths[get_node(".").name] # Array of Vector2 Points
	begin_path(path_index)
#	last_position = position

var direction: Vector2

func begin_path(var path_i):
	print(path_i)
	var val = points[path_i]
	if typeof(val) == TYPE_INT:
		direction = Vector2.ZERO
		last_direction = Vector2(0,1)
		waiting = true
		yield(get_tree().create_timer(val), "timeout")
		waiting = false
	elif typeof(val) == TYPE_STRING:
		if val == "hide":
			get_node(".").modulate.a = 0
#			Global.NPC_houses[get_node(".").name] = true
			$CollisionShape2D.disabled = true
			$Area2D/CollisionShape2D.disabled = true
#			waiting = true
		elif val == "show":
			get_node(".").modulate.a = 1
#			Global.NPC_houses[get_node(".").name] = false
			$CollisionShape2D.disabled = false
			$Area2D/CollisionShape2D.disabled = false
#			waiting = false
		elif val == "enter_house":
			Global.NPC_houses[get_node(".").name] = true
		elif val == "leave_house":
			Global.NPC_houses[get_node(".").name] = false
		elif val == "stop":
			stopped = true
		elif val == "start":
			stopped = false
	elif typeof(val) == TYPE_ARRAY:
		position = val[0]
		print(path)
	else:
		path = navMesh.get_simple_path(position, val)
		path_line.points = path
		get_node(".").path = path


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.paused:
		$AnimatedSprite.play(get_animation_direction(last_direction)+"_resting")

	if !Global.paused:
		if player.position.y > position.y:
			get_node(".").z_index = 0
		else:
			get_node(".").z_index = 1
		animate(direction)
		if path.size() == 0 and not waiting:
			print("Finished point")
			path_index+=1
			if path_index == len(points):
				path_index = 0
			begin_path(path_index)
		if !stopped:
			if !waiting && path.size() > 0:
				direction = position.direction_to(path[0]).normalized()
			#	print(last_position)
			#	print(position)
			#
			#	print(position.x-last_position.x)
			#	print(position.y-last_position.y)
			#	print(direction)
				var distance_to_walk = speed * delta
				while distance_to_walk > 0 and path.size() > 0:
					var distance_to_next_point = position.distance_to(path[0])
					if distance_to_walk <= distance_to_next_point:
						position += position.direction_to(path[0]) * distance_to_walk
					else:
						position = path[0]
						path.remove(0)
					distance_to_walk -= distance_to_next_point
				# go to next point after finishing
				
			#	last_position = position

var touching_player = false

func _on_Area2D_body_entered(body):
#	print(body)
	if body == player:
		speed = 0
		touching_player = true
		print("Collision with player")
		waiting = true
		direction = Vector2.ZERO
		last_direction = position.direction_to(player.position)
		yield(get_tree().create_timer(5), "timeout")
		if touching_player and !stopped:
			speed = editor_speed
			print("Continuing...")
			waiting = false
			
			$CollisionShape2D.disabled = true
			yield(get_tree().create_timer(2), "timeout")
			
			$CollisionShape2D.disabled = false
		
func _on_Area2D_body_exited(body):
	if body == player:
		touching_player = false
		speed = editor_speed
		if !stopped:
			waiting = false

