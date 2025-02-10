extends Node2D



func _ready() -> void:
	randomize()
	Globals.main = self
	Globals.menu_current = null


func _on_area_cam_radius_body_exited(body: Node2D) -> void:
	if body is EnemyTop:
		body.offscreen = true


func _on_area_cam_radius_body_entered(body: Node2D) -> void:
	if body is EnemyTop:
		body.offscreen = false
