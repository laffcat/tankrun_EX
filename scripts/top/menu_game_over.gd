extends Node2D

func activate():
	visible = true
	$ScoreDisplayHigh.setup_display()

func deactivate():
	visible = false
	
func receive_input(event: InputEvent):
	if event.is_action_pressed("jump"):
		Globals.game_end()
		get_tree().reload_current_scene()
