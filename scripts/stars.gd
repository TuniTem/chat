extends Node2D
# scope move
const SCOPE_INTERVALS : Array[Array] = [[4.2, 2.0], [2.2, 1.1], [1.0, 0.5], [0.47, 0.3], [0.25, 0.15], [0.135, 0.0863]]

const SCOPE_ZOOM_SPEED : float = 0.4
const SCOPE_SPEED = 5.0
const MOVE_ACCEL = 10.0
const VELOCITY_DAMP = 3.0
const MOVE_CLICK_RADIUS = 100.0
const ZOOM_CLICK_DISTANCE = 1.07
const SCOPE_TRAIL_MULT = 3.0
const PRECISION_SPEED_MULTIPLIER = 3.5

const ZOOM_SCALER_RANGE = [0.25, 0.5528]
const ZOOM_SCALER_RANGE2 = [0.04, 0.35]

@export var animations : AnimationPlayer
@export var move_click : AudioStreamPlayer
@export var zoom_click : AudioStreamPlayer
@export var scope : Sprite2D
@export var zoom_scale : Sprite2D
@export var zoom_scale2 : Sprite2D
@export var zoom_scale3 : Sprite2D
@export var zoom_label : Label
@export var location_label : Label


var using_scope_move : bool = true
var can_scope : bool = true
var current_scope_interval : int = 3
var prev_click_pos : Vector2 = Vector2.ZERO
var prev_click_zoom : float = 0.0

var velocity : Vector2 = Vector2.ZERO


# select
const SELECT_DIST : int = 50
const MAX_SELECT_RADIUS : int = 20
const SELECT_SHOW_SPEED : float = 10.0
const USERNAME_TEXT_PREFIX : String = "[pulse freq=1.25 color=#808080 ease=-2.0]"

@onready var label_node: Node2D = $Label
@onready var rich_text_label: RichTextLabel = $Label/RichTextLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var info_label : Label

var select_radius = 0.0
var last_selected_star : Star
var mouse_position : Vector2:
	get():
		return get_global_mouse_position() #- get_viewport().size * 0.5



const MAX_POINT_COUNT : int = 64
const COLOR : Color = Color(1.0, 1.0, 1.0, 1.0)
const CIRCLE_MULT : float = 1.0
const PANGOLIN_REGULAR = preload("res://Pangolin-Regular.ttf")



@onready var camera: Camera2D = $Camera2D


@onready var star_texures : Dictionary[Star.Colors, Texture2D] = {
	Star.Colors.PURPLE: preload("res://art/NewStars/Soft Outline/SoftOutline1001.png"),
	Star.Colors.PINK: preload("res://art/NewStars/Soft Outline/SoftOutline1000.png"),
	Star.Colors.YELLOW: preload("res://art/NewStars/Soft Outline/SoftOutline1002.png"),
	Star.Colors.WHITE: preload("res://art/NewStars/Soft Outline/SoftOutline1003.png")
}

# drawing
const CONSTELLATION_VIGNETTE_INNER : float = 500.0
const CONSTELLATION_VIGNETTE_FALLOFF : float = 500.0


var draw_scale : float = 3.0
var texture_scale : float = 48.0

# camera
const ZOOM_CLAMP : Array[float] = [1/40.0, 40.0]
const ZOOM_MULT : float = 1.1
const ZOOM_WEIGHT : float = 10.0

@export var twinkle : GPUParticles2D
 
var dragging : bool = false
var zoom : float = 0.35
var zoom_pos_offset : Vector2 = Vector2.ZERO
var zoom_pos_offset_targ : Vector2 = Vector2.ZERO
var camera_position : Vector2 = Vector2.ZERO


# background
const FLOATY_GUY = preload("res://scenes/floaty_guy.tscn")
const FLOATY_GUY_CHANCE = 1 # percent every 10 seconds
const FLOATY_GUY_BUFFER = 400

#@onready var bg_star_holder: Control = $Camera2D/BGStarHolder

# Shaders
@export var warp_shader : ColorRect


func _ready() -> void:
	camera_position = camera.position
	queue_redraw()

