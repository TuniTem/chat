extends Control
const PREFIX : String = "[wave]"

@onready var label: RichTextLabel = $Button/HBoxContainer/Label

var visiblity : float = 0.1

func _ready() -> void:
	Music.music_changed.connect(_on_music_changed)
	Global.music_widget = self

func _process(delta: float) -> void:
	if visiblity > 0.0:
		visiblity -= delta
		modulate = Color(Color.WHITE * clamp(visiblity, 0.0, 1.0), clamp(visiblity * 4.0, 0.0, 1.0))

func _on_music_changed(to: String):
	label.text = PREFIX + to
	visiblity = 5.0

func _on_button_pressed() -> void:
	visiblity = 10.0
