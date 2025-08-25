extends Camera2D

const SIMPLIFY_THICKNESS = 3
const DRAW_DIST : float = 0.3
const SHAKE_INTENSITY : float = 1.0
const GLITCH_CHANCE : int = 1

const UI_COLOR : Color = Color(1.0, 1.0, 1.0, 1.0)
const NEARBY_COLOR : Color = Color(1.0, 0.7, 1.0, 0.2)

const TEXT_OFFSET = Vector2(-2.0, -15.0)
const SMALL_TEXT_SIZE = 10.0
const FULL_TEXT_SIZE = 15.0

const FONT = preload("res://art/Fonts/CodeSaver-Regular.otf")

@export var stars_viewer : Node2D
@export var canvas2: Node2D
@export var ping_anims: AnimationPlayer

var POI : Dictionary = {}
	#"id" : id,
	#"location" : Vector2,
	#"zoom_range" : Array, [numerical lower, numerical higher]
	#"bounding_box" : Vector2,
	#"type" : String,
	#"name" : String,
	#"status" : String,
	#"description" : String,
	#"draw_name" : bool
	#"drawing_name" : bool
	#"extra_info" : Array[Array[String]] [["title1", value1 (variant)], "title2", value2 (variant)]]
	#"dupe_verify": int


var prev_poi_id : int = 0
var nearby_POIs : Array[Dictionary] = []

var delay_timer : float = 0.0
var frame_draw_pass : bool = false

# confirm and draw nearby
const CONFIRM_DELAY : float = 1.0
const CONFIRM_SPEED : float = 1.4

var has_poi : bool:
	get():
		return POI != {}

var prev_had_poi : bool = false

var has_nearby_pois : bool:
	get():
		return nearby_POIs.size() > 0

var confirm_amount : float = 0.0
var counter : int = 0
var prev_cam_pos : Vector2 = Vector2.ZERO
var confirmed_POI : Dictionary

# connect line animation
const CONNECT_LINE_SPEED = 0.3

const PING_SPEED = 0.5
const PING_MAX_DIST = 500


const PING_MAX_LEN = 250

var ping_max_dist : float = PING_MAX_DIST
var ping_max_len : float = PING_MAX_LEN

var ping_completion : float = 1.0
var ping_reversed : bool = false
var ping_pos : Vector2 = Vector2.ZERO

var connect_lines : Dictionary[int, Array]
var connected_lines_lookup : Dictionary[Array, Array] = {}
var connect_points : Dictionary[Array, Vector2] = {}

# info
var info_label : Label
var info_base_point : Vector2
var info_line_end : Vector2 = Vector2.ZERO


func _ready() -> void:
	info_label = stars_viewer.info_label

func send_ping(reversed : bool, play_anim : bool = true):
	ping_pos = position
	ping_reversed = reversed
	ping_completion = 1.0 if reversed else 0.0
	if is_instance_valid(Global.crosshair) : Global.crosshair.flash(0.4)
	if has_poi:
		confirm_amount = 1.0
		delay_timer = CONFIRM_DELAY + Global.EPSILON
	
	if play_anim:
		ping_anims.stop(true)
		ping_anims.play("ping")
	for set_POI : Dictionary in Global.POIs:
		set_POI["drawing_name"] = false

func create_connect_line(start : Vector2, end : Vector2, opacity : float, speed_mult : float = 1.0) -> int:
	var id : int = randi() # this doesnt need to succeed in making a unique one every time, so id rather not waste memory
	_connect_line(id, start, end, opacity, speed_mult)
	return id

func _connect_line(id : int, start : Vector2, end : Vector2, opacity : float, speed_mult : float = 1.0):
	var start_tween : Tween = create_tween()
	var end_tween : Tween = create_tween()
	connect_lines[id] = [start, start, opacity, [start, end], [start, end]]
	start_tween.tween_method(func(v): connect_lines[id][0] = v, connect_lines[id][0], end, CONNECT_LINE_SPEED * speed_mult).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	end_tween.tween_method(func(v): connect_lines[id][1] = v, connect_lines[id][1], end, CONNECT_LINE_SPEED * speed_mult).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_delay(CONNECT_LINE_SPEED * speed_mult * 0.3)
	#start_tween.tween_property(self, "connect_lines:id:0", end, CONNECT_LINE_SPEED * speed_mult).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	#end_tween.tween_property(self, "connect_lines:id:1", end, CONNECT_LINE_SPEED * speed_mult).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_delay(CONNECT_LINE_SPEED * speed_mult * 0.4)
	
	await end_tween.finished
	connect_lines.erase(id)
	for key : Array in connected_lines_lookup:
		if connected_lines_lookup[key][0] == id:
			connected_lines_lookup.erase(key)
	
	#end_tween.free()
	#start_tween.free()

