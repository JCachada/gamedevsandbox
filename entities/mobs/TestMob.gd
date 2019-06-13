extends KinematicBody2D

var mobHealth = 100;
var speed = 200
var velocity = Vector2()  # The mob's movement vector.
onready var player = get_node('../Player')
var screen_size

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

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
	
	## This changes the movement of the mob. This mob simply chases the player around.
	
	if player.position.x > position.x:
		velocity.x += speed
	if player.position.x < position.x:
		velocity.x -= speed
	if player.position.y > position.y:
		velocity.y += speed
	if player.position.y < position.y:
		velocity.y -= speed
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		position += velocity * delta
		position.x = clamp(position.x, 0, screen_size.x)
		position.y = clamp(position.y, 0, screen_size.y)
	
	## This changes the animation to match the movement.
	
	if velocity.x != 0:
		$ProperAnimation.animation = "moving"
		$ProperAnimation.flip_v = false
		$ProperAnimation.flip_h = velocity.x > 0
	elif velocity.x == 0 && velocity.y == 0:
		$ProperAnimation.animation = "idle"
	elif velocity.y != 0:
		$ProperAnimation.animation = "moving"
		
func _physics_process(delta):
	move_and_collide(Vector2(0, 0))