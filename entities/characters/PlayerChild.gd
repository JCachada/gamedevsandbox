extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal movement_ended;
onready var navigation = get_node('../Navigation2D');
var endPosition;
var speed = 200;
var path = [];

export (Texture) var face;

export (Color) var color; # Color of the text.

export (float, 0.1, 1.9) var voice_pitch # How High / Low the Voice is.

export (String, FILE) var interaction_script # A .json dialogue file.

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false);
	$AnimatedSprite.play("idle");

func start(pos):
	position = pos;
	endPosition = pos;
	$AnimatedSprite.play("idle");

func _process(delta):
	if (position != endPosition):
		_update_path()
		if path.size() > 1:
			var to_walk = delta * speed
			while to_walk > 0 and path.size() >= 2:
				var pfrom = path[path.size() - 1]
				var pto = path[path.size() - 2]
				var d = pfrom.distance_to(pto)
				if d <= to_walk:
					path.remove(path.size() - 1)
					to_walk -= d
				else:
					path[path.size() - 1] = pfrom.linear_interpolate(pto, to_walk/d)
					to_walk = 0
		
			var atpos = path[path.size() - 1]
			position = atpos
		
		if path.size() < 2:
			path = []
			emit_signal("movement_ended");
	elif position == endPosition: 
		$AnimatedSprite.play("idle");

func move(pos):
	endPosition = pos;
	$AnimatedSprite.play("run");
	if(endPosition.x < position.x):
		$AnimatedSprite.flip_h = true;
	elif(endPosition.x > position.x):
		$AnimatedSprite.flip_h = false;
	set_process(true);

## Calculates a new path using the available Navigation 2D node. The startPosition and endPosition are updated every frame on the process function.

func _update_path():
	var p = navigation.get_simple_path(position, endPosition, true)
	path = Array(p) # PoolVector2Array too complex to use, convert to regular array
	path.invert()
	set_process(true)

func talk(script): 
	MSG.start_dialogue(false, script, self);