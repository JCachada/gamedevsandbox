
# PAUSE_MODE of its .tscn should be set to PROCESS

extends Node


##############################
# SETTINGS

var language = "ENG"

var dialogue_next_input = "dialogue_next"

var pause_time = 0.5 # Text pause time for MSG Box

var override_is_box = false # Mostly for testing (if set to true it will always use one type of the message)
var is_box = true # Using Box or Bubble? is_box >>> using Box



##############################
# DIALOGUE VARIABLES MANAGEMENT

var local_variables = {} # Stores local variables from the editor

func set_var(var_name, value):
	local_variables[MSG.current_json_path][var_name]["value"] = value

func var(var_name):
	return local_variables[MSG.current_json_path][var_name]["value"]

##############################
# VARIABLES
#signal message_started
#signal message_ended
signal dialogue_ended;
const FINISH = 0
const NEXT = 1
var after_press = FINISH
var repeats = {}
var final_text = ""
var json_data = {}
var delay = 0
var now = null
var next = null
var interacted_character = null
var current_speaker = null
var last_speaker = null
var message_done = false
var can_continue = false
var current_json_path = ""
var text_pauses_positions = []


########################################################################################
### PARSING JSON

######################################################
## LOAD JSON

func load_data(json_path):
	var f = File.new()
	f.open(json_path, File.READ)
	json_data = parse_json(f.get_as_text())
	f.close()


func get_node_by_name(node_name):
	for node in json_data[0]["nodes"]:
		if node["node_name"] == node_name:
			return node


func find_start():
	for node in json_data[0]["nodes"]:
		if node["node_type"] == "start":
			return node


########################################################################################
### MESSAGE SYSTEM

func start_dialogue(json_path, interacted_object=null):

	interacted_character = interacted_object
	current_json_path = json_path
	load_data(json_path)
	if ! local_variables.has(json_path):
		local_variables[json_path] = json_data[0]["variables"]
#		printt("variables", json_data[0]["variables"])

	#print(local_variables[json_path])

	can_continue = true
	message_done = true
#	find_start()
	next = find_start().next
	#print(next)
	#next()
	_auto_next()

func next():
	if delay == 0:
		if message_done:
			if can_continue:
				now = next
				if next != null:
					MSG_Bubble.hide()
					MSG_Box.hide()
					var this = get_node_by_name(now)


					match this.node_type:

						"show_message":
							if ! override_is_box:
								is_box = this.is_box
							if this.speaker_type == 0:
								current_speaker = level_root().get_node(this.character[0])
							elif this.speaker_type == 1:
								current_speaker = evaluate(this.object_path)
							else:
								current_speaker = interacted_character

							# GETTING VARIABLES
							if is_legacy():
								final_text = this.text
							else:
								print(this.text)
								final_text = this.text[language]

							while final_text.find("@") != -1: # does it have at least one call for variable?
								var p = final_text.find("@")
								var s = final_text.find(" ", p)
								var part = final_text.substr(p, s-p+1)
								var ev = final_text.substr(p+1, s-p-1)
#								printt("ev", ev)
								final_text = final_text.replace(part, str(evaluate(ev)))

							# FINDING PAUSES IN RAW TEXT
							text_pauses_positions.clear()
							var text_pauses = parse_bbcode(final_text)
							for x in text_pauses:
								if x == "|":
									if text_pauses_positions.empty():
										text_pauses_positions.append(text_pauses.find("|", 0))
									else:
										text_pauses_positions.append(text_pauses.find("|", text_pauses_positions.back()+1))
#									print("TEXT PAUSES POSITIONS: " + str(text_pauses_positions))

							# CLEARING TEXT FROM PAUSES
							final_text = final_text.replace("|", "")
							if this.has("choices"):
								can_continue = false
								update_text(final_text, true)
								add_choice_buttons(this.choices)
							else:
								update_text(final_text, false)
								next = this.next


						"set_local_variable":
							if json_data[0].has("editor_version") and json_data[0].editor_version == "2.1":
								if json_data[0]["variables"][this.var_name]["type"] == 0:
									set_var(this.var_name, this.value)
								elif json_data[0]["variables"][this.var_name]["type"] == 1:
									if this.operation_type == "SET":
										set_var(this.var_name, this.value)
									elif this.operation_type == "ADD":
										set_var(this.var_name, var(this.var_name) + this.value)
									elif this.operation_type == "SUBSTRACT":
										set_var(this.var_name, var(this.var_name) - this.value)
								elif json_data[0]["variables"][this.var_name]["type"] == 2:
									if this.toggle:
										set_var(this.var_name, !var(this.var_name))
									else:
										set_var(this.var_name, this.value)
							else:
								set_var(this.var_name, this.value)

							next = this.next
							_auto_next()


						"condition_branch":
							var c = this.text
							if evaluate(c):
								next = this["branches"]["True"]
							else:
								next = this["branches"]["False"]
							_auto_next()


						"repeat":
							if repeats.has(this.node_name):
								if repeats[this.node_name] > 0:
									repeats[this.node_name] = repeats[this.node_name] - 1
									next = this.next
								else:
									next = this.next_done
									repeats.erase(this.node_name)
								_auto_next()
							else:
								repeats[this.node_name] = this.value
								repeats[this.node_name] = repeats[this.node_name] - 1
								next = this.next
								_auto_next()


						"chance_branch":
							if chance(this.chance_1):
								next = this["branches"]["1"]
							else:
								next = this["branches"]["2"]
							_auto_next()


						"random_branch":
							var random = random(int(this.possibilities))
