extends Sprite

signal interaction_ended;

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func talk(): ## This function is used to enter the house. 
	get_tree().change_scene("res://mapNodes/Node_00_Tutorial/PlayerHomeInterior.tscn");