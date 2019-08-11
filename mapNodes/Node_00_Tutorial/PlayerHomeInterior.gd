extends Node2D

## TODO: Replace assets in this level with: https://www.gamedevmarket.net/asset/pixel-art-medieval-interiors/

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	MSG.connect("dialogue_ended", $Player, "on_dialogue_ended");
	player_variables.currentScene = "res://mapNodes/Node_00_Tutorial/PlayerHomeInterior.tscn";
	$Player.start($PlayerStartPosition.position, false);
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass