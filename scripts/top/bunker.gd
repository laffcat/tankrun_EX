extends Node2D

var dest := "res://bitFolder/side_view_intro.tscn"

func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("bunker collided")
	#print(str(body.global_position.distance_to(global_position)))
	if body is PlayerTop and body.global_position.distance_to(global_position) < 30: 
		#print("...with in-range player")
		Globals.last_health_tank = Globals.player.hp
		Globals.tutorial_done = true
		Globals.player.cleanup()
		get_tree().change_scene_to_file(dest)
