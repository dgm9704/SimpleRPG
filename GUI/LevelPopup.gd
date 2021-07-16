extends Popup


var player

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Root/Player")
	set_process_input(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_player_level_up():
	set_process_input(true)
	popup_centered()
	get_tree().paused = true


func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_A:
			player.health_max += 50
			player.health += 50
			player.emit_signal("player_stats_changed", player)
			hide()
			set_process_input(false)
			get_tree().paused = false
		elif event.scancode == KEY_B:
			player.mana_max += 50
			player.mana += 50
			player.emit_signal("player_stats_changed", player)
			hide()
			set_process_input(false)
			get_tree().paused = false