extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	$Timer.connect("timeout", self,"_on_timer_timeout")
	
func _on_timer_timeout():
	$Sprite.visible = !$Sprite.visible

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass