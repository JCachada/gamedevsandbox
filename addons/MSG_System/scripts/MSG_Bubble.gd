
# PAUSE_MODE of its .tscn should be set to PROCESS

extends Node2D

# Variables
onready var text = $main/label
onready var back = $main/NinePatchRect
var choices = false
var done = false

# Settings:
export var overall_scale = 1.0 # How big is the bubble?

const TEXT_SPEED = 0.04 # Contant text speed
const SOUND_SPEED = 0.1 # Contant sound speed
var dynamic_text_speed = true # Enable dynamic text speed?

var width_limit = 500 # Maximum width of the bubble (after that, it will start wrapping the text).
var y_offset = 0 # Offset on the Y axis


#############################

func _ready():
	hide()
	self.scale = Vector2(overall_scale, overall_scale)

########################################################################################################
# MAIN FUNCTIONS

func start_message(text, any_choices): # Message initiation

	if MSG.current_speaker.get("voice_pitch") != null:
		$SFX.pitch_scale = MSG.current_speaker.voice_pitch

	done = false
	$_continue.hide()
	$main/label.set_text(MSG.parse_bbcode(text))
	$main/label.visible_characters = 0
	if dynamic_text_speed:
		$characters_timer.wait_time = max(1 / (float($main/label.text.length() / 1.1)), 0.03)
		$SFX_Timer.wait_time = max(1 / (float($main/label.text.length() / 1.1)), 0.1)
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

	update()



func update():
	# POSITIONING OF THE LABEL AND THE BACKGROUND

	# TRIANGLE
	$main/message_triangle.rect_position.y = -2 + y_offset

	# LABEL (TEXT)
	text.autowrap = false
	text.rect_size.x = 0
	if text.rect_size.x > width_limit:
		text.autowrap = true
		yield(MSG.time(0.01), "timeout")
		text.rect_size.x = width_limit
	text.rect_size.y = text.get_minimum_size().y
	text.rect_position.y = (-(text.get_line_height() * text.get_line_count())) - (16 + (3 * (text.get_line_count() - 1))) + y_offset
	text.rect_position.x = - (text.rect_size.x / 2)

	# BACKGROUND
	back.rect_size.x = text.rect_size.x + 32
	back.rect_size.y = text.rect_size.y + 32
	back.rect_position.x = - (back.rect_size.x / 2)
	back.rect_position.y =  - back.rect_size.y + y_offset

	# READY TO CONTINUE INDICATOR
	$_continue.rect_position.x = back.rect_size.x / 2 - 38
	$_continue.rect_position.y = -46 + y_offset



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
		$_continue.show()



func _on_characters_timer_timeout(): # Text characters timer
	if $main/label.visible_characters < $main/label.get_total_character_count():
		$main/label.visible_characters += 1
	else:
		message_is_done()



func _on_SFX_Timer_timeout(): # Text sound timer
	if ! MSG.message_done:
		$SFX.play()


