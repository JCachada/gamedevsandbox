extends Node2D

## TODO: Replace assets in this level with: https://www.gamedevmarket.net/asset/pixel-art-medieval-interiors/

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	MSG.connect("dialogue_ended", $Player, "on_dialogue_ended");
	global_signals.connect("cutscene_dialogue_what", self, "on_cutscene_dialogue_what");
	global_signals.connect("cutscene_step_1", self, "on_cutscene_step_1");
	global_signals.connect("cutscene_step_2", self, "on_cutscene_step_2");
	player_variables.currentScene = "res://mapNodes/Node_00_Tutorial/PlayerHomeInterior.tscn";
	$Player.start($PlayerStartPosition.position, false);
	$Player/IdleAnimation.play("idle");
	$Player.canMove = false;
	$StartPause.start();
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_StartPause_timeout():
	$Player/Camera2D.follow($PlayerWife);

func _on_Camera2D_following_wife():
	$PlayerWife.talk($PlayerWife.interaction_script);
	
func on_cutscene_dialogue_what():
	$PlayerChild.what();
	$PlayerWife.what();
	
func on_cutscene_step_1():
	$Player.canMove = false;
	$Player/Camera2D.go_to_player();
	$Player.move($Cutscene_Step_1_PlayerPos.position);
	
func on_cutscene_step_2():
	$Player.canMove = false;
	$Player/Camera2D.follow($PlayerChild);
	$PlayerChild.move($Cutscene_Step_2_ChildDog_Position.position);
	$Dog.move($Cutscene_Step_2_ChildDog_Position.position);
	
func _on_Player_movement_ended():
	$PlayerWife.talk($PlayerWife.interaction_script_2);

func _on_PlayerChild_movement_ended():
	$AnimationPlayer.play("Fade Out Kid and Dog");

func _on_AnimationPlayer_animation_finished(anim_name):
	if (anim_name == "Fade Out Kid and Dog"):
		$Player/Camera2D.go_to_player();
		#$PlayerWife.talk($PlayerWife.interaction_script_3);