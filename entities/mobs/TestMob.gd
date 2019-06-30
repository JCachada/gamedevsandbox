extends KinematicBody2D

var mobHealth = 100;
var speed = 200
onready var player = get_node('../Player')
var screen_size
var stopMoving = false;
var GhostBullet = preload("res://entities/projectiles/GhostBullet.tscn")

## These variables are used to handle the mob's movement. The navigation node is useful for handling obstacles.
## The player node is also used for this.

onready var navigation = get_node('../Navigation2D');
var path = []
var startPosition = Vector2();
var endPosition = Vector2();

func start(pos):
	position = pos
	show()
	$CollisionPolygon2D.disabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$ProperAnimation.hide()
	$StartupAnimation.play('startup')
	screen_size = get_viewport_rect().size
	
func _on_StartupAnimation_animation_finished():
	$StartupAnimation.hide()
	$ProperAnimation.show()
	$ProperAnimation.play('idle')
	
func _process(delta):
	if mobHealth <= 0:
		queue_free();
	
	if stopMoving: 
		return;
	# The start position for the pathfinding is the mob's current position.
	# The goal position for the pathfinding is the player's current position.
	
	startPosition = position
	endPosition = player.position
	if(player.position.x > position.x): 
		$ProperAnimation.flip_h = true;
	else:
		$ProperAnimation.flip_h = false;
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
	
func is_attacked(damage):
	mobHealth = mobHealth - damage;

## If the player is inside the FOV, stop moving and attack.
	
func _on_FOV_body_entered(body):
	if(body == player):
		stopMoving = true;
		# "Muzzle" is a Position2D placed at the barrel of the gun.
		var b = GhostBullet.instance()
		b.start(position, player.position.x, player.position.y)
		get_parent().add_child(b)
	
## If the player is outside the FOV, start chasing him.
	
func _on_FOV_body_exited(body):
	if(body == player):
		stopMoving = false;