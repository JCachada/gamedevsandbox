extends Camera2D

var target_transform;
var node_to_follow;

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false);

func follow(node):
	node_to_follow = node;

func _physics_process(delta):
    position = position.linear_interpolate(node_to_follow.position, delta * 2);