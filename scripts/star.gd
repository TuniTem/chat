class_name Star

enum Colors {
	PURPLE,
	PINK,
	YELLOW,
	WHITE
}

const DIST_BUFFER = 100
const ANGLE_BUFFER = 10

const STAR_ZOOM_RANGE : Array[float] = [0.75, INF]
const SIZE : float = 72

var username : String = "Unknown"
var name : String = "":
	get():
		if name == "":
			return username + "'s Star"
		
		return name

var user_id : String = "Unknown"
var angle : float = 0:
	set(val):
		angle = val
		update_position()
		
var distance : float = 0:
	set(val):
		distance = val
		update_position()

var id : int = -1
var POI_id : int

var parent_id : int = 0:
	set(val):
		parent_id = val
		update_position()
		
var children : int = 0
var max_children : int = 1
var excluded_angles : Array[float] = []
var is_constellation_base : bool = false
var color : Colors = Colors.WHITE
var position : Array[Vector2] = [Vector2.ZERO, Vector2.ZERO]
var test_positions : Array[Vector2] = [Vector2.ZERO, Vector2.ZERO]
var global_position : Array[Vector2]:
	get():
		return [position[0] + parent_constellation.origin_position, position[1] + parent_constellation.origin_position]
var parent_constellation : Constellation
var draw_amount : float = 1.0

func add_to_POI():
	var status : String
	var time_alive : int = floor(Time.get_unix_time_from_system()) - Global.get_follower_data(user_id, "time")
	
	if time_alive < 604800: # < 1 week
		status = "newborn shimmer"
	elif time_alive < 2592000: # < 1 month
		status = "blooming glimmer"
	elif time_alive < 7776000: # < 3 months
		status = "mature dreamling"
	elif time_alive < 31536000: # < 1 year
		status = "elder fragment"
	elif time_alive < 94608000: # < 3 years
		status = "dreamweaver"
	else: # > 3 years
		status = "eversleep"
	
	POI_id = Global.add_POI(
		"Star",
		name,
		status + " " + ("(searching)" if children == 0 else ("(growing)" if children < max_children else "(dorment)")),
		username,
		{
			"newborn shimmer": "A new shimmer spotted in dreamspace",
			"blooming glimmer" : "A fresh glimmer, drifting through fragments",
			"mature dreamling" : "A star that's made a home here",
			"elder fragment" : "An ancient shard of light, shining between fragments",
			"dreamweaver" : "A luminous beacon that spins the fabric of dreams",
			"eversleep" : "A silent light, curled up in eternal slumber"
		}[status],
		global_position[1],
		STAR_ZOOM_RANGE,
		Vector2.ONE * SIZE,
		[
			["followed", Time.get_datetime_string_from_unix_time(Global.get_follower_data(user_id, "time"))], 
			["constellation", parent_constellation.name], 
			["color", Colors.keys()[int(color)].capitalize()],
			["lat", global_position[1].y * Global.LOCATION_MULTIPLIER], 
			["lgt", global_position[1].x * Global.LOCATION_MULTIPLIER]
		],
		id
	)

func is_angle_outside_exclusion(angle) -> bool:
	var angle_excl_radians : float = deg_to_rad(Global.STAR_ANGLE_EXCLUSION) 
	for excluded_angle in excluded_angles:
		#prints(angle_excl_radians, abs(angle_difference(excluded_angle, angle)))
		if abs(angle_difference(excluded_angle, angle)) < angle_excl_radians:
			return false
	
	return true

func update_position():
	if _constructing: return
	if is_constellation_base or not parent_constellation:
		position = [Vector2.ZERO, Vector2.ZERO]
	else:
		var parent_star : Star = parent_constellation.get_star_from_id(parent_id)
		position[0] = parent_star.position[1]
		position[1] = get_end_pos(angle, distance) + position[0]
		
		var angle_buffer_rad = deg_to_rad(ANGLE_BUFFER)
		test_positions[0] = get_end_pos(angle + angle_buffer_rad, distance + DIST_BUFFER) + position[0]
		test_positions[1] = get_end_pos(angle - angle_buffer_rad, distance + DIST_BUFFER) + position[0]
		
		#prints("awooo", distance, position[0].distance_to(position[1]), "\nawooo angle", rad_to_deg(angle), )
		

func can_add_more_children() -> bool:
	return children < max_children

func get_end_pos(set_angle : float, set_dist : float) -> Vector2:
	return Vector2.from_angle(set_angle) * set_dist
	#Vector2(cos(angle + previous_angle), sin(angle + previous_angle)) * distance

func deconstruct() -> Array:
	return [user_id, username, angle, distance, id, parent_id, children, max_children, excluded_angles, is_constellation_base, Colors.keys()[int(color)], position, name]

var _constructing : bool = false
func construct(data : Array):
	_constructing = true
	user_id = data[0]
	username = data[1]
	angle = data[2]
	distance = data[3]
	id = data[4]
	parent_id = data[5]
	children = data[6]
	max_children = data[7]
	excluded_angles = data[8]
	is_constellation_base = data[9]
	color = Colors.get(data[10])
	position = data[11]
	if data.size() > 12: name = data[12] # TODO remove this once dicts are fixed, on the saved constellation file too
	else: name = ""
	_constructing = false
	add_to_POI()

func duplicate() -> Star:
	var star : Star = Star.new()
	star.construct(deconstruct())
	star.test_positions = test_positions
	star.parent_constellation = parent_constellation
	return star

func _to_string() -> String:
	return str(deconstruct())
