extends Control

# This classe's pause mode needs to be set to "process" so it always runs even when the game is paused.

var isActive;

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide();
	isActive = false;

func _input(event):
	if event.is_action_pressed("ui_cancel") && !isActive:
		# Pause the game
		get_tree().paused = true;
		# Show the menu
		self.show();
		isActive = true;
	elif event.is_action_pressed("ui_cancel") && isActive:
		# Unpause the game
		get_tree().paused = false;
		# Hide the menu
		self.hide();
		isActive = false;

func _on_Quit_Game_pressed():
	$ConfirmationDialog.popup();

func _on_ConfirmationDialog_confirmed():
	get_tree().quit();

func _on_ConfirmationDialog_custom_action(action):
	# Hide the popup.
	$ConfirmationDialog.hide();