#							print(random)
							next = this["branches"][str(random)]
							_auto_next()


						"wait":
							delay = this.time
							next = this.next
							_auto_next()

						"execute":
							evaluate(this.text)
							next = this.next
							_auto_next()

				else:
					end()
		else:
			MSG_Bubble.finish_message()
			MSG_Box.finish_message()


func _auto_next(): # Automaticaly goes to the next text
	MSG_Bubble.hide()
	MSG_Box.hide()
	if delay == 0:
		next()
	else:
		yield(time(delay), "timeout")
		delay = 0
		next()

func update_text(text, any_choices):
	if is_box:
		MSG_Box.show()
		MSG_Box.start_message(text, any_choices)
	else:
		MSG_Bubble.show()
		var pos = Vector2()
		if current_speaker.get_node("MSG_pos"):
			pos = current_speaker.get_node("MSG_pos").global_position
		else:
			pos = current_speaker.global_position + Vector2(0, -96)
		MSG_Bubble.global_position = pos
		MSG_Bubble.start_message(text, any_choices)

# END THE DIALOGUE
func end():
	MSG_Bubble.hide()
	MSG_Box.hide()
	emit_signal("dialogue_ended");

########################################################################################
# CHOICES

func _create_button(x):
	var b = load("res://addons/MSG_System/choice_button.tscn").instance()
	if is_legacy():
		b.set_text(x["choice"].text)
	else:
		b.set_text(x.text[language])
	if is_box:
		MSG_Options.get_node("box_choices/choices").add_child(b)
	else:
		MSG_Options.get_node("bubble_choices/choices").add_child(b)
	return b

func add_choice_buttons(choices_array):
	if is_legacy():
		for x in choices_array:
			if x["choice"]["is_condition"]:
				if evaluate(x["choice"]["condition"]):
					_create_button(x)
				else:
					var b = _create_button(x)
	#				b.hide()
					b.disabled =  true
			else:
				_create_button(x)
	else:
		for x in choices_array:
			if x["is_condition"]:
				if evaluate(x["condition"]):
					_create_button(x)
				else:
					var b = _create_button(x)
	#				b.hide()
					b.disabled =  true
			else:
				_create_button(x)

	yield(time(0.1), "timeout")
	MSG_Options.all_options_added()


func choice_made(idx):
	if is_box:
		for x in MSG_Options.get_node("box_choices/choices").get_children():
			x.queue_free()
	else:
		for x in MSG_Options.get_node("bubble_choices/choices").get_children():
			x.queue_free()
	var id
	if is_legacy():
		id = get_node_by_name(now).choices[idx]["choice"]["next"]
	else:
		id = get_node_by_name(now).choices[idx]["next"]
	next = id
	can_continue = true
	_auto_next()

##########################################################################################################
# ADDITIONAL FUNCTIONS
# these can be put in a different file (remember to autoload it)

func time(sec):
	var timer = load("res://addons/MSG_System/other/timer.tscn").instance()
	get_tree().get_root().add_child(timer) #to process
	timer.set_wait_time(sec) # Set Timer's delay to "sec" seconds
	timer.start() # Start the Timer counting down
	return timer


func level_root():
	for x in get_tree().get_nodes_in_group("level_root"):
		return x


func main():
	return level_root().get_node("main")


func random(possibilities):
	randomize()
	var r = randi() % possibilities + 1
	return r


func chance(percent):
	randomize()
	var r = randi() % 100 + 1
	print("chance: " + str(r))
	if r <= percent:
		return true
	else:
		return false


func evaluate(input):
	var script = GDScript.new()
	script.set_source_code("func eval():\n\treturn " + input)
	script.reload()
	var obj = Reference.new()
	obj.set_script(script)
	return obj.eval()


func parse_bbcode(text):
	MSG.get_node("bbcode_parser").bbcode_text = text
	return MSG.get_node("bbcode_parser").text


func is_legacy():
	if json_data[0].has("editor_version"):
		return false;
	return true