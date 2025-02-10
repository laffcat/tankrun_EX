extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.score_updated.connect(draw_score)
	



func draw_score():
	var score_string = str(Globals.score)
	var length := len(score_string)
	var i := 0
	for c in score_string:
		#print( c + ", altas tile " + str(Vector2i(int(c), 0)) + " at " + str(Vector2i(-length + i, -1)) )
		set_cell(Vector2i(-length + i, -1), 0, Vector2i(int(c), 0))
		i += 1
