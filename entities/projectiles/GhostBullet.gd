extends RigidBody2D;

var damagePerHit = 10;
var speed = 300; ## The x value is the speed at which the bullet is shot. 
var player;

func start(pos, target):
	position = pos;
	set_target(target);
	var bullet_rotation = get_angle_to(player.position) + self.rotation;
	self.rotation = bullet_rotation;
	
## This function is used so the parent Mob can tell the bullet what its target is.
	
func set_target(parent_target):
	player = parent_target;

func _physics_process(delta):
	var bodies = get_colliding_bodies(); # Checks for collision in every direction every frame.
	for b in bodies:
		if b.get_name() == "Player":
		## If the player can deal damage constantly upon colliding, the physics engine detects thousands of collisions
		## per second, making the player instantly deal a lot of damage. As such, the player can only damage once per animation.
		## The behavior for hit registering only happens if there is a collision.
			b.is_shot(damagePerHit);