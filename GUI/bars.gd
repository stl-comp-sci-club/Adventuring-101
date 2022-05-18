extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Am ready")
	

func _on_Player_player_stats_changed(var player):
	print("Health and mana bar updated!")
	var barSize = 90 * player.health / player.healthMax 
	var barSize2 = 90 * player.mana / player.manaMax 
	get_node("/root/World/CanvasLayer/HealthBar/health").rect_size.x = barSize
	get_node("/root/World/CanvasLayer/ManaBar/mana").rect_size.x = barSize2
	# $Bar.rect_size.x = barSize
