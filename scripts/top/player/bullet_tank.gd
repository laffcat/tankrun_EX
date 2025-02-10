class_name BulletTank
extends Node2D

const BOOM = preload("res://scenes/top/player/boom.tscn")

var time := 3.0
var speed := 230.0
var velocity : Vector2

var active := true

func pause(): active = false
func unpause(): active = true

func _ready():
	Globals.paused.connect(pause)
	Globals.unpaused.connect(unpause)
	


var dir : Vector2 :
	set(new_dir):
		dir = new_dir
		$Sprite2D.rotation = new_dir.angle()
		velocity = speed * new_dir

func _process(delta: float) -> void:
	if active:
		time -= delta
		if time <= 0.0: queue_free()

func _physics_process(delta: float) -> void:
	if active:
		global_position += velocity * delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is not PlayerTop:
		call_deferred("boom")

func boom():
	var explosion := BOOM.instantiate()
	Globals.main.add_child(explosion)
	explosion.global_position = global_position
	explosion.dir = dir
	queue_free()
























#######