func _process(delta: float) -> void:
	if using_scope_move:
		var dir : Vector2 = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"), Input.get_action_strength("down") - Input.get_action_strength("up"))
		var presition_mult : float = (1.0/PRECISION_SPEED_MULTIPLIER if Input.is_action_pressed("scope_slow") else (PRECISION_SPEED_MULTIPLIER if Input.is_action_pressed("scope_fast") else 1.0))
		var vel_mult : float = (1.0/zoom) * presition_mult 
		if abs(dir.x) < Global.EPSILON or velocity.x < -SCOPE_SPEED * vel_mult or velocity.x > SCOPE_SPEED * vel_mult:
			velocity.x = lerpf(velocity.x, 0.0, delta * VELOCITY_DAMP)
			if abs(velocity.x) < Global.FINE_EPSILON: velocity.x = 0.0
		else:
			velocity.x = clamp(velocity.x + dir.x * MOVE_ACCEL * delta * vel_mult, -SCOPE_SPEED * vel_mult, SCOPE_SPEED * vel_mult)
		
		if abs(dir.y) < Global.EPSILON or velocity.y < -SCOPE_SPEED * vel_mult or velocity.y > SCOPE_SPEED * vel_mult:
			velocity.y = lerpf(velocity.y, 0.0, delta * VELOCITY_DAMP)
			if abs(velocity.y) < Global.FINE_EPSILON: velocity.y = 0.0
		else:
			velocity.y = clamp(velocity.y + dir.y * MOVE_ACCEL * delta * vel_mult, -SCOPE_SPEED * vel_mult, SCOPE_SPEED * vel_mult)
		
		
		camera.position += velocity
		location_label.text = "Viewfinder\nLat: " + str(snapped(camera.position.y * Global.LOCATION_MULTIPLIER, 0.0001)) + "\nLgt: " + str(snapped(camera.position.x * Global.LOCATION_MULTIPLIER, 0.0001))
		
		var scope_dir : float = Input.get_action_strength("scope_zoom_in") - Input.get_action_strength("scope_zoom_out")
		if abs(scope_dir) > Global.EPSILON and can_scope:
			zoom = clamp(zoom * ((1.0 + SCOPE_ZOOM_SPEED * delta * presition_mult) if scope_dir > 0 else (1.0/(1.0 + SCOPE_ZOOM_SPEED * delta * presition_mult))), SCOPE_INTERVALS[current_scope_interval][1], SCOPE_INTERVALS[current_scope_interval][0])
			if Input.is_action_pressed("alt"):
				if abs(zoom - SCOPE_INTERVALS[current_scope_interval][0]) < Global.FINE_EPSILON:
					attempt_switch_scope(false)
				elif abs(zoom - SCOPE_INTERVALS[current_scope_interval][1]) < Global.FINE_EPSILON:
					attempt_switch_scope(true)
		
		zoom_label.text = str(int(round(499 - pow(1.0/zoom, 0.25) * 200.0))) + "x\nMag"
		
		if abs(prev_click_pos.x - camera.position.x) > MOVE_CLICK_RADIUS * (1.0/zoom) or abs(prev_click_pos.y - camera.position.y) > MOVE_CLICK_RADIUS * (1.0/zoom):
			move_click.play()
			prev_click_pos = camera.position
		
		if (zoom > prev_click_zoom * ZOOM_CLICK_DISTANCE or zoom < prev_click_zoom * (1.0 / ZOOM_CLICK_DISTANCE)):
			zoom_click.play()
			prev_click_zoom = camera.zoom.x
			
		scope.position = -velocity * SCOPE_TRAIL_MULT * zoom
		zoom_scale.position = -velocity * SCOPE_TRAIL_MULT * zoom * 0.4
		zoom_scale.scale = Vector2.ONE * remap(pow(zoom, 0.125), pow(SCOPE_INTERVALS[-1][1], 0.125), pow(SCOPE_INTERVALS[0][0], 0.25), ZOOM_SCALER_RANGE[1], ZOOM_SCALER_RANGE[0])
		zoom_scale2.position = -velocity * SCOPE_TRAIL_MULT * zoom * 2.0
		zoom_scale2.scale = Vector2.ONE * remap(pow(zoom, 0.125), pow(SCOPE_INTERVALS[-1][1], 0.125), pow(SCOPE_INTERVALS[0][0], 0.25), ZOOM_SCALER_RANGE2[1], ZOOM_SCALER_RANGE2[0])
		zoom_scale2.rotation = remap(pow(zoom, 0.125), pow(SCOPE_INTERVALS[-1][1], 0.125), pow(SCOPE_INTERVALS[0][0], 0.25), PI - 0.14, 0.1) + PI
		zoom_scale3.position = zoom_scale2.position
		zoom_scale3.scale = zoom_scale2.scale *1.4
		
		warp_shader.scale = Vector2.ONE * (1.0 / zoom) 
		
	else:
		zoom_pos_offset = zoom_pos_offset.lerp(zoom_pos_offset_targ, delta * ZOOM_WEIGHT)
		camera.position = camera_position + zoom_pos_offset
		
	camera.zoom = Vector2.ONE * lerpf(camera.zoom.x, zoom, delta * ZOOM_WEIGHT)
	
	twinkle.position = -camera.position / 1.2
	#twinkle.scale = Vector2.ONE * 1.0/ pow(zoom, 0.25)
	var curve : Curve = twinkle.process_material.scale_curve.curve
	curve.set_point_value(1, 1.0/ pow(zoom, 0.25))
	
	if select_radius < MAX_SELECT_RADIUS - Global.EPSILON:
		select_radius = lerpf(select_radius, MAX_SELECT_RADIUS, delta * SELECT_SHOW_SPEED)
	#print(get_global_mouse_position())
	queue_redraw()