func update_connect_line(id : int, new_pos : Vector2, is_start : bool = false):
	if connect_lines.has(id):
		connect_lines[id][4][0 if is_start else 1] = new_pos

func _process(delta: float) -> void:
	var result : Array = Global.get_nearby_POIs(global_position, stars_viewer.zoom)
	POI = result[0]
	nearby_POIs = result[1]
	
	ping_max_dist = (1 / zoom.x) * PING_MAX_DIST
	ping_max_len = (1 / zoom.x) * PING_MAX_LEN
	
	#scale_canvas.scale = Vector2.ONE * (1.0 / zoom.x)
	
	counter += 1
	if counter >= 10:
		counter = 0
		queue_redraw()
	canvas2.queue_redraw()
		#frame_draw_pass = true
	#else: 
		#frame_draw_pass = false
	
	if has_poi != prev_had_poi:
		if has_poi:
			Global.crosshair.switch_anim("focus")
		else:
			Global.crosshair.switch_anim("idle")
	prev_had_poi = has_poi
	
	if has_poi:
		if confirmed_POI != {} and confirmed_POI["dynamic"]:
			info_label.display_POI_data(confirmed_POI, true)
			
		
		
		if not (Input.is_action_pressed("up") or Input.is_action_pressed("down") or Input.is_action_pressed("left") or Input.is_action_pressed("right") or Input.is_action_pressed("scope_zoom_in") or Input.is_action_pressed("scope_zoom_out")):
			global_position = lerp(global_position, POI["location"], delta * 0.8 if not POI["dynamic"] else delta * 2.0)
		
		if POI["id"] != prev_poi_id:
			reset_confirm_progress()
		else:
			delay_timer += delta
			if delay_timer > CONFIRM_DELAY:
				confirm_amount = clamp(lerp(confirm_amount, 1.0, delta * CONFIRM_SPEED) + CONFIRM_SPEED / 60.0 * delta, 0.1, 1.0)
				
				
				if confirm_amount >= 1.0 - Global.EPSILON:
					var prev = confirmed_POI
					confirmed_POI = POI
					if prev != confirmed_POI:
						play_confirm_anim()
				elif not POI["dynamic"]:
					confirm_amount = clamp(confirm_amount - abs(position.length() - prev_cam_pos.length()) / 300.0, 0.0, 1.0)
		
		
		prev_poi_id = POI["id"]
	else:
		reset_confirm_progress()
	
	if ping_reversed:
		pass
	elif ping_completion < 1.0:
		#print("b")
		var prev_completion : float = ping_completion
		ping_completion = clamp(ping_completion + PING_SPEED * delta, 0.0, 1.0)
		for key : Array in connect_points.keys():
			#print("c")
			var dist : float = connect_points[key].distance_to(ping_pos)
			#prints(dist, prev_completion * PING_MAX_DIST, ping_completion * PING_MAX_DIST)
			if Util.between(dist, prev_completion * ping_max_dist, ping_completion * ping_max_dist):
				var targ : Vector2
				var min_dist : float = INF
				var selected_id : int
				#print("d")
				for sub_key : Array in connect_points.keys():
					#print("e")
					var sub_dist : float = connect_points[key].distance_to(connect_points[sub_key])
					if sub_dist < min_dist and connect_points[sub_key].distance_to(ping_pos) > dist and key[0] != sub_key[0]:
						#print("f")
						min_dist = sub_dist
						targ = connect_points[sub_key]
						selected_id = sub_key[0]
				
				if min_dist < ping_max_len:
					var line_id : int = create_connect_line(connect_points[key], targ, 0.2, 0.5 + ping_completion * 0.5)
					connected_lines_lookup[[key[0], connect_points[key]]] = [line_id, true]
					connected_lines_lookup[[selected_id, targ]] = [line_id, false]
					Util.search(nearby_POIs, "id", key[0], false, {"drawing_name" : true})["drawing_name"] = true
					Util.search(nearby_POIs, "id", selected_id, false, {"drawing_name" : true})["drawing_name"] = true


func play_confirm_anim():
	if not Global.simplify_constellations:
		create_connect_line(to_global(info_base_point), to_global(info_base_point) + Vector2(1000, 700.0) * (1.0 / stars_viewer.zoom), 0.3, 1.0)
		info_label.display_POI_data(confirmed_POI)
	else:
		Global.constellation_manager.preview_info.text = "NAME: " + confirmed_POI["name"].to_upper() + "\nOWNER: " + confirmed_POI["owner"].to_upper()
		Global.constellation_manager.preview_animations.play("info_in")
	
	$Confirm.play()
	Global.crosshair.switch_anim("select")
	print("confirm!")
	
	#info_label.line_offset
	#info_line_end = info_base_point
	#var tween : Tween = create_tween()
	#tween.tween_property(self, "info_line_end", info_label.line_offset, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	


