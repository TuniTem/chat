extends Node2D
const MAX_POINT_COUNT : int = 64
const COLOR : Color = Color(1.0, 1.0, 1.0, 1.0)
const CIRCLE_MULT : float = 1.0
const PANGOLIN_REGULAR = preload("res://Pangolin-Regular.ttf")
@onready var camera: Camera2D = $Camera2D

var draw_scale : float = 4.0
var dragging : bool = false
const ZOOM_CLAMP : Array[float] = [1/40.0, 40.0]
const ZOOM_MULT : float = 1.1
const ZOOM_WEIGHT : float = 5.0
var zoom : float = 1.0

var tree : Array[Branch] = []

func _ready() -> void:
	tree = Global.tree.duplicate()
	tree.sort_custom(func sort_id(a, b): return a.id < b.id)
	queue_redraw()

func _process(delta: float) -> void:
	camera.zoom = Vector2.ONE * lerpf(camera.zoom.x, zoom, delta * ZOOM_WEIGHT)

func _draw() -> void:
	for branch: Branch in tree:
		var start_pos = Global.ends[branch.parent_id][0]
		var parent_angle = Global.ends[branch.parent_id][1]
		var abs_angle = wrapf(branch.angle + parent_angle, 0.0, TAU)
		var end_pos = Vector2.RIGHT.rotated(abs_angle) * branch.distance + start_pos
		var mid_point : Vector2 = (end_pos + start_pos) * 0.5
		var circle_center : Vector2 = mid_point.direction_to(end_pos).rotated(PI / 2.0 if branch.cw else -PI / 2.0) * branch.curve_radius + mid_point
		var clr = Color(randf()/10.0, randf()/10.0, randf()/10.0)
		draw_dashed_line(start_pos, end_pos, Color(0.1, 0.1, 0.1), draw_scale/2.0, 10.0)
		#draw_line(start_pos, end_pos, COLOR * Color(0.1, 0.1, 0.1), draw_scale, true)
		
		var angle_start = circle_center.angle_to_point(start_pos)
		var angle_end = angle_start + angle_difference(angle_start, circle_center.angle_to_point(end_pos))
		
		#prints(arc_angle,arc_angle + angle_difference(arc_angle, circle_center.angle_to_point(end_pos)))
		
		draw_arc(
			circle_center, 
			(circle_center).distance_to(start_pos), 
			angle_start,
			angle_end,
			MAX_POINT_COUNT,
			COLOR,
			draw_scale,
			true
		)
		draw_arc(
			circle_center, 
			(circle_center).distance_to(start_pos), 
			angle_start,
			angle_start + TAU,
			MAX_POINT_COUNT,
			Color(clr, 0.03),
			draw_scale/2.0,
			true
		)
		
		draw_circle(end_pos, draw_scale, COLOR, true, -1.0, true)
		draw_circle(circle_center, draw_scale * CIRCLE_MULT, clr, true, -1.0, true)
		#draw_string(PANGOLIN_REGULAR, end_pos + Vector2(0.0, 30.0), str(branch.id), 0, -1, 16, clr)
		#draw_string(PANGOLIN_REGULAR, start_pos - Vector2(0.0, 30.0), str(branch.id), 0, -1, 16, clr)
		draw_circle(mid_point, draw_scale* 1.25, COLOR * Color(1.0, 1.0, 0.0), true, -1.0, true)
		#draw_string(PANGOLIN_REGULAR, circle_center - Vector2(0.0, 30.0), str(branch.id), 0, -1, 16, Color.FOREST_GREEN)
		#count += 1
		#if count >= 10:
			#break
		

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("drag"):
		dragging = true
	if event.is_action_released("drag"):
		dragging = false
		
	if dragging and event is InputEventMouseMotion:
		camera.position -= event.relative / zoom
	
	if event.is_action_pressed("zoom_in"):
		zoom = clampf(zoom / ZOOM_MULT, ZOOM_CLAMP[0], ZOOM_CLAMP[1])
	
	if event.is_action_pressed("zoom_out"):
		zoom = clampf(zoom * ZOOM_MULT, ZOOM_CLAMP[0], ZOOM_CLAMP[1])
