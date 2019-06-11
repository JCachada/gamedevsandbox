extends RigidBody2D

var mobHealth = 100;
var speed = 100;

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$ProperAnimation.hide()
	$StartupAnimation.play('startup')

func _on_StartupAnimation_animation_finished():
	$StartupAnimation.hide()
	$ProperAnimation.show()
	$ProperAnimation.play('idle')