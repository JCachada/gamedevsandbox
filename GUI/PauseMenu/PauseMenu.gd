extends Control

# This classe's pause mode needs to be set to "process" so it always runs even when the game is paused.

signal game_saved; # For whenever the game is actually saved.
var isActive;
var onPopup;
var tempSaveName; # This variable exists to send the saved game from the main function to the confirmation dialogue. It's meant to be temporary and reset after usage.

# Called when the node enters the scene tree for the first time.
func _ready():
	$"Game Saved Feedback".hide();
	$"No Saves Feedback".hide();
	$SaveName.hide();
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
	$"Quit Game/QuitConfirmation".popup();

func _on_ConfirmationDialog_confirmed():
	get_tree().quit();

func _on_Save_Game_pressed():
	$SaveName.show();
	onPopup = true;

func _on_ConfirmationDialog_popup_hide():
	onPopup = false;


func _on_Load_Game_pressed():
	if player_variables.saves_Exist():
		get_tree().paused = false;
		get_tree().change_scene("res://GUI/Load Menu/Load Menu.tscn");
	elif !player_variables.saves_Exist():
		$"No Saves Feedback".show();
		$"No Saves Feedback/Hide Feedback No Saves".start();

func _on_GetSaveName_text_entered(new_text):
	## Handle repeated saves.
	
	var saves = player_variables.get_All_Saves();
	for save in saves: 
		if save.begins_with(new_text + "."):
			tempSaveName = new_text;
			$SaveName/SaveConfirmation.popup();
			return;
	## Save game if not repeated.
	player_variables.save(new_text);
	$SaveName.hide();
	onPopup = false;
	emit_signal("game_saved");

func _on_SaveConfirmation_popup_hide():
	onPopup = false;

func _on_SaveConfirmation_confirmed():
	player_variables.save(tempSaveName);
	$SaveName.hide();
	onPopup = false;
	emit_signal("game_saved");

func _on_PauseMenu_game_saved():
	$"Game Saved Feedback".show();
	$"Game Saved Feedback/Hide Feedback".start();


func _on_Hide_Feedback_timeout():
	$"Game Saved Feedback".hide();

func _on_Hide_Feedback_No_Saves_timeout():
	$"No Saves Feedback".hide();