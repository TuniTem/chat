extends Node2D


#select
const SELECT_DIST : int = 50
const MAX_SELECT_RADIUS : int = 20
const SELECT_SHOW_SPEED : float = 10.0
const USERNAME_TEXT_PREFIX : String = "[pulse freq=1.25 color=#808080 ease=-2.0]"

@onready var label_node: Node2D = $Label
@onready var rich_text_label: RichTextLabel = $Label/RichTextLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var select_radius = 0.0
var last_selected_star : Star
var mouse_position : Vector2:
	get():
		return get_global_mouse_position() - get_viewport().size * 0.5




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
 
var dragging : bool = false
var zoom : float = 1.0
var zoom_pos_offset : Vector2 = Vector2.ZERO
var zoom_pos_offset_targ : Vector2 = Vector2.ZERO
var camera_position : Vector2 = Vector2.ZERO

# background
#@onready var bg_star_holder: Control = $Camera2D/BGStarHolder


func _ready() -> void:
	camera_position = camera.position
	queue_redraw()

func _process(delta: float) -> void:
	camera.zoom = Vector2.ONE * lerpf(camera.zoom.x, zoom, delta * ZOOM_WEIGHT)
	#bg_star_holder.scale = Vector2.ONE / camera.zoom
	zoom_pos_offset = zoom_pos_offset.lerp(zoom_pos_offset_targ, delta * ZOOM_WEIGHT)
	#zoom_pos_offset = zoom_pos_offset_targ
	camera.position = camera_position + zoom_pos_offset
	
	if select_radius < MAX_SELECT_RADIUS - Global.EPSILON:
		select_radius = lerpf(select_radius, MAX_SELECT_RADIUS, delta * SELECT_SHOW_SPEED)
	#print(get_global_mouse_position())
	queue_redraw()

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
		draw_line(star.position[0] + constellation_origin, star.position[1] + constellation_origin, COLOR * Color(1.0, 1.0, 1.0, 0.06 + 0.5 * (1.0 - progress)), draw_scale)
		
		
	
	
	
	if min_dist < SELECT_DIST:
		if last_selected_star != min_dist_star: 
			select_radius = 0.0
			label_node.hide()
			animation_player.stop()
			animation_player.play("ShowLabel")
			label_node.position = min_dist_star.position[1] + min_dist_star.parent_constellation.origin_position
			rich_text_label.text = USERNAME_TEXT_PREFIX + min_dist_star.username
			
			
		draw_circle(min_dist_star.position[1] + min_dist_star.parent_constellation.origin_position, select_radius, COLOR * Color(1.0, 1.0, 1.0, 0.3), false, draw_scale)
	
		last_selected_star = min_dist_star
	else:
		var temp = last_selected_star
		last_selected_star = null
		if last_selected_star != temp: 
			animation_player.play("HideLabel", 0.5)
	
	
	for star : Star in Global.get_stars():
		var constellation_origin : Vector2 = star.parent_constellation.origin_position
		draw_texture_rect(star_texures[star.color], Rect2(star.position[1] + constellation_origin - Vector2.ONE * texture_scale / 2.0, Vector2.ONE * texture_scale), false)
	
	if Global.debug_draw_pos:
		draw_circle(Global.debug_draw_pos, 16.0, Color.RED, false, 4.0)
	

func _input(event: InputEvent) -> void:
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
