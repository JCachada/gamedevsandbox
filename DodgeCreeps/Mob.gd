extends RigidBody2D

# warning-ignore:unused_class_variable
export var min_speed = 150  # Minimum speed range.
# warning-ignore:unused_class_variable
export var max_speed = 250  # Maximum speed range.
var mob_types = ["walk"]

func _ready():
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()