extends Button

const ON_COLOR = Color("d27eac")
const OFF_COLOR = Color.DIM_GRAY * Color(1.0, 0.7, 0.7)

@export var data : String
@export var toggle : bool = false

func _ready() -> void:
	modulate = ON_COLOR if toggle else OFF_COLOR

func _on_pressed() -> void:
	ControlPanel.button_pressed.emit(data)
	toggle = not toggle
	modulate = ON_COLOR if toggle else OFF_COLOR
