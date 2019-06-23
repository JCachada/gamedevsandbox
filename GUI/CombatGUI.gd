extends MarginContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func updateHealth(health):
	$HBoxContainer/Bars/HealthBar/TextureProgress.value = health;

func updateStamina(stamina):
	$HBoxContainer/Bars/EnergyBar/TextureProgress.value = stamina;