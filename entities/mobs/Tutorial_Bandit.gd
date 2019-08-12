extends Node2D

# Declare member variables here. Examples:
signal movement_ended();

onready var player = get_node('../Player')
onready var navigation = get_node('../Navigation2D');
var path = []
var speed = 200;
var startPosition = Vector2();
var endPosition = Vector2();
var myDelta; # Used to store the delta on every frame, so it can be used on the move() function.
var busy = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	myDelta = delta;
	if (busy):
		return;
		
	## This section makes the mob walks towards the player.
	
	startPosition = position
	endPosition = player.position
	if(player.position.x > position.x): 
		$CorruptedSprite.flip_h = true;
		$NormalSprite.flip_h = true;
	else:
		$CorruptedSprite.flip_h = false;
		$NormalSprite.flip_h = false;
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
			set_process(false)
	else:
		set_process(false)
	
## Calculates a new path using the available Navigation 2D node. The startPosition and endPosition are updated every frame on the process function.

func _update_path():
	var p = navigation.get_simple_path(startPosition, endPosition, true)
	path = Array(p) # PoolVector2Array too complex to use, convert to regular array
	path.invert()
	set_process(true)

func start(corrupted, pos): # Corrupted is a variable that determines which sprite is used. Pos is the start position.
	position = pos;
	if (corrupted):
		$NormalSprite.hide()
		$CorruptedSprite.show()
		$CorruptedSprite.play("idle");
	elif (!corrupted):
		$CorruptedSprite.hide();
		$NormalSprite.show();
		$NormalSprite.play("idle");

## This function makes the mob move towards a specific position on the map.

func move (target_pos):
	busy = true;
	var velocity = Vector2(0, 0);
	if target_pos.x < position.x:
		velocity.x -= 1;
	elif target_pos.x > position.x:
		velocity.x += 1;
	if target_pos.y < position.y:
		velocity.y -= 1;
	elif target_pos.y > position.y:
		velocity.y += 1;
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	while(target_pos != position):
		 position += velocity * myDelta;
	busy = false;
	emit_signal("movement_ended");

func corrupt():
	$AnimationPlayer.play("corruption");