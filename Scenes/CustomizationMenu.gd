extends Node2D

onready var shirtSprite = $CompositeSprites/Shirt #this is for clothing
onready var bodySprite = $CompositeSprites/Body #this is for clothing

#const composite_sprites = preload("res://Assets/CayClothes/CompositeSprites.gd")#this is for clothing

onready var body_spritesheet = {
	0 : load("res://Player/caywalksheet.png")
}

onready var shirt_spritesheet = {
	#0 : preload("res://Player/caywalksheet.png"),
	0 : load("res://Assets/CayClothes/Shirts/shirt-maroon.png"),
	1 : load("res://Assets/CayClothes/Shirts/shirt-blue.png"),
	2 : load("res://Assets/CayClothes/Shirts/shirt-steelblue.png"),
	3 : load("res://Assets/CayClothes/Shirts/shirt-teal.png"),
	4 : load("res://Assets/CayClothes/Shirts/shirt-lime.png"),
	5 : load("res://Assets/CayClothes/Shirts/shirt-lightgreen.png"),
	6 : load("res://Assets/CayClothes/Shirts/shirt-green.png"),
	7 : load("res://Assets/CayClothes/Shirts/shirt-peach.png"),
	8 : load("res://Assets/CayClothes/Shirts/shirt-orange.png"),
	9 : load("res://Assets/CayClothes/Shirts/shirt-darkorange.png"),
	10 : load("res://Assets/CayClothes/Shirts/shirt-yellow.png"),
	11 : load("res://Assets/CayClothes/Shirts/shirt-pink.png"),
	12 : load("res://Assets/CayClothes/Shirts/shirt-purple.png"),
	13 : load("res://Assets/CayClothes/Shirts/shirt-maroon.png"),
	14 : load("res://Assets/CayClothes/Shirts/shirt-brown.png"),
	15 : load("res://Assets/CayClothes/Shirts/shirt-white.png")
	
}

func _ready():
	bodySprite.texture = body_spritesheet[0] #this is for clothing
	shirtSprite.texture = shirt_spritesheet[5] #this is for clothing
	
