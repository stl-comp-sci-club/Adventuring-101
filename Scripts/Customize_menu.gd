extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("DefaultPplayerBase/shitr").add_item("red")
	get_node("DefaultPplayerBase/shitr").add_item("green")
	get_node("DefaultPplayerBase/shitr").add_item("blue")
	get_node("DefaultPplayerBase/shitr").set_item_icon(0, load("res://Clothes/shitr/red.png"))
	get_node("DefaultPplayerBase/shitr").set_item_icon(1, load("res://Clothes/shitr/green.png"))
	get_node("DefaultPplayerBase/shitr").set_item_icon(2, load("res://Clothes/shitr/blue.png"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_start_button_up():
	get_tree().change_scene("res://Scenes/Main Menu.tscn")
