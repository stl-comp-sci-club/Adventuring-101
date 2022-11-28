extends CanvasLayer

onready var player : KinematicBody2D = get_node("/root/World/Player") #used for pausing player actions

var holding_item = null

func _input(event):
	if event.is_action_pressed("Inventory") and !Global.pauseMenuOpened and !Global.mapOpened and !Global.questMenuOpened:
		$Inventory.visible = !$Inventory.visible
		Global.invOpened = !Global.invOpened
		$Inventory.initialize_inventory()
		
		# pause game
		get_tree().paused = !get_tree().paused
		Global.paused = !Global.paused
		player.input_allowed = !player.input_allowed
		
	if event.is_action_pressed("scroll_up"):
		PlayerInventory.active_item_scroll_down()
	elif event.is_action_pressed("scroll_down"):
		PlayerInventory.active_item_scroll_up()
