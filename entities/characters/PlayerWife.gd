extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal attacking;

export (Texture) var face;

export (Color) var color; # Color of the text.

export (float, 0.1, 1.9) var voice_pitch # How High / Low the Voice is.

export (String, FILE) var interaction_script # A .json dialogue file.

export (String, FILE) var interaction_script_2 # A second .json dialogue file slot.

onready var player = get_node('../Player')

# Called when the node enters the scene tree for the first time.
func _ready():
	$AttackAnimation.stop();
	$AttackAnimation.hide();
	$AttackCollisionBox.disabled = true;
	$IdleAnimation.show();
	$IdleAnimation.play("idle");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_AttackAnimation_animation_finished():
	$AttackCollisionBox.disabled = false;
	emit_signal("attacking");

# 'Flipped' controls whether the animation needs to be flipped horizontally.
func cast(flipped):
	if(flipped):
		$AttackAnimation.flip_h = true;
	elif (!flipped):
		$AttackAnimation.flip_h = false;
	$IdleAnimation.hide();
	$AttackAnimation.show();
	$AttackAnimation.play("attack");

func talk(script): 
	MSG.start_dialogue(true, script, self);

func _on_WifeInteraction_body_entered(body):
	if(body == player):
		player.canInteract = true;
		player.interactable = self;

func _on_WifeInteraction_body_exited(body):
	if(body == player):
		player.canInteract = false;
		player.interactable = null;