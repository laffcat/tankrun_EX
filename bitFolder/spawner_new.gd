extends Node2D

@export var enemy:PackedScene
@export var spawn_delay := 1.2

var temp = preload("res://bitFolder/bat.tscn")
var spawn_delay_mult := 1.0
var spawning := true
var active := true
var clock := 0.0

func pause(): active = false
func unpause(): active = true


func _ready():
	Globals.paused.connect(pause)
	Globals.unpaused.connect(unpause)


func _process(delta: float) -> void:
	if active:
		clock -= delta
		if clock <= 0:
			if randf() > 0.55:
				spawn()
			clock += spawn_delay * spawn_delay_mult


func spawn():
	var new_spawn:CharacterBody2D = enemy.instantiate()
	add_child(new_spawn)
	new_spawn.global_position = global_position
