extends StaticBody2D

onready var navMesh : Navigation2D = get_node("/root/World/NavMesh")
onready var path_line : Line2D = get_node("./Line2D")

export (int) var speed = 60
var path : = PoolVector2Array()



# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var path_index = 0

func begin_path(var path_index):
	var points = Global.NPC_paths[get_node(".").name] # Array of Vector2 Points
	var path = navMesh.get_simple_path(get_node(".").position, points[path_index])
	path_line.points = path
	get_node(".").path = path
		
		
		

# Called when the node enters the scene tree for the first time.
func _ready():
	begin_path(path_index)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var distance_to_walk = speed * delta
	while distance_to_walk > 0 and path.size() > 0:
		var distance_to_next_point = position.distance_to(path[0])
		if distance_to_walk <= distance_to_next_point:
			position += position.direction_to(path[0]) * distance_to_walk
		else:
			position = path[0]
			path.remove(0)
		distance_to_walk -= distance_to_next_point