func set_can_scope(on : bool): can_scope = on

func attempt_switch_scope(higher: bool, is_manual : bool = false):
	#prints(can_scope, current_scope_interval < SCOPE_INTERVALS.size() - 1, current_scope_interval > 1)
	if can_scope and ((current_scope_interval < SCOPE_INTERVALS.size() - 1 and higher) or (current_scope_interval > 1 and not higher)):
		can_scope = false
		var zoom_ammount : float
		if is_manual: 
			zoom_ammount = clamp(remap(zoom, SCOPE_INTERVALS[current_scope_interval][0], SCOPE_INTERVALS[current_scope_interval][1], 0.0, 1.0), 0.0, 1.0)
		
		animations.play("slide")
		
		if higher:
			current_scope_interval += 1
			if not is_manual: 
				print("waugh")
				await get_tree().create_timer(0.25).timeout
				zoom = SCOPE_INTERVALS[current_scope_interval][0]
				camera.zoom = Vector2.ONE * zoom
		
		else:
			current_scope_interval -= 1
			if not is_manual: 
				await get_tree().create_timer(0.25).timeout
				zoom = SCOPE_INTERVALS[current_scope_interval][1]
				camera.zoom = Vector2.ONE * zoom
		
		
		
		if is_manual:
			await get_tree().create_timer(0.25).timeout
			zoom = remap(zoom_ammount, 0.0, 1.0, SCOPE_INTERVALS[current_scope_interval][0], SCOPE_INTERVALS[current_scope_interval][1])
			camera.zoom = Vector2.ONE * zoom
			
func scope_zoom_coprocess(idx : int):
	await get_tree().create_timer(0.25).timeout
	zoom = SCOPE_INTERVALS[current_scope_interval][idx]
	camera.zoom = Vector2.ONE * zoom

func _draw() -> void:
	var min_dist_star : Star
	var min_dist : float = INF
	var constellation_distances : Dictionary[Constellation, float] = {}
	for constellation : Constellation in Global.constellations: constellation_distances[constellation] = INF
	
	for star : Star in Global.get_stars():
		var dist = (star.position[1] + star.parent_constellation.origin_position).distance_to(mouse_position)
		if dist < min_dist:
			min_dist = dist
			min_dist_star = star
		
		var const_dist = (star.position[1] + star.parent_constellation.origin_position).distance_to(camera.position)
		if const_dist < constellation_distances[star.parent_constellation]:
			constellation_distances[star.parent_constellation] = const_dist
		
		
		
		
	
	for star : Star in Global.get_stars():
		var constellation_origin : Vector2 = star.parent_constellation.origin_position
		var constellation_dist : float = constellation_distances[star.parent_constellation]
		#prints(star.position[0],constellation_origin)
		var progress : float = clamp((constellation_dist - CONSTELLATION_VIGNETTE_INNER) / CONSTELLATION_VIGNETTE_FALLOFF, 0.0, 1.0)
		#draw_dashed_line(star.position[0] + constellation_origin, star.position[1] + constellation_origin, COLOR * Color(1.0, 1.0, 1.0, progress), draw_scale, 20.0, true)
		draw_line(star.position[0] + constellation_origin, star.position[1] + constellation_origin, COLOR * Color(1.0, 1.0, 1.0, 0.2 + 0.4 * (1.0 - progress)), draw_scale)
		
		
	
	
	
	#if min_dist < SELECT_DIST:
		#if last_selected_star != min_dist_star: 
			#select_radius = 0.0
			#label_node.hide()
			#animation_player.stop()
			#animation_player.play("ShowLabel")
			#label_node.position = min_dist_star.position[1] + min_dist_star.parent_constellation.origin_position
			#rich_text_label.text = USERNAME_TEXT_PREFIX + min_dist_star.username
			#
			#
		#draw_circle(min_dist_star.position[1] + min_dist_star.parent_constellation.origin_position, select_radius, COLOR * Color(1.0, 1.0, 1.0, 0.3), false, draw_scale)
	#
		#last_selected_star = min_dist_star
	#else:
		#var temp = last_selected_star
		#last_selected_star = null
		#if last_selected_star != temp: 
			#animation_player.play("HideLabel", 0.5)
	
	
	for star : Star in Global.get_stars():
		var constellation_origin : Vector2 = star.parent_constellation.origin_position
		draw_texture_rect(star_texures[star.color], Rect2(star.position[1] + constellation_origin - Vector2.ONE * texture_scale / 2.0, Vector2.ONE * texture_scale), false)
	
	if Global.debug_draw_pos:
		draw_circle(Global.debug_draw_pos, 16.0, Color.RED, false, 4.0)
	

