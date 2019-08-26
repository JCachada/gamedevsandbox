extends Camera2D;

enum {
	MODE_PLAYER,
	MODE_FOLLOW
}

const SNAP_DISTANCE = 5

signal following_wife;
export var speed = 1

var anchor   # To bring the camera back once it needs to. (Transform)
var target   # Node to follow or zoom on. (Node)
var mode     # Currently active mode. (int)
var targetAnchor # To check if the following motion is done.
var signals = true;

func follow(target_node):
	if !is_processing():
		anchor = transform
		set_process(true)
	target   = target_node
	targetAnchor = target.transform;
	mode     = MODE_FOLLOW
	
func go_to_player():
	target = null
	mode   = MODE_PLAYER
	set_process(true)

func snap_to_player():
	transform = anchor
	set_process(false)

func _ready():
	set_process(false)
	mode = MODE_PLAYER
	anchor = transform

func _process(delta): 
	match mode:
		MODE_PLAYER:
			var newTransform = transform.interpolate_with(anchor, delta * speed)
			if newTransform.origin.distance_to(anchor.origin) < SNAP_DISTANCE:
				transform = anchor
				set_process(false)
			else:
				transform = newTransform
		MODE_FOLLOW:
			var targetTransform = target.global_transform
			global_transform = global_transform.interpolate_with(targetTransform, delta * speed)
			if get_global_transform().origin.distance_to(targetAnchor.origin) < SNAP_DISTANCE && signals:
				emit_signal("following_wife");
				signals = false;