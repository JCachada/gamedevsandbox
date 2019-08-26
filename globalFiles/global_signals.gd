extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal cutscene_dialogue_ended;
signal cutscene_dialogue_what; # Makes the ! pop up above some dialogue characters.
signal cutscene_step_1; # Generic signal to make a cutscene move forward. Specific implementation is done on the scene's root.
signal cutscene_step_2; # Generic signal to make a cutscene move forward. Specific implementation is done on the scene's root.

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass