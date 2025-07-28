extends Node2D

const USERNAME_PREFIX = "[wave][pulse freq=0.5 color=#dddddd40 ease=-2.0]"
@export var username_label: RichTextLabel

var username : String = "Unknown"

signal on_complete

func _ready() -> void:
	username_label.text = USERNAME_PREFIX + username

func _on_animation_finished(anim_name: StringName) -> void:
	on_complete.emit()
	queue_free()
