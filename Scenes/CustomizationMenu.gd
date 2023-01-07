extends Node2D

onready var shirtSprite = $CayClothes/Shirts #this is for clothing
onready var bodySprite = $Player/caywalksheet #this is for clothing

onready var composite_sprites = load("res://Assets/CayClothes/CompositeSprites.gd")#this is for clothing


func _ready():
	bodySprite.texture = composite_sprites.body_spritesheet[0] #this is for clothing
	shirtSprite.texture = composite_sprites.shirt_spritesheet[0] #this is for clothing
	
