class_name BeamTank
extends Node2D

const BOOM = preload("res://scenes/top/player/boom.tscn")

var time := 3.0
var time_frame := .06
var frame := 0
var clock_frame := 0.0
var speed := 400.0
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
		
		clock_frame += delta
		if clock_frame > time_frame:
			clock_frame -= time_frame
			$Sprite2D.frame = ($Sprite2D.frame + 1) % 5

func _physics_process(delta: float) -> void:
	if active:
		global_position += velocity * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is EnemyTop:
		call_deferred("hit", body)

func hit(body : Node2D):
	body.damage( 6, lerp(dir, global_position.direction_to(body.global_position), .4).normalized() )























#######
