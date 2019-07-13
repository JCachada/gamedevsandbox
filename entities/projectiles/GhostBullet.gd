extends Area2D;

export (int) var damagePerHit = 10;
export (int) var speed = 300; ## The x value is the speed at which the bullet is shot. 

var velocity = Vector2();

func start(pos, direction):
	$Explosion.hide();
	position = pos;
	rotation = direction.angle();
	velocity = direction * speed;
	
func _process(delta):
	position += velocity * delta;
	

func stop():
	velocity = Vector2(0,0);
	
func explode():
	$Explosion.show();
	stop();
	$Explosion.play();
	
func _on_GhostBullet_body_entered(body):
	$Sprite.hide();
	explode();
	if(body.has_method('get_shot')):
		body.get_shot(damagePerHit);

func _on_Explosion_animation_finished():
	queue_free();
