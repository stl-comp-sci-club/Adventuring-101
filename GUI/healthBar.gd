extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Player_player_stats_changed(var player):
	var barSize = 72 * player.health / player.healthMax 
	$Bar.rect_size.x = barSize
