extends Camera2D

const DRAW_DIST : float = 0.3
const SHAKE_INTENSITY : float = 1.0
const GLITCH_CHANCE : int = 10

const UI_COLOR : Color = Color(1.0, 1.0, 1.0, 1.0)
const NEARBY_COLOR : Color = Color(1.0, 0.7, 1.0, 0.2)

@export var stars_viewer : Node2D
@onready var scale_canvas: Node2D = $ScaleCanvas

var POI : Dictionary = {}
	#"id" : id,
	#"location" : Vector2,
	#"zoom_range" : Array, [numerical lower, numerical higher]
	#"bounding_box" : Vector2,
	#"type" : String,
	#"name" : String,
	#"status" : String,
	#"description" : String,
	#"extra_info" : Array[Array[String]] [["title1", value1 (variant)], "title2", value2 (variant)]]
	#"dupe_verify": int

const CONFIRM_DELAY : float = 5.0
const CONFIRM_SPEED : float = 1.3

var prev_poi_id : int = 0
var nearby_POIs : Array[Dictionary] = []
var confirm_amount : float = 0.0
var delay_timer : float = 0.0

# confirm and draw nearby
var has_poi : bool:
	get():
		return POI != {}

var has_nearby_pois : bool:
	get():
		return nearby_POIs.size() > 0

var counter : int = 0
var prev_cam_pos : Vector2 = Vector2.ZERO
func _process(delta: float) -> void:
	var result : Array = Global.get_nearby_POIs(global_position, stars_viewer.zoom)
	POI = result[0]
	nearby_POIs = result[1]
	
	
	
	
	scale_canvas.scale = Vector2.ONE * (1.0 / zoom.x)
	
	counter += 1
	if counter >= 10:
		counter = 0
		queue_redraw()
	
	if has_poi:
		if not (Input.is_action_pressed("up") or Input.is_action_pressed("down") or Input.is_action_pressed("left") or Input.is_action_pressed("right") or Input.is_action_pressed("scope_zoom_in") or Input.is_action_pressed("scope_zoom_out")):
			global_position = lerp(global_position, POI["location"], delta * 0.8)
		
		if POI["id"] != prev_poi_id:
			reset_confirm_progress()
		else:
			delay_timer += delta
			if delay_timer > CONFIRM_DELAY:
				confirm_amount = clamp(lerp(confirm_amount, 1.0, delta * CONFIRM_SPEED) + CONFIRM_SPEED / 60.0 * delta, 0.1, 1.0)
				confirm_amount = clamp(confirm_amount - abs(position.length() - prev_cam_pos.length()) / 300.0, 0.0, 1.0)
		
		
		prev_poi_id = POI["id"]
	else:
		reset_confirm_progress()
	

func reset_confirm_progress():
	confirm_amount = 0.0
	delay_timer = 0.0
	

func _draw() -> void:
	if has_poi:
		var drift : Vector2 = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * SHAKE_INTENSITY * abs(position.length() - prev_cam_pos.length())
		
		#if randi_range(1, 100) <= GLITCH_CHANCE: drift += Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * 1000.0
		var bb : Vector2 = POI["bounding_box"] / 2.0
		var dd : float = DRAW_DIST * min(bb.x, bb.y)
		var lines : Array[Array] = [ 
			
			
			# nvm i just overcomplicated it lol
			[bb, bb + Vector2(0.0, -dd)], [bb, bb + Vector2(-dd, 0.0)],
			[bb * Vector2(-1.0, 1.0), bb * Vector2(-1.0, 1.0) + Vector2(0.0, -dd)], [bb * Vector2(-1.0, 1.0), bb * Vector2(-1.0, 1.0) + Vector2(dd, 0.0)],
			[bb * Vector2(-1.0, -1.0), bb * Vector2(-1.0, -1.0) + Vector2(0.0, dd)], [bb * Vector2(-1.0, -1.0), bb * Vector2(-1.0, -1.0) + Vector2(dd, 0.0)],
			[bb * Vector2(1.0, -1.0), bb * Vector2(1.0, -1.0) + Vector2(0.0, dd)], [bb * Vector2(1.0, -1.0), bb * Vector2(1.0, -1.0) + Vector2(-dd, 0.0)]
			
		]
		
		if confirm_amount > Global.FINE_EPSILON:
			lines.append_array([
				# this took so much brainwpoer to write
				[bb, bb * Vector2(1.0, 1.0-confirm_amount)], [bb, bb * Vector2(1.0-confirm_amount, 1.0)],
				[bb * Vector2(-1.0, 1.0), bb * Vector2(-1.0, 1.0-confirm_amount)], [bb * Vector2(-1.0, 1.0), bb * Vector2(-1.0+confirm_amount, 1.0)],
				[bb * Vector2(-1.0, -1.0), bb * Vector2(-1.0, -1.0+confirm_amount)], [bb * Vector2(-1.0, -1.0), bb * Vector2(-1.0+confirm_amount, -1.0)],
				[bb * Vector2(1.0, -1.0), bb * Vector2(1.0, -1.0+confirm_amount)], [bb * Vector2(1.0, -1.0), bb * Vector2(1.0-confirm_amount, -1.0)]
			])
		var line_offset : Vector2 = to_local(POI["location"])
		
		for line : Array in lines:
			draw_line(line[0] + line_offset + drift, line[1] + line_offset+ drift, UI_COLOR, -2.0, false)
	
	for nearby_poi in nearby_POIs:
		var drift : Vector2 = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * SHAKE_INTENSITY * abs(position.length() - prev_cam_pos.length())
		#if randi_range(1, 100) <= GLITCH_CHANCE: drift += Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * 1000.0
		var bb : Vector2 = nearby_poi["bounding_box"] / 2.0
		var dd : float = DRAW_DIST * min(bb.x, bb.y) / 2.0
		var lines : Array[Array] = [ 
			
			
			# nvm i just overcomplicated it lol
			[bb, bb + Vector2(0.0, -dd)], [bb, bb + Vector2(-dd, 0.0)],
			[bb * Vector2(-1.0, 1.0), bb * Vector2(-1.0, 1.0) + Vector2(0.0, -dd)], [bb * Vector2(-1.0, 1.0), bb * Vector2(-1.0, 1.0) + Vector2(dd, 0.0)],
			[bb * Vector2(-1.0, -1.0), bb * Vector2(-1.0, -1.0) + Vector2(0.0, dd)], [bb * Vector2(-1.0, -1.0), bb * Vector2(-1.0, -1.0) + Vector2(dd, 0.0)],
			[bb * Vector2(1.0, -1.0), bb * Vector2(1.0, -1.0) + Vector2(0.0, dd)], [bb * Vector2(1.0, -1.0), bb * Vector2(1.0, -1.0) + Vector2(-dd, 0.0)]
			
		]
		
		var line_offset : Vector2 = to_local(nearby_poi["location"])
		
		for line : Array in lines:
			draw_line(line[0] + line_offset + drift, line[1] + line_offset+ drift, NEARBY_COLOR, -2.0, false)
			
	prev_cam_pos = position
