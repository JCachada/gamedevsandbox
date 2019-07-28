extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	MSG.connect("dialogue_ended", $Player, "on_dialogue_ended");
	player_variables.currentScene = "res://mapNodes/Node_00_Tutorial/Node00_Tutorial_Start.tscn";
	$TalkPromptArea/TalkPromptSprite.hide();
	$MovementPromptArea.hide();
	$PlayerHome/EnterHouseArea/TalkPrompt.hide();
	$Player.start($PlayerStartPosition.position, false);
	$AnimationPlayer.play("Fade In");

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

## Show the prompts when the player is in the area.
func _on_MovementPromptArea_body_entered(body):
	$MovementPromptArea.show();

## Hide the prompts when the player is no longer in the area.
func _on_MovementPromptArea_body_exited(body):
	$MovementPromptArea.hide();

func _on_TalkPromptArea_body_entered(body):
	if(body == $Player):
		$Player.canInteract = true;
		$Player.interactable = $TalkPromptArea/KnightSprite;
		$TalkPromptArea/TalkPromptSprite.show();

func _on_TalkPromptArea_body_exited(body):
	if(body == $Player):
		$Player.canInteract = false;
		$Player.interactable = null;
		$TalkPromptArea/TalkPromptSprite.hide();

func _on_EnterHouseArea_body_entered(body):
	if(body == $Player):
		$Player.canInteract = true;
		$Player.interactable = $PlayerHome;
		$PlayerHome/EnterHouseArea/TalkPrompt.show();


func _on_EnterHouseArea_body_exited(body):
	if(body == $Player):
		$Player.canInteract = false;
		$Player.interactable = null;
		$PlayerHome/EnterHouseArea/TalkPrompt.hide();