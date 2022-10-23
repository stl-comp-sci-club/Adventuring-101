class_name Custom_HitBox
extends Area2D

export var damage := 5

func _init() -> void:
	collision_layer = 2 # Set hitboxes to a new layer
	collision_mask = 0 # No collision masks
 
