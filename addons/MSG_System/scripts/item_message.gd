
extends Control

var id = "" setget set_id
var icon = "" setget set_icon

func set_id(v):
	id = v
	$text_container/hbox/item.text = id

func set_icon(v):
	icon = v
	$text_container/hbox/icon.texture = load(icon)


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
