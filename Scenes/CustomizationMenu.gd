extends Node2D

onready var shirtSprite = $CompositeSprites/Shirt #this is for clothing
onready var bodySprite = $CompositeSprites/Body #this is for clothing

#const composite_sprites = preload("res://Assets/CayClothes/CompositeSprites.gd")#this is for clothing


func _ready():
	bodySprite.texture = Global.body_spritesheet[0] #this is for clothing
	shirtSprite.texture = Global.shirt_spritesheet[Global.shirt_color] #this is for clothing
	
	
func _on_Forward_pressed():
	Global.shirt_color = (Global.shirt_color + 1) % Global.shirt_spritesheet.size()
	shirtSprite.texture = Global.shirt_spritesheet[Global.shirt_color]


func _on_Backward_pressed():
	Global.shirt_color = (Global.shirt_color - 1)
	if Global.shirt_color < 0:
		Global.shirt_color = Global.shirt_spritesheet.size() - 1
	shirtSprite.texture = Global.shirt_spritesheet[Global.shirt_color]


func _on_Back_button_up():
	get_tree().change_scene("res://Scenes/Main Menu.tscn")
	Global.save_game()
