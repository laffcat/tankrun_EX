extends Area2D

signal exit

@onready var color_rect: ColorRect = $ColorRect/ColorRect
#var temp = preload("res://bitFolder/side_view_world.tscn")

var entered = null
@export var next_level: PackedScene 
@export var required_inv:int = 0 

func _process(delta: float) -> void:
	if entered:
		if color_rect.position.x < color_rect.size.x:
			color_rect.position += delta * Vector2(color_rect.size.x, 0.0)
	else:
		color_rect.position = Vector2.ZERO


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("check_inv"):
		if body.inventory < required_inv:
			shake_self()
		else:
			entered = body
			await get_tree().create_timer(1.0).timeout
			if entered:
				emit_signal("exit")
				if next_level:
					get_tree().change_scene_to_packed(next_level)
			

func _on_body_exited(body: Node2D) -> void:
	if entered == body:
		entered = null
	

func shake_self() -> void:
	var distance := 10.0
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	var original_position:Vector2 = position
	for i in 5:
		tween.tween_property(self, "position", Vector2(position.x + distance, position.y), 0.1)
		distance *= -0.8
	tween.tween_property(self, "position", original_position, 0.1)
	
