extends StaticBody2D

onready var navMesh : Navigation2D = get_node("/root/World/NavMesh")
onready var path_line : Line2D = get_node("./Line2D")


# 60
export (int) var speed = 100
var path : = PoolVector2Array()

var waiting = false

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
	points = Global.NPC_paths[get_node(".").name] # Array of Vector2 Points
	begin_path(path_index)
#	last_position = position

var direction: Vector2

func begin_path(var path_i):
	var val = points[path_i]
	if typeof(val) == TYPE_INT:
		direction = Vector2.ZERO
		last_direction = Vector2(0,1)
		waiting = true
		yield(get_tree().create_timer(val), "timeout")
		waiting = false
	else:
		path = navMesh.get_simple_path(position, val)
		path_line.points = path
		get_node(".").path = path


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	animate(direction)
	if path.size() == 0:
			print("Finished point")
			path_index+=1
			if path_index == len(points):
				path_index = 0
			begin_path(path_index)
	if !waiting:
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
