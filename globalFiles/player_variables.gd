extends Node

## This node is used to store variables that need to persist between multiple scenes. 
## It's effectively responsible for handling saved games.

var currentScene; # The scene the player was in at the time of saving.
var playerHealth = 100; # The health of the player character.
var kickedChest = false; 
var counter = 0;

## Global story events / artifacts

var wifeComfort = 0;
var wifeDread = 0;

## Node 00 Variables:

var talkedToElders = false;
var kidCutscenePlayed = false;
var sawCutsceneInsideHome = false;
var stayedWithWife;

func save(fileName):
	## Create the dictionary with the data we want to save.
	var save_dictionary = {
		"fileName": fileName,
		"filePath": "user://savegame" + counter as String + ".save",
		"currentScene": currentScene,
		"kickedChest": kickedChest,
		"playerHealth": playerHealth,
		
		## Story / Scene Events Artifacts
		
		"wifeComfort": wifeComfort,
		"wifeDread": wifeDread,
		
		## Node00_Tutorial
		
		"talkedToElders": talkedToElders,
		"kidCutscenePlayed": kidCutscenePlayed,
		"sawCutsceneInsideHome": sawCutsceneInsideHome,
		"stayedWithWife": stayedWithWife
	}
	## Write the data to a file.
	var saved_game = File.new();
	if fileName.begins_with("autosavegame"):
		saved_game.open("user://autosavegame" + counter as String+ ".save", File.WRITE);
		saved_game.store_line(to_json(save_dictionary));
		saved_game.close();
	else:
		saved_game.open("user://" + fileName + ".save", File.WRITE);
		saved_game.store_line(to_json(save_dictionary));
		saved_game.close();
	counter = counter + 1;
	print(OS.get_user_data_dir()); # Debug line to navigate to the folder with file explorer.

func load(filePath):
	var counter = 0;
	var loaded = false;
	## Try to open the saved game we selected. TODO Needs a way to handle failure.
	var saved_game = File.new();
	saved_game.open(filePath, File.READ);
	## Load all the variables into this singleton.
	while not loaded:
		var currentLine = parse_json(saved_game.get_line());
		var keys = currentLine.keys();
		var values = currentLine.values(); 
		for key in keys:
			player_variables.set(keys[counter], values[counter]);
			counter = counter+1;
		loaded = true;
	## Data loaded successfully.
	get_tree().change_scene(currentScene);
	return;

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
			if file.ends_with(".save"):
				return true;
			if file == "":
				break;
		## If there are no files with a .save extension, there are no saved games.
		directory.list_dir_end();
		return false;

func get_All_Saves():
	var files = [];
	## Navigate to the save file directory.
	var directory = Directory.new();
	var userDir = directory.open("user://");
	var dirFiles = directory.list_dir_begin();
	# If it's a save file, append it. Ignore hidden files.
	while true:
			var file = directory.get_next();
			if file == "":
				break;
			elif not file.begins_with(".") && file.ends_with(".save"):
				files.append(file);
	directory.list_dir_end();
	return files;