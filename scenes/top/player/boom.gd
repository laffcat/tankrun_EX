extends Node2D

var dir : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween := create_tween()
	tween.tween_property($MeshInstance2D, "scale", Vector2.ZERO, .3)
	await get_tree().create_timer(.1).timeout
	$Area2D.queue_free()
	await tween.finished
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is EnemyTop: if !body.invuln:
		call_deferred("boom", body)

func boom(body : EnemyTop):
	body.damage(
		5, 
		lerp(dir, global_position.direction_to(body.global_position), .25).normalized()
	)
