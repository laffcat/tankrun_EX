extends Node


var is_paused := false
signal paused
signal unpaused

signal score_updated
var score := 0:
	set(amt):
		score = amt
		emit_signal("score_updated")
var score_high := 0


const HALF_SCR = Vector2(240, 180)

var main : Node2D
var player : CharacterBody2D
var cursor : Cursor

var bunker_level_pool_full : Array[String] = []
var bunker_level_pool : Array[String] = []
func pop_bunker_level() -> String:
	if bunker_level_pool == []: bunker_level_pool = bunker_level_pool_full.duplicate()
	return bunker_level_pool.pop_at( randi_range(0, len(bunker_level_pool) - 1) )

var tutorial_done := false
var last_health_tank := 0
var last_health_runner := 0
var starting_score_tank := 0


func game_init():
	MusicGlobal.play()
	score = 0
	last_health_tank = 0
	last_health_runner = 0
	starting_score_tank = 0

func game_end():
	tutorial_done = false
	score = 0


#var menus_active := false
var menu_current = null:
	set(new):
		if menu_current != null:
			menu_current.deactivate()
		if new != null:
			new.activate()
		menu_current = new
			
			

func _ready(): 
	load_score()

func load_score():
	if not FileAccess.file_exists("user://highscore.save"):
		return 
	var save_file = FileAccess.open("user://highscore.save", FileAccess.READ)
	var json_string = save_file.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
	var data = json.data
	score_high = data["its"]

func save_score():
	var save_file = FileAccess.open("user://highscore.save", FileAccess.WRITE)
	var d : Dictionary =  {"its" : score_high}
	var json_string = JSON.stringify(d)
	save_file.store_line(json_string)
	

func _input(event: InputEvent):
	if menu_current != null:
		menu_current.receive_input(event)
	if event.is_action_pressed("pause"):
		if !is_paused:
			is_paused = true
			paused.emit()
		else:
			is_paused = false
			unpaused.emit()
		

















#
