extends Panel

func _ready():
# warning-ignore:return_value_discarded
	get_node("Button").connect("pressed", self, "_on_Button_pressed")

func _on_Button_pressed():
	get_node("Label").text = "Endon is big gay!"