func _input(event: InputEvent) -> void:
	if not using_scope_move:
		if event.is_action_pressed("drag"):
			if Input.is_action_pressed("alt") and last_selected_star != null:
				last_selected_star
				print(last_selected_star)
				print("\n--- ", last_selected_star.username, " ---",
					"\nVERIFY: ", last_selected_star.parent_constellation.verify_star(last_selected_star.id),
					"\nangle: ", rad_to_deg(last_selected_star.angle), 
					"\ndistance: ", last_selected_star.distance, 
					"\nexcluded angles: ", last_selected_star.excluded_angles, 
					"\nid: ", last_selected_star.id, 
					"\nparent id: ", last_selected_star.parent_id, 
					"\nchildren: ", last_selected_star.children, 
					"\nmax children: ", last_selected_star.max_children, 
					"\nconstellation base: ", last_selected_star.is_constellation_base, 
					"\nlocal position: ", last_selected_star.position, 
					"\nglobal position: ", last_selected_star.global_position, 
					"\ncolor: ", Star.Colors.keys()[last_selected_star.color],
					"\n----"
				)
			else:
				dragging = true
			
				
		if event.is_action_released("drag"):
			dragging = false
		
		if dragging and event is InputEventMouseMotion:
			camera_position -= event.relative / zoom
		
		if event.is_action_pressed("zoom_in"):
			zoom = clampf(zoom / ZOOM_MULT, ZOOM_CLAMP[0], ZOOM_CLAMP[1])
			zoom_pos_offset_targ += (mouse_position - camera.position) * (1.0 - ZOOM_MULT)
		
		if event.is_action_pressed("zoom_out"):
			zoom = clampf(zoom * ZOOM_MULT, ZOOM_CLAMP[0], ZOOM_CLAMP[1])
			zoom_pos_offset_targ -= (mouse_position - camera.position) * (1.0 - ZOOM_MULT)
	else:
		if event.is_action_pressed("scope_in"):
			attempt_switch_scope(false, true)
		
		if event.is_action_pressed("scope_out"):
			attempt_switch_scope(true, true)
	
	#if event.is_action_pressed("scope_zoom_in"):


func _on_floaty_guy_timer_timeout() -> void:
	if randi_range(1, 100) <= 1:
		print("floaty guy")
		var inst = FLOATY_GUY.instantiate()
		var dir_vec : Vector2 = Vector2(randi_range(0,1) * 2 - 1, randi_range(0,1) * 2 - 1)
		inst.position = camera.position + ((DisplayServer.window_get_size() / 2.0 + Vector2.ONE * FLOATY_GUY_BUFFER) / zoom) * dir_vec + Vector2.from_angle(randf_range(0.0, TAU)) * FLOATY_GUY_BUFFER / 2.0
		
		inst.end_pos = camera.position + ((DisplayServer.window_get_size() / 2.0  + Vector2.ONE * FLOATY_GUY_BUFFER) / zoom) * -dir_vec + Vector2.from_angle(randf_range(0.0, TAU)) * FLOATY_GUY_BUFFER / 2.0
		
		add_child(inst)
