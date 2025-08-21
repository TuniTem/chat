extends Sprite2D

@export var viewport : SubViewport

func _ready() -> void:
	if Global.simplify_constellations:
		#$SubViewport/Telescope.scale = Vector2.ONE * 
		$SubViewport.size.y = 1920.0
		$SubViewport/Telescope.position.y = $SubViewport/Telescope.position.x


func display

func _input(event: InputEvent) -> void:
	if viewport: viewport.push_input(event)
