extends KinematicBody2D

export var speed = 400  # How fast the player will move (pixels/sec).
var damagePerHit = 25; # Might be altered by variables in the code at runtime.
var screen_size;
var health = 100;
var isAttacking; ## Tracks if the player is attacking.
var isComboing = 0; ## Tracks if the player is comboing. 0 means "isn't comboing", 1 means "started comboing", 2 means "last combo stage."
var canDamage = true;
var velocity; # The player's movement vector.
signal update_Healthbar;
signal death;

func start(pos):
	position = pos
	show()
	$IdleCollisionBox.disabled = false

func _ready():
	## Disable all the attack state collision boxes.
	
	$Attack1CollisionBox.disabled = true;
	$Combo1CollisionBox.disabled = true;
	$Combo2CollisionBox.disabled = true;
	
	isAttacking = false;
	$AttackAnimation.hide();
	$IdleAnimation.show();
	$IdleAnimation.play()
	screen_size = get_viewport_rect().size

func _process(delta):
	
	velocity = Vector2();
	
	## Checks for attacks.
	
	## ATTACK 1
	
	if (Input.is_action_just_pressed("ui_leftClick") && (isComboing == 0)):
		## Start the timer that counts the combo window. 
		$ComboTimer.start();
		isAttacking = true;
		
		## Stop the previous animation before attacking.
		
		$IdleAnimation.hide();
		$AttackAnimation.show();
		$AttackAnimation.animation = "attack";
		
		## Flip the animation and the collision boxes if the player is moving.
		
		if (Input.is_action_pressed("ui_left")):
			$AttackAnimation.flip_v = false;
			$AttackAnimation.flip_h = true;
			$Attack1CollisionBox.scale.x = -1; 
		
		$AttackAnimation.play();
		$IdleCollisionBox.disabled = true;
		$Combo1CollisionBox.disabled = true;
		$Combo2CollisionBox.disabled = true;
		$Attack1CollisionBox.disabled = false;
	
	## COMBO 1
	
	if (Input.is_action_just_pressed("ui_leftClick") && (isComboing == 1)):
		## Restart the timer that counts the combo window. 
		$ComboTimer.start();
		isAttacking = true;
		
		## Stop the previous animation before attacking.
		$IdleAnimation.hide();
		$AttackAnimation.show();
		$AttackAnimation.animation = "combo1";
		
		## Flip the animation and the collision boxes if the player is moving.
		
		if (Input.is_action_pressed("ui_left")):
			$AttackAnimation.flip_v = false;
			$AttackAnimation.flip_h = true;
			$Combo1CollisionBox.scale.x = -1;
		
		$AttackAnimation.play();
		$IdleCollisionBox.disabled = true;
		$Attack1CollisionBox.disabled = true;
		$Combo2CollisionBox.disabled = true;
		$Combo1CollisionBox.disabled = false;
		
	## COMBO 2
	
	if (Input.is_action_just_pressed("ui_leftClick") && (isComboing == 2)):
		## Restart the timer that counts the combo window. 
		$ComboTimer.emit_signal("timeout");
		isAttacking = true;
		
		## Stop the previous animation before attacking.
		$IdleAnimation.hide();
		$AttackAnimation.show();
		$AttackAnimation.animation = "combo2";
		
		## Flip the animation and the collision boxes if the player is moving.
		
		if (Input.is_action_pressed("ui_left")):
			$AttackAnimation.flip_v = false;
			$AttackAnimation.flip_h = true;
			$Combo2CollisionBox.scale.x = -1;
		
		$AttackAnimation.play();
		$IdleCollisionBox.disabled = true;
		$Combo1CollisionBox.disabled = true;
		$Attack1CollisionBox.disabled = true;
		$Combo2CollisionBox.disabled = false;
	
	# Checks for player movement if there are no attacks. 
	
	else:
		if Input.is_action_pressed("ui_right"):
			velocity.x += 1
		if Input.is_action_pressed("ui_left"):
			velocity.x -= 1
		if Input.is_action_pressed("ui_down"):
			velocity.y += 1
		if Input.is_action_pressed("ui_up"):
			velocity.y -= 1
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			if(isAttacking == false):
				$IdleAnimation.play()
		position += velocity * delta
		position.x = clamp(position.x, 0, screen_size.x)
		position.y = clamp(position.y, 0, screen_size.y)
		if velocity.x != 0 && isAttacking == false:
			$IdleAnimation.animation = "run"
			$IdleAnimation.flip_v = false
			$IdleAnimation.flip_h = velocity.x < 0
		elif velocity.x == 0 && velocity.y == 0 && isAttacking == false:
			$IdleAnimation.animation = "idle"
		elif velocity.y != 0 && isAttacking == false:
			$IdleAnimation.animation = "run"
		
# warning-ignore:unused_argument
func _physics_process(delta):
	var collision = move_and_collide(Vector2(0, 0)); # Checks for collision in every direction every frame.
	if collision:
		## If the player can deal damage constantly upon colliding, the physics engine detects thousands of collisions
		## per second, making the player instantly deal a lot of damage. As such, the player can only damage once per animation.
		## The behavior for hit registering only happens if there is a collision.
		if (isAttacking == true && collision.collider.has_method("is_attacked") && canDamage == true):
			collision.collider.is_attacked(damagePerHit);
			canDamage = false;

func _on_AttackAnimation_animation_finished():
	## Increase the combo counter.
	
	isComboing += 1;
	
	isAttacking = false;
	$AttackAnimation.hide();
	canDamage = true;
	
	## Disable all the animations' collision boxes and restart the idle collision box.
	
	$IdleCollisionBox.disabled = false;
	$Combo2CollisionBox.disabled = true;
	$Attack1CollisionBox.disabled = true;
	$Combo1CollisionBox.disabled = true;
	
	## Disable all the possible flips in the animation and in the collision box.
	
	$AttackAnimation.flip_h = false;
	$AttackAnimation.flip_v = false;
	$Attack1CollisionBox.scale.x = 1;
	$Combo1CollisionBox.scale.x = 1;
	$Combo2CollisionBox.scale.x = 1;
	
	## Restart the idle animation. 
	
	$IdleAnimation.show();
	
func get_shot(damage):
	## This for makes the character flicker on getting shot. The number after i is the number of frames the character flickers for.
	for i in 4:
		self.modulate.a = 0.5;
		yield(get_tree(), "idle_frame");
		self.modulate.a = 1.0;
		yield(get_tree(), "idle_frame");
	health = health - damage;
	emit_signal("update_Healthbar", health);
	check_status();

func _on_ComboTimer_timeout():
	isComboing = 0;

func check_status():
	if (health <= 0):
		die();
	pass # Replace with function body.
	
func die():
	## Turn off normal player behavior.
	set_process(false);
	set_physics_process(false);
	## Die.
	$AttackAnimation.hide();
	$IdleAnimation.show();
	$IdleAnimation.play("death");
	emit_signal("death");