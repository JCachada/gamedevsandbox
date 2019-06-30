extends KinematicBody2D;

var damagePerHit = 10;
var directionToMove = Vector2(0,0);

func start(pos, movementVectorX, movementVectorY):
	position = pos;
	directionToMove.x = movementVectorX;
	directionToMove.y = movementVectorY;
	
func _ready():
	pass;
	
func _physics_process(delta):
	var collision = move_and_collide(directionToMove); # Checks for collision in every direction every frame.
	if collision:
		## If the player can deal damage constantly upon colliding, the physics engine detects thousands of collisions
		## per second, making the player instantly deal a lot of damage. As such, the player can only damage once per animation.
		## The behavior for hit registering only happens if there is a collision.
		if (collision.collider.has_method("is_shot")):
			collision.collider.is_shot(damagePerHit);