extends Camera2D


const TILE_SIZE := Vector2i(480, 320)

const BUNKER = preload("res://scenes/top/world/bunker.tscn")

var bg_tile_current := Vector2i.ZERO
@onready var bg_tiles_root: Node2D = $"../../Grass"

# deprecated, we dont need to delete grass chunks if we're only using one chunks type
func _on_area_cam_radius_area_exited(area: Area2D): pass # area.get_parent().queue_free()


func _process(delta : float):
	var new_tile := get_current_bg_tile()
	if new_tile != bg_tile_current:
		var tile_diff := new_tile - bg_tile_current
		loop_bg(tile_diff)
		bg_tile_current = new_tile
		
		if Globals.score - Globals.starting_score_tank > 200 and $HUD/BunkerArrow.target == null:
			var bunk = BUNKER.instantiate()
			$"../../EnemyRoot".add_child(bunk)
			bunk.global_position = Globals.player.global_position \
				.normalized() \
				.rotated(deg_to_rad(randi_range(-50, 50))) \
				* 2000
			$HUD/BunkerArrow.activate(bunk)
	

func get_current_bg_tile() -> Vector2i:
	# Divide position data to get current "tile", which essentially points to edges/corners between grass.tscn chunks.
	# Used to spawn in tiles.
	var out := Vector2i(
		global_position.x / (TILE_SIZE.x) ,
		global_position.y / (TILE_SIZE.y) )
	#print(str(out))
	return out

func loop_bg(tile_diff):
	bg_tiles_root.position += Vector2(
		tile_diff.x * TILE_SIZE.x ,
		tile_diff.y * TILE_SIZE.y )
