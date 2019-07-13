extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.start($PlayerStartPosition.position)
	$Mob.start($PlayerStartPosition.position)
	$CombatGUI.updateHealth(100);
	$CombatGUI.updateStamina(100);
	
func _on_Mob_shoot(bullet, pos):
	## Spawns the bullet, makes it move, and rotates it to move towards the player.
	var b = bullet.instance();
	add_child(b);
	var dir = Vector2(-1,0).rotated($Mob.position.angle_to_point($Player.global_position));
	b.start(pos, dir);

func _on_Player_update_Healthbar(health):
	$CombatGUI.updateHealth(health);