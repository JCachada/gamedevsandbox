extends Control

# This classe's pause mode needs to be set to "process" so it always runs even when the game is paused.

var isActive;
var onPopup;

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide();
	isActive = false;
	onPopup = false;

func _input(event):
	if event.is_action_pressed("ui_cancel") && !isActive && !onPopup:
		# Pause the game
		get_tree().paused = true;
		# Show the menu
		self.show();
		isActive = true;
	elif event.is_action_pressed("ui_cancel") && isActive && !onPopup:
		# Unpause the game
		get_tree().paused = false;
		# Hide the menu
		self.hide();
		isActive = false;

func _on_Quit_Game_pressed():
	onPopup = true;
	$ConfirmationDialog.popup();

func _on_ConfirmationDialog_confirmed():
	get_tree().quit();

func _on_Save_Game_pressed():
	player_variables.save("test");

func _on_ConfirmationDialog_popup_hide():
	onPopup = false;


func _on_Load_Game_pressed():
	get_tree().paused = false;
	get_tree().change_scene("res://GUI/Load Menu/Load Menu.tscn");