extends Area2D


var fiona

func _ready():
	fiona = get_tree().root.get_node("Root/Fiona")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Necklace_body_entered(body):
	if body.name == "Player":
		get_tree().queue_delete(self)
		fiona.necklace_found = true
