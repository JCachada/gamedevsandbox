extends Area2D

export var speed = 400  # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
signal hit

func _ready():
	hide()
	screen_size = get_viewport_rect().size

func _process(delta):
	var velocity = Vector2()  # The player's movement vector.
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
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		#Flip _v is flip vertically, flip_h is flip horizontally.
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0
		
func _on_Player_body_entered(body):
	emit_signal("hit")
	hide()
	$CollisionShape2D.call_deferred("set_disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false