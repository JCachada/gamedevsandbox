
# PAUSE_MODE of its .tscn should be set to PROCESS

extends ParallaxBackground

# Variables
var choices = false
var done = false

# Settings:
const TEXT_SPEED = 0.04 # Contant text speed
const SOUND_SPEED = 0.1 # Contant sound speed
var dynamic_text_speed = true # Enable dynamic text speed?


#############################

func _ready():
	hide()

func hide(): # override hide() function
	$main.hide()

func show(): # override showS() function
	$main.show()

########################################################################################################
# MAIN FUNCTIONS



func start_message(text, any_choices): # Message initiation

	if MSG.current_speaker.get("face") != null:
		$main/face.texture = MSG.current_speaker.face
		$main/label.margin_left = 230
	else:
		$main/label.margin_left = 60
		$main/face.texture = null

	if MSG.current_speaker.get("color") != null:
		$main/name.modulate = MSG.current_speaker.color

	$main/name.text = str(MSG.current_speaker.name)

	if MSG.current_speaker.get("voice_pitch") != null:
		$SFX.pitch_scale = MSG.current_speaker.voice_pitch

	done = false
	$main/_continue.hide()
	$main/label.set_bbcode(text)
	$main/label.visible_characters = 0

	if dynamic_text_speed:
		$characters_timer.wait_time = max(1 / (float($main/label.bbcode_text.length() / 1.1)), 0.05)
		$SFX_Timer.wait_time = max(1 / (float($main/label.bbcode_text.length() / 1.1)), 0.1)
	else:
		$characters_timer.wait_time = TEXT_SPEED
		$SFX_Timer.wait_time = SOUND_SPEED

	$characters_timer.start()
	$SFX_Timer.start()

	choices = any_choices
	MSG.message_done = false
	if choices:
		MSG.can_continue = false
	else:
		MSG.can_continue = true

	$SFX.pitch_scale = MSG.current_speaker.voice_pitch



func finish_message(): # If pressed [dialogue_next] button while the text was appearing >>> jump to the end.
	$main/label.visible_characters = $main/label.get_total_character_count()



func message_is_done(): # Message is now fully shown.
	done = true

	$SFX_Timer.stop()
	$characters_timer.stop()

	MSG.message_done = true
	if choices:
		MSG_Options.activate()
	else:
		$main/_continue.show()



var current_char = 0
func _on_characters_timer_timeout(): # Text characters timer
	if $main/label.visible_characters < $main/label.text.length():
		if MSG.text_pauses_positions.has(current_char):
			$characters_timer.stop()
			$SFX_Timer.stop()
			yield(MSG.time(MSG.pause_time), "timeout")
			$characters_timer.start()
			$SFX_Timer.start()
			$main/label.visible_characters += 1
			if MSG.text_pauses_positions.has(current_char+1):
				current_char += 1
			else:
				current_char += 2
		else:
			$main/label.visible_characters += 1
			current_char += 1
	else:
		current_char = 0
		message_is_done()



func _on_SFX_Timer_timeout(): # Text sound timer
	if ! MSG.message_done:
		$SFX.play()

