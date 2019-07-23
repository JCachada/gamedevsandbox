extends Node

## This node is used to store variables that need to persist between multiple scenes. 
## It's effectively responsible for handling saved games.

signal noSaves;
var currentScene; # The scene the player was in at the time of saving.
var playerHealth = 100; # The health of the player character.
var kickedChest = false; 
var counter = 0;

func save(fileName):
	# Get a screenshot to go with the saved game.
	get_viewport().queue_screen_capture()
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	var capture = get_viewport().get_screen_capture();
	## Create the dictionary with the data we want to save.
	var save_dictionary = {
		"fileName": fileName,
		"filePath": "user://savegame" + counter + ".save",
		"screenshot": capture,
		"currentScene": currentScene,
		"kickedChest": kickedChest,
		"playerHealth": playerHealth
	}
	## Write the data to a file.
	var saved_game = File.new();
	saved_game.open("user://savegame" + counter + ".save", File.WRITE);
	saved_game.store_line(to_json(save_dictionary));
	saved_game.close();
	counter = counter + 1;

func load(filePath):
	## If there are no saved games, emit a warning signal and do nothing.
	if !saves_Exist(): 
		return false;
	## Try to open the saved game we selected. TODO Needs a way to handle failure.
	var saved_game = File.new();
	saved_game.open(filePath, File.READ);
	## Load all the variables into this singleton.
	while not saved_game.eof_reached():
		var currentLine = parse_json(saved_game.get_line());
		for i in currentLine.keys():
			player_variables.set(i, currentLine.i);
	## Data loaded successfully.
	return true;

func saves_Exist():
	## Navigate to the save file directory.
	var directory = Directory.new();
	var userDir = directory.open("user://");
	if userDir != OK: ## Something might be wrong with the directory.
		return false;
	## Now we check the files inside the directory.
	elif userDir == OK:
		var files = directory.list_dir_begin();
		## If there are no files, there are no save games.
		if files != OK:
			return false;
		## If there are files, look for files with the .save extension.
		while true:
			var file = directory.get_next();
			if file.get_extension() == ".save":
				return true;
			if file == "":
				break;
		## If there are no files with a .save extension, there are no saved games.
		directory.list_dir_end();
		return false;