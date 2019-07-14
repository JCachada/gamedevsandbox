
extends Button

var can_be_pressed = false

func _on_choice_b_button_down():
	if can_be_pressed:
		$sfx_select.play()
		MSG.choice_made(get_index())
		MSG_Options.deactivate()


func _on_choice_b_focus_entered():
	$sfx_focus.play()
