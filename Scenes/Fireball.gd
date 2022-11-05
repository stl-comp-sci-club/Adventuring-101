extends KinematicBody2D
export (PackedScene) var fireball

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func attack(fireball_position):
	velocity = Vector2(0,0)
	velocity = (get_global_mouse_position() - fireball_position).normalized()
	velocity *= 500

	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	move_and_collide(velocity*delta)
#	pass
