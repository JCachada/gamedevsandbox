extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var myDelta;

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	global_signals.connect("cutscene_dialogue_ended", self, "_on_PlayerChild_cutscene_dialogue_ended");
# warning-ignore:return_value_discarded
	MSG.connect("dialogue_ended", $Player, "on_dialogue_ended");
	player_variables.currentScene = "res://mapNodes/Node_00_Tutorial/Node00_Tutorial_Start.tscn";
	$TalkPromptArea/TalkPromptSprite.hide();
	$MovementPromptArea.hide();
	$PlayerHome/EnterHouseArea/TalkPrompt.hide();
	$Player.start($PlayerStartPosition.position, false);
	$PlayerChild.start($ChildStartPosition.position);
	$Dog.start($DogStartPosition.position);
	$AnimationPlayer.play("Fade In");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	myDelta = delta;

## Show the prompts when the player is in the area.
# warning-ignore:unused_argument
func _on_MovementPromptArea_body_entered(body):
	$MovementPromptArea.show();

## Hide the prompts when the player is no longer in the area.
# warning-ignore:unused_argument
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

func _on_SonCutsceneActivation_body_entered(body):
	if (body == $Player):
		$PlayerChild/SonCutsceneActivation.queue_free();
		$Player.canMove = false;
		$Player/IdleAnimation.play("idle");
		$PlayerChild.talk($PlayerChild.interaction_script);

func _on_PlayerChild_movement_ended():
	$AnimationPlayer.play("Fade Out Kid and Dog");

func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "Fade Out Kid and Dog"):
		$Player/Camera2D2.go_to_player();
		$Player.canMove = true;

func _on_PlayerChild_cutscene_dialogue_ended():
	$Player/Camera2D2.follow($PlayerChild);
	$Dog.move($ChildEndPosition.position);
	$PlayerChild.move($ChildEndPosition.position);