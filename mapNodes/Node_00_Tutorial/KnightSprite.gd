extends AnimatedSprite

export (Texture) var face;

export (Color) var color; # Color of the text.

export (float, 0.1, 1.9) var voice_pitch # How High / Low the Voice is.

export (String, FILE) var interaction_script # A .json dialogue file.

func talk(): ## This function is used to talk to the knight.
	MSG.start_dialogue(true, interaction_script, self);
	##TODO: Change it so talking to knight has persistent effects.