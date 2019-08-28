extends Node2D

## TODO: Replace assets in this level with: https://www.gamedevmarket.net/asset/pixel-art-medieval-interiors/

var stage = "start"; #Controls at which stage the scene is currently in.

# Called when the node enters the scene tree for the first time.
func _ready():
	MSG.connect("dialogue_ended", self, "on_dialogue_ended");
	global_signals.connect("cutscene_dialogue_what", self, "on_cutscene_dialogue_what");
	global_signals.connect("cutscene_step_1", self, "on_cutscene_step_1");
	global_signals.connect("cutscene_step_2", self, "on_cutscene_step_2");
	global_signals.connect("cutscene_step_3", self, "on_cutscene_step_3");
	global_signals.connect("cutscene_step_4", self, "on_cutscene_step_4");
	player_variables.currentScene = "res://mapNodes/Node_00_Tutorial/PlayerHomeInterior.tscn";
	$Player.start($PlayerStartPosition.position, false);
	$Player/IdleAnimation.play("idle");
	$Player.canMove = false;
	$StartPause.start();
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_StartPause_timeout():
	$PlayerWife.talk_specific($PlayerWife.interaction_script);
	
func on_cutscene_dialogue_what():
	$PlayerChild.what();
	$PlayerWife.what();
	
func on_cutscene_step_1():
	$Player/Camera2D.go_to_player();
	$Player.move($Cutscene_Step_1_PlayerPos.position);
	
func on_cutscene_step_2():
	$PlayerChild.move($Cutscene_Step_2_ChildDog_Position.position);
	$Dog.move($Cutscene_Step_2_ChildDog_Position.position);

func on_cutscene_step_3():
	player_variables.wifeDread = player_variables.wifeDread + 1;
	player_variables.stayedWithWife = false;
	stage = "final";

func on_cutscene_step_4():
	player_variables.wifeComfort = player_variables.wifeComfort + 1;
	player_variables.stayedWithWife = true;
	$AnimationPlayer.play("Stayed With Wife")
	
func _on_Player_movement_ended():
	$PlayerWife.talk_specific($PlayerWife.interaction_script_2);

func _on_PlayerChild_movement_ended():
	$AnimationPlayer.play("Fade Out Kid and Dog");

func _on_AnimationPlayer_animation_finished(anim_name):
	if (anim_name == "Fade Out Kid and Dog"):
		$PlayerWife.talk_specific($PlayerWife.interaction_script_3);
	if (anim_name == "Stayed With Wife"):
		$PlayerWife.talk_specific($PlayerWife.interaction_script_4);
		stage = "final";

func on_dialogue_ended():
	if stage == "final":
		$Player.canMove = true;