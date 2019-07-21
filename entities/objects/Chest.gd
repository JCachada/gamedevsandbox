extends "res://entities/objects/Object.gd";

export (Texture) var face;

export (Color) var color; # Color of the text.

export (float, 0.1, 1.9) var voice_pitch # How High / Low the Voice is.

export (String, FILE) var interaction_script # A .json dialogue file.

onready var player = get_node('../Player')
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_InteractionArea_body_entered(body):
	if(body == player):
		player.canInteract = true;
		player.interactable = self;

func _on_InteractionArea_body_exited(body):
	if(body == player):
		player.canInteract = false;
		player.interactable = null; 
		
func talk(): ## This function is used to talk to the chest. It's on standby until the dialogue .json generator is purchased.
	MSG.start_dialogue(interaction_script, self);
	
func setKicked():
	player_variables.kickedChest = true;