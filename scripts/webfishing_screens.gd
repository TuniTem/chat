extends Sprite2D
@onready var title_text: Control = $"SubViewport/3DScreen/wepfishingsign/Cube_001/Sprite3D/SubViewport/TitleText"
@onready var animation_player: AnimationPlayer = $"SubViewport/3DScreen/wepfishingsign/AnimationPlayer"

var screen_id : String = "brb"

func _ready() -> void:
	title_text.text_group = screen_id
	await get_tree().create_timer(2.0).timeout
	animation_player.play("sway", 1.0)

func fade():
	animation_player.play("bye", 1.0)
