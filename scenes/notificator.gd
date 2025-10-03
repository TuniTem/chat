extends Node2D

const SUB_TEXT_PREFIX = "[wave][pulse freq=0.5 color=#dddddd40 ease=-2.0]"
const TITLE_PREFIX = "[tornado radius=5.0 freq=2.0 connected=1]"

@export var sub_label : RichTextLabel
@export var title_label : RichTextLabel

var title_text : String = "Welcome Dreamer"
var sub_text : String = "Unknown"
signal on_complete


func _ready() -> void:
	sub_label.text = SUB_TEXT_PREFIX + sub_text
	title_label.text = TITLE_PREFIX + title_text

func _on_animation_finished(anim_name: StringName) -> void:
	on_complete.emit()
	queue_free()
