extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	if player_variables.saves_Exist():
		var counter = 0;
		var saved_Games = player_variables.get_All_Saves();
		for save in saved_Games:
			$ItemList.add_item(saved_Games[counter], null, true);
			counter = counter + 1;

func _on_ItemList_item_activated(index):
	var fileName = $ItemList.get_item_text(index);
	var filePath = "user://" + fileName;
	player_variables.load(filePath);