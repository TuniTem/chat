extends Node2D
const MAX_POINT_COUNT : int = 64
const COLOR : Color = Color(1.0, 1.0, 1.0, 1.0)
const CIRCLE_MULT : float = 2.0


var draw_scale : float = 4.0

var tree : Array[Branch] = []

func _ready() -> void:
	tree = Global.tree.duplicate()
	tree.sort_custom(func sort_id(a, b): return a.id < b.id)
	queue_redraw()

func _draw() -> void:
	var ends : Dictionary[int, Array] = {-1: [Vector2.ZERO, 0.0]}
	for branch: Branch in tree:
		var start_pos : Vector2 = ends[branch.parent_id][0]
		var end_pos : Vector2 = branch.get_end_pos(ends[branch.parent_id][1]) + start_pos
		var mid_point : Vector2 = (end_pos + start_pos) * 0.5
		var circle_center : Vector2 = mid_point.direction_to(end_pos).rotated(PI / 2.0 if branch.cw else -PI / 2.0) * branch.curve_radius
		
		ends[branch.id] = [end_pos, start_pos.angle_to_point(end_pos)]
		draw_arc(
			circle_center, circle_center.distance_to(start_pos), 
			circle_center.angle_to_point(start_pos),
			circle_center.angle_to_point(end_pos),
			MAX_POINT_COUNT,
			COLOR,
			draw_scale,
			true
		)
		draw_circle(end_pos, draw_scale * CIRCLE_MULT, COLOR, true, -1.0, true)
		draw_circle(start_pos, draw_scale * CIRCLE_MULT, COLOR * Color(1.0, 0.0, 0.0), true, -1.0, true)
		draw_circle(mid_point, draw_scale* 1.25, COLOR * Color(0.0, 1.0, 0.0), true, -1.0, true)
		
	
	
