extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var shpee := true
	while shpee:
		await get_tree().create_timer(10.0).timeout
		if global_position.distance_to(Globals.player.global_position) > 2000:
			shpee = false
			queue_free()
