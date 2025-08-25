extends Node2D

const LOOP_REST = 10.0

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
		print("CL a")
		if Global.POIs.size() == 0:
			can_loop = false
			break
		
		var targ : Dictionary = Global.POIs.pick_random()
		print("CL b")
		
		await stars.move_to_location(targ["location"], targ["zoom_range"][0] + Util.EPSILON, true)
		stars.camera.send_ping(false)
		print("CL c")
		await Util.wait(LOOP_REST)
		print("CL d")
	
	loop_done.emit()



func stop_loop(wait : bool = false):
	print("canloop: ", can_loop)
	if can_loop:
		can_loop = false
		if wait: await loop_done
