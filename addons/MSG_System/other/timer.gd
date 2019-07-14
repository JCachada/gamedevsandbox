extends Timer

# PAUSE_MODE of its .tscn should be set to PROCESS

# This simple timer is used only for in-script delays. It deletes itself after the timeout.

func _ready():
	connect("timeout", self, "on_timeout")

func on_timeout():
	queue_free()
