extends Sprite

signal interaction_ended;

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func talk(): ## This function is used to enter the house. 
	emit_signal("interaction_ended");
	pass;