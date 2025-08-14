extends Button

@export var data : String

func _on_pressed() -> void:
	ControlPanel.button_pressed.emit(data)
