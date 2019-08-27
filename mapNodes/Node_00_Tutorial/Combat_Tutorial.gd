extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.start($PlayerStartPosition.position, true);
	$Tutorial_Bandit.start(false, $MobStartPosition.position);

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass