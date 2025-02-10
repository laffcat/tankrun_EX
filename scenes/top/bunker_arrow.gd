extends Sprite2D

var active := false
var target = null

func _process(delta: float) -> void:
	if target != null:
		var dist := Globals.player.global_position.distance_to(target.global_position)
		if dist > 3000: deactivate()
		var dir := Globals.player.global_position.direction_to(target.global_position)
		var ratio := dist / 3000
		position = dir * min(190 * (.4 + .6 * ratio), dist - 30)
		rotation = dir.angle()
		material.set_shader_parameter("threshold", -.5 - ratio)
		
func activate(tgt: Node2D):
	active = true
	visible = true
	target = tgt
	var tw := create_tween()
	$"../../SpawnerPivot/SpawnerPoint".spawn_delay_mult = .8
	while active:
		tw.tween_property(self, "material:shader_parameter/static_mult", .9, .9)
		await tw.finished
		tw.stop()
		tw.tween_property(self, "material:shader_parameter/static_mult", .5, .7)
		await tw.finished
	tw.kill()

func deactivate():
	active = false
	visible = false
	target.queue_free()
	target = null
	Globals.starting_score_tank = Globals.score - 50
	material.set_shader_parameter("threshold", -2)
	material.set_shader_parameter("static_mult", .5)
	$"../../SpawnerPivot/SpawnerPoint".spawn_delay_mult = 1.0
