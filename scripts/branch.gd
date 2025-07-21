class_name Branch

var username : String = "Unknown"
var user_id : String = "Unknown"
var angle : float = 0
var distance : float = 0
var curve_radius : float = 0
var cw : bool = false
var id : int = -1
var parent_id : int = 0
var children : int = 0
var max_children : int = 1


func get_end_pos(previous_angle : float) -> Vector2:
	return Vector2.LEFT.rotated(angle + previous_angle) * distance
	#Vector2(cos(angle + previous_angle), sin(angle + previous_angle)) * distance

func deconstruct() -> Array:
	return [user_id, username, angle, distance, curve_radius, cw, id, parent_id, children, max_children]

func construct(data : Array):
	user_id = data[0]
	username = data[1]
	angle = data[2]
	distance = data[3]
	curve_radius = data[4]
	cw = data[5]
	id = data[6]
	parent_id = data[7]
	children = data[8]
	max_children = data[9]

func _to_string() -> String:
	return str(deconstruct())
