extends Node2D



@export var current_button : Butone :
	set(but): if but:
		current_button = but
		$Cursor.position = but.position
var active := false

func activate():
	active = true


func _ready() -> void:
	Globals.menu_current = self


func receive_input(event: InputEvent):
	if !active: return
	
	if event.is_action_pressed("up"): if current_button.up: current_button = current_button.up
	if event.is_action_pressed("down"): if current_button.down: current_button = current_button.down
	if event.is_action_pressed("left"): if current_button.left: current_button = current_button.left
	if event.is_action_pressed("right"): if current_button.right: current_button = current_button.right
	
	if event.is_action_pressed("jump"): get_tree().change_scene_to_file("res://scenes/top/game_topdown.tscn")
	
