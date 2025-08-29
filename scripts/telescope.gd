extends Node2D

const LOOP_REST = 10.0
const CONST_PREVIEW_ZOOM : float = 0.4

@onready var stars: Node2D = $Stars/StarsView/Stars

signal loop_done
signal intro_finish

var can_loop : bool = false
var intro_finished : bool = false

func _ready() -> void:
	if Global.simplify_constellations:
		$Mag.hide()
		$Location.hide()
		$Info.hide()
		$BootText.hide()
		$Scope/ticks.MAX_LENGTH = 0.0
		$Scope/Inner2.hide()
		#$Stars/StarsView.size.y = 1920.0
		#scale = Vector2.ONE * 0.7125
	
	await Util.wait(Global.STARS_OPENING_ANIMATION_LENGTH)
	intro_finished = true
	intro_finish.emit()


func start_loop():
	can_loop = true
	while can_loop:
		if Global.POIs.size() == 0:
			can_loop = false
			break
		
		var targ : Dictionary = Global.POIs.pick_random()
		var zoom : float = CONST_PREVIEW_ZOOM if targ["type"] == "Fragment" else (targ["zoom_range"][0] + Util.EPSILON) 
		await stars.move_to_location(targ["location"], zoom, true)
		await Util.wait(0.25)
		stars.camera.send_ping(false)
		Util.hide_smooth(Global.crosshair, 0.0)
		await Util.wait(LOOP_REST)
		Util.show_smooth(Global.crosshair)
	
	loop_done.emit()



func stop_loop(wait : bool = false):
	print("canloop: ", can_loop)
	if can_loop:
		can_loop = false
		if wait: await loop_done
