extends Sprite

export (Texture) var face;

export (Color) var color; # Color of the text.

export (float, 0.1, 1.9) var voice_pitch # How High / Low the Voice is.

export (String, FILE) var interaction_script # A .json dialogue file.

onready var player = get_node('../Player')

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func talk(): 
	MSG.start_dialogue(true, interaction_script, self);

func _on_WifeInteraction_body_entered(body):
	if(body == player):
		player.canInteract = true;
		player.interactable = self;

func _on_WifeInteraction_body_exited(body):
	if(body == player):
		player.canInteract = false;
		player.interactable = null;