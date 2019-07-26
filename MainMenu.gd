extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass;

func _init():
	## Get the autosave counter on boot.
	var autoSaveCounter = 0; 
	var saves = player_variables.get_All_Saves();
	for string in saves:
		if string.begins_with("autosavegame"):
			var tempString = string.replace("autosavegame", "");
			tempString = tempString.format(".save", "");
			if tempString as int > autoSaveCounter:
				autoSaveCounter = tempString as int;
	player_variables.counter = autoSaveCounter;

# Function that determines what happens when the new game button is pressed.
# For now, just sends to a new start scene. This should be changed later (check github issue #4).

func _on_New_Game_pressed():
	get_tree().change_scene("res://mapNodes/PLACEHOLDER_MapNode.tscn")

func _on_Quit_pressed():
	get_tree().quit()