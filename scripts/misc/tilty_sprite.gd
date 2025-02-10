@tool
extends Sprite2D

@export var tilt_mult := 1.0
@export var time_mult := 1.0
var clock := 0.0

func _process(delta):
	clock += delta
	rotation = sin(clock * time_mult) * tilt_mult