func reset_confirm_progress():
	if confirmed_POI != {}:
		Global.crosshair.switch_anim("idle", 0.5)
		Global.constellation_manager.preview_animations.play("info_out")
	confirm_amount = 0.0
	delay_timer = 0.0
	confirmed_POI = {}
	info_label.hide_node()
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("call"):
		$Call.play(1.1)
		send_ping(false)
			
			

func _draw() -> void:
	connect_points = {}
	info_base_point = Vector2.ZERO
	for nearby_poi in nearby_POIs:
		var drift : Vector2 = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * SHAKE_INTENSITY * abs(position.length() - prev_cam_pos.length())
		if randi_range(1, 100) <= GLITCH_CHANCE: drift += Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * 100.0 * (1.0 / zoom.x)
		var bb : Vector2 = nearby_poi["bounding_box"] / 2.0
		var dd : float = DRAW_DIST * min(bb.x, bb.y) / 2.0
		var lines : Array[Array] = [ 
			[bb, bb + Vector2(0.0, -dd)], [bb, bb + Vector2(-dd, 0.0)],
			[bb * Vector2(-1.0, 1.0), bb * Vector2(-1.0, 1.0) + Vector2(0.0, -dd)], [bb * Vector2(-1.0, 1.0), bb * Vector2(-1.0, 1.0) + Vector2(dd, 0.0)],
			[bb * Vector2(-1.0, -1.0), bb * Vector2(-1.0, -1.0) + Vector2(0.0, dd)], [bb * Vector2(-1.0, -1.0), bb * Vector2(-1.0, -1.0) + Vector2(dd, 0.0)],
			[bb * Vector2(1.0, -1.0), bb * Vector2(1.0, -1.0) + Vector2(0.0, dd)], [bb * Vector2(1.0, -1.0), bb * Vector2(1.0, -1.0) + Vector2(-dd, 0.0)]
			
		]
		
		var line_offset : Vector2 = to_local(nearby_poi["location"])
		
		if not Global.simplify_constellations:
			var name_text : String = nearby_poi["name"] + " " + str(clamp(snappedf(99.9 - drift.length() * pow(1.0 / zoom.x, 0.25) * 0.2, 0.1), 11.3, 99.9)) + "%"
			if nearby_poi["draw_name"]:
				draw_string_outline(FONT,  bb * Vector2(-1, -1) + pow(1 / zoom.x, 0.75) * TEXT_OFFSET + line_offset + drift, name_text, HORIZONTAL_ALIGNMENT_LEFT, -1, 1 / zoom.x * FULL_TEXT_SIZE, 30, Color.BLACK)
				draw_string(FONT, bb * Vector2(-1, -1) + pow(1 / zoom.x, 0.75) * TEXT_OFFSET + line_offset + drift, name_text, HORIZONTAL_ALIGNMENT_LEFT, -1, 1 / zoom.x * FULL_TEXT_SIZE, NEARBY_COLOR)
			elif nearby_poi["drawing_name"]:
				draw_string_outline(FONT,  bb * Vector2(-1, -1) + pow(1 / zoom.x, 0.75) * TEXT_OFFSET + line_offset + drift, name_text, HORIZONTAL_ALIGNMENT_LEFT, -1, max(1 / zoom.x * SMALL_TEXT_SIZE, 7.0), 15, Color.BLACK)
				draw_string(FONT, bb * Vector2(-1, -1) + pow(1 / zoom.x, 0.75) * TEXT_OFFSET + line_offset + drift, name_text, HORIZONTAL_ALIGNMENT_LEFT, -1, max(1 / zoom.x * SMALL_TEXT_SIZE, 7.0), NEARBY_COLOR)
		
		var prev_line_pos : Vector2
		for line : Array in lines:
			if line[0] != prev_line_pos:
				var pos : Vector2 = line[0] + nearby_poi["location"] + drift
				var key : Array = [nearby_poi["id"], pos]
				if connected_lines_lookup.has(key):
					update_connect_line(connected_lines_lookup[key][0], pos, connected_lines_lookup[key][1])
				
				connect_points[[nearby_poi["id"], randi()]] = pos
			
			
			prev_line_pos = line[0]
			draw_line(line[0] + line_offset + drift, line[1] + line_offset + drift, NEARBY_COLOR, -2.0 if not Global.simplify_constellations else SIMPLIFY_THICKNESS, false)
	
	if has_poi:
		var drift : Vector2 = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * SHAKE_INTENSITY * abs(position.length() - prev_cam_pos.length())
		
		#if randi_range(1, 100) <= GLITCH_CHANCE: drift += Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * 1000.0
		var bb : Vector2 = POI["bounding_box"] / 2.0
		var dd : float = DRAW_DIST * min(bb.x, bb.y)
		var lines : Array[Array] = [ 
			[bb, bb + Vector2(0.0, -dd)], [bb, bb + Vector2(-dd, 0.0)],
			[bb * Vector2(-1.0, 1.0), bb * Vector2(-1.0, 1.0) + Vector2(0.0, -dd)], [bb * Vector2(-1.0, 1.0), bb * Vector2(-1.0, 1.0) + Vector2(dd, 0.0)],
			[bb * Vector2(-1.0, -1.0), bb * Vector2(-1.0, -1.0) + Vector2(0.0, dd)], [bb * Vector2(-1.0, -1.0), bb * Vector2(-1.0, -1.0) + Vector2(dd, 0.0)],
			[bb * Vector2(1.0, -1.0), bb * Vector2(1.0, -1.0) + Vector2(0.0, dd)], [bb * Vector2(1.0, -1.0), bb * Vector2(1.0, -1.0) + Vector2(-dd, 0.0)]
			
		]
		
		var line_offset : Vector2 = to_local(POI["location"])
		
		if confirmed_POI != {}:
			var effect : float = (sin(Util.TIME) + 1.0) * 0.025 + (sin(Util.TIME) + 1.0) * 0.02 * stars_viewer.zoom + 1 + 0.5 * stars_viewer.zoom
			for line : Array in lines:
				draw_line(line[0] * effect + line_offset + drift, line[1] * effect + line_offset + drift, UI_COLOR, -2.0 if not Global.simplify_constellations else SIMPLIFY_THICKNESS, false)
		
		if confirm_amount > Global.FINE_EPSILON:
			lines.append_array([
				# this took so much brainwpoer to write
				[bb, bb * Vector2(1.0, 1.0-confirm_amount)], [bb, bb * Vector2(1.0-confirm_amount, 1.0)],
				[bb * Vector2(-1.0, 1.0), bb * Vector2(-1.0, 1.0-confirm_amount)], [bb * Vector2(-1.0, 1.0), bb * Vector2(-1.0+confirm_amount, 1.0)],
				[bb * Vector2(-1.0, -1.0), bb * Vector2(-1.0, -1.0+confirm_amount)], [bb * Vector2(-1.0, -1.0), bb * Vector2(-1.0+confirm_amount, -1.0)],
				[bb * Vector2(1.0, -1.0), bb * Vector2(1.0, -1.0+confirm_amount)], [bb * Vector2(1.0, -1.0), bb * Vector2(1.0-confirm_amount, -1.0)]
			])
		
		
		
		info_base_point = bb * Vector2(1.0, -1.0) + line_offset + drift
		if not Global.simplify_constellations:
			var name_text : String = POI["name"] + " " + str(clamp(snappedf(100.0 - drift.length() * pow(1.0 / zoom.x, 0.25) * 0.2, 0.1), 11.3, 100.0)) + "%"
			draw_string_outline(FONT, bb * Vector2(-1, -1) + pow(1 / zoom.x, 0.75) * TEXT_OFFSET + line_offset + drift, name_text, HORIZONTAL_ALIGNMENT_LEFT, -1, max(1 / zoom.x * FULL_TEXT_SIZE, 11.0), 30, Color.BLACK)
			draw_string(FONT, bb * Vector2(-1, -1) + pow(1 / zoom.x, 0.75) * TEXT_OFFSET + line_offset + drift, name_text, HORIZONTAL_ALIGNMENT_LEFT, -1, max(1 / zoom.x * FULL_TEXT_SIZE, 11.0), UI_COLOR)
	
		
		for line : Array in lines:
			draw_line(line[0] + line_offset + drift, line[1] + line_offset + drift, UI_COLOR, -2.0 if not Global.simplify_constellations else SIMPLIFY_THICKNESS, false)
		
		
	
	
		
	
	
	prev_cam_pos = position

func canvas2_draw():
	for connect_line : int in connect_lines.keys():
		var start_offset : Vector2 = connect_lines[connect_line][4][0] - connect_lines[connect_line][3][0]
		var end_offest : Vector2 = connect_lines[connect_line][4][1] - connect_lines[connect_line][3][1]
		canvas2.draw_line(to_local(connect_lines[connect_line][0]) + start_offset, to_local(connect_lines[connect_line][1]) + end_offest, Color(UI_COLOR, connect_lines[connect_line][2]), -1, false)
	
	canvas2.draw_circle(to_local(ping_pos), ping_completion * ping_max_len * 2.0, Color(UI_COLOR, 0.5-ping_completion * 0.5), false, -1)
	
	#if confirmed_POI != {} and info_base_point != Vector2.ZERO:
		#canvas2.draw_line(info_base_point, info_label.line_offset + position * (1.0 / zoom.x), UI_COLOR)
