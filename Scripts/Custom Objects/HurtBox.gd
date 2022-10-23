class_name Custom_HurtBox
extends Area2D

func _init() -> void:
	collision_layer = 0 
	collision_mask = 2 # Detect hitbox

func _ready() -> void:
	connect("area_entered", self, "_on_area_entered")

func _on_area_entered(hitbox: Custom_HitBox) -> void:
	if hitbox == null:
		return
	
	if owner.has_method("take_damage"): # call take_damage function of enemy
		owner.take_damage(hitbox.damage)

