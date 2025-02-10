extends CanvasLayer

@onready var health_bar: ProgressBar = $Container/PlayUI/HBoxContainer/HPBox/HP
@onready var rad_bar: ProgressBar = $Container/PlayUI/HBoxContainer/InfBox/Radiation

@onready var play_ui: MarginContainer = $Container/PlayUI
@onready var pause_menu: PanelContainer = $Container/PauseMenu
@onready var score_label: Label = $Container/PlayUI/MaxScore



func _on_side_character_update_ui(hp: float, rad: float) -> void:
	health_bar.value = hp
	rad_bar.value = rad

func _process(delta: float) -> void:
	un_pause()
	score_label.text = "Score: " + str(Globals.score)
	

func un_pause() -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused == false:
			get_tree().paused = true
			play_ui.visible = false
			pause_menu.visible = true
		else:
			get_tree().paused = false
			play_ui.visible = true
			pause_menu.visible = false

func _on_resume_pressed() -> void:
	get_tree().paused = false
	play_ui.visible = true
	pause_menu.visible = false

func _on_back_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_restart_pressed() -> void:
	get_tree().paused = false
	Globals.game_end()
	get_tree().change_scene_to_file("res://scenes/top/game_topdown.tscn")


func _on_side_character_died() -> void:
	get_tree().paused = true
	play_ui.visible = false
	pause_menu.visible = true
	$Container/PauseMenu/MarginContainer/VBoxContainer/Resume.visible = false
	$Container/PauseMenu/MarginContainer/VBoxContainer/Label.text = str("Died, try again...")
	$ScoreDisplayHigh.visible = true
	$ScoreDisplayHigh.setup_display()
