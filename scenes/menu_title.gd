extends Node2D


func activate():
	visible = true
	$"..".current_button = $MainBtnPlay

func deactivate(): 
	visible = false
