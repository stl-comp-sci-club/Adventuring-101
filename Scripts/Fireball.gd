extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player : KinematicBody2D = get_node("/root/World/Player")
var velocity = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func attack(fireball_position):
	position = fireball_position
	velocity = Vector2(0,0)
	velocity = (get_global_mouse_position() - fireball_position).normalized()
	velocity *= 500
	yield(VisualServer, 'frame_pre_draw')
	$"Flame/Flame light".enabled = true
	yield(get_tree().create_timer(3), "timeout")
	$Flame.emitting = false
	yield(get_tree().create_timer(0.2), "timeout")
	queue_free()

	
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	move_and_slide(velocity)
#	pass


func _on_Fireball_Collider_body_entered(body):
	if get_node("/root/World/Enemy") != null: # enemy
		if body == get_node("/root/World/Enemy"):
			get_node("/root/World/Enemy").hit()

	if body != player && body != get_node("."):
		velocity = Vector2(0,0)
		$Flame.emitting = false
		$Explosion.emitting = true
		yield(get_tree().create_timer(0.2), "timeout")
		for child in get_node("./Flame").get_children(): # Remove lights
			child.queue_free()
#		$"Fireball Shape".disabled = true
		$"Fireball Collider/Fireball Collision".disabled = true
