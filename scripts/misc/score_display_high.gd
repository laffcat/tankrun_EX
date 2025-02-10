extends TileMapLayer

@export var color_lame : Color
@export var color_cool : Color

func setup_display():
	if Globals.score > Globals.score_high:
		Globals.score_high = Globals.score
		draw_int(Globals.score)
		$New.visible = true
		$Exclamationpoint.visible = true
		modulate = color_cool
		Globals.save_score()
	else:
		modulate = color_lame
		draw_int(Globals.score_high)
		
		

func draw_int(input : int):
	var score_string = str(input)
	var length := len(score_string)
	var i := 0
	for c in score_string:
		#print( c + ", altas tile " + str(Vector2i(int(c), 0)) + " at " + str(Vector2i(-length + i, -1)) )
		set_cell(Vector2i(-length + i, -1), 0, Vector2i(int(c), 0))
		i += 1
