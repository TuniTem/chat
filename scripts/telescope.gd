extends Node2D

func _ready() -> void:
	if Global.simplify_constellations:
		$Mag.hide()
		$Location.hide()
		$Info.hide()
		$BootText.hide()
		#$Stars/StarsView.size.y = 1920.0
		#scale = Vector2.ONE * 0.7125
