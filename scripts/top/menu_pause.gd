extends Node2D


enum Opt {RESET, EXIT}
var current : Opt = Opt.RESET

func activate():
	visible = true
	$PauseOptions/Arrow.position = $PauseOptions/Reset.position
	current = Opt.RESET

func deactivate():
	visible = false

func receive_input(event: InputEvent):
	match current:
		Opt.RESET:
			if event.is_action_pressed("jump"):
				get_tree().reload_current_scene()
			if event.is_action_pressed("up") or event.is_action_pressed("down"):
				current = Opt.EXIT
				$PauseOptions/Arrow.position = $PauseOptions/Exit.position
		Opt.EXIT:
			if event.is_action_pressed("jump"):
				Globals.game_end()
				get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
			if event.is_action_pressed("up") or event.is_action_pressed("down"):
				current = Opt.RESET
				$PauseOptions/Arrow.position = $PauseOptions/Reset.position
	
	
		
