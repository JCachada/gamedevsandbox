extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Function that determines what happens when the new game button is pressed.
# For now, just sends to a new start scene. This should be changed later (check github issue #4).

func _on_New_Game_pressed():
	get_tree().change_scene("res://mapNodes/PLACEHOLDER_MapNode.tscn")