class_name Constellation

const BOX_BUFFER : int = 200
const ZOOM_RANGE : Array[float] = [0.15, 0.55]


var owner_username : String = "Unknown"
var owner_user_id : String = "Unknown"
var name : String = "Unknown Constellation"
var origin_position : Vector2 = Vector2.ZERO
var id : int = -1
var POI_id : int = 0
var max_stars : int = 2
var stars : Array[Star] = []
var neighbors : Array[int]
var creation_unix_time : int  = 0

func add_to_POI():
	var status : String = ""
	var time_alive : int = floor(Time.get_unix_time_from_system()) - creation_unix_time
	
	if time_alive < 7344000: # <90 days
		status = "newborn"
	elif time_alive < 31104000: # <1 year
		status = "mature"
	elif time_alive < 93312000: # < 3 years
		status = "remembered"
	else: # > 3 years
		status = "ancient"
	
	var average_position : Vector2 = Vector2.ZERO
	var star_count : float = stars.size()
	for star : Star in stars:
		average_position += star.position[0] / star_count
	
	var highest : Vector2 = average_position
	var lowest : Vector2 = average_position
	for star : Star in stars:
		var pos : Array = star.position.duplicate()
		for position : Vector2 in pos:
			if position.y > highest.y:
				highest.y = position.y
			
			if position.x > highest.x:
				highest.x = position.x
			
			if position.y < lowest.y:
				lowest.y = position.y
			
			if position.x < lowest.x:
				lowest.x = position.x
	
	average_position = Vector2((highest.x + lowest.x) * 0.5, (highest.y + lowest.y) * 0.5)
	
	POI_id = Global.add_POI(
		"Constellation",
		name,
		status + " " + ("(searching)" if star_count == 0 else ("(growing)" if star_count < max_stars else "(dorment)")),
		owner_username,
		{
			"newborn" : "A young constellation, I wonder what the future will hold for this one?",
			"mature" : "A blossoming flower, full of potential",
			"remembered" : "A well-set fragment in dreamspace, its story is often told",
			"ancient" : "A relic of times now forgotten"
		}[status],
		average_position + origin_position,
		ZOOM_RANGE,
		highest - lowest + Vector2.ONE * BOX_BUFFER,
		[
			["owner", owner_username], 
			["found", Time.get_datetime_string_from_unix_time(creation_unix_time)], 
			["identifier", id], 
			["num_stars", stars.size()], 
			["lat", (average_position.y + origin_position.y) * Global.LOCATION_MULTIPLIER], 
			["lgt", (average_position.x + origin_position.x) * Global.LOCATION_MULTIPLIER]
		],
		id,
		true
	)

func get_star_from_id(id : int) -> Star:
	for star : Star in stars:
		if star.id == id:
			return star
	
	printerr("Global search failed")
	print_stack()
	return Star.new()

func verify_star(verify_id : int) -> bool:
	var star : Star = get_star_from_id(verify_id)
	for test_star : Star in stars:
		if test_star.id == star.id or test_star.id == star.parent_id or test_star.parent_id == star.parent_id: continue
		var tests : Array = [
			Geometry2D.segment_intersects_segment(test_star.position[0], test_star.position[1], star.position[0], star.position[1]),
			Geometry2D.segment_intersects_segment(test_star.position[0], test_star.position[1], star.position[0], star.test_positions[0]),
			Geometry2D.segment_intersects_segment(test_star.position[0], test_star.position[1], star.position[0], star.test_positions[1])
		]
		
		print("star id ", test_star.id)
		if tests[0] != null or tests[1] != null or tests[2] != null:
			#print("c.5")
			#prints(Geometry2D.segment_intersects_segment(test_star.position[0], test_star.position[1], star.position[0], star.position[1]) != null, test_star.is_angle_outside_exclusion(star.angle))
			#print(not test_star.is_angle_outside_exclusion(star.angle))
			for test in tests:
				if test != null:
					Global.debug_draw_pos = test + origin_position
			
			
			
			return false
	return true
	

func attempt_add_star(star : Star) -> bool:
	if stars.size() >= max_stars:
		return false
	
	star.parent_constellation = self
	
	var canidates : Array[Star] = []
	for canidate : Star in stars:
		if canidate.can_add_more_children() and canidate.is_angle_outside_exclusion(star.angle) and abs(angle_difference(star.angle, canidate.angle)) > Global.EPSILON:
			canidates.append(canidate)
	
	if canidates.size() == 0:
		return false
	
	canidates.shuffle()
	var selected : Star
	for canidate : Star in canidates:
		star.parent_id = canidate.id
		var passed : bool = true
		for test_star : Star in stars:
			if test_star.id == canidate.id or test_star.parent_id == star.parent_id: 
				continue
			if stars.size() > 3:
				pass
			if Geometry2D.segment_intersects_segment(test_star.position[0], test_star.position[1], star.position[0], star.position[1]) != null\
			or Geometry2D.segment_intersects_segment(test_star.position[0], test_star.position[1], star.position[0], star.test_positions[0]) != null\
			or Geometry2D.segment_intersects_segment(test_star.position[0], test_star.position[1], star.position[0], star.test_positions[1]) != null:
				passed = false
				break
		
		if passed:
			selected = canidate
			break
	
	if selected:
		star.excluded_angles = [star.angle - PI]
		selected.excluded_angles.append(star.angle)
		star.children = 0
		selected.children += 1
		stars.append(star)
		star.add_to_POI()
		#print("e")
		return true
		
	#print("f")
	return false
	
	
	
	
	
	##print("a")
	##prints(stars.size(), max_stars)
	#if stars.size() >= max_stars:
		#return false
	##print("b")
	#var canidates : Array[Star] = []
	#for canidate_star : Star in stars:
		#if canidate_star.can_add_more_children() and canidate_star.is_angle_outside_exclusion(star.angle):
			#canidates.append(canidate_star)
	#
	#if canidates.size() == 0:
		#return false
	##prints("c", canidates)
	#canidates.shuffle()
	#
	#var selected : Star
	#for canidate in canidates:
		#var intersect : bool = false
		#for test_star : Star in stars:
			#if test_star.id == canidate.id: continue
			#if Geometry2D.segment_intersects_segment(test_star.position[0], test_star.position[1], canidate.position[1] + star.position[0], canidate.position[1] + star.position[1]) != null \
			#or Geometry2D.segment_intersects_segment(test_star.position[0], test_star.position[1], canidate.position[1] + star.position[0], canidate.position[1] + star.test_positions[0]) != null \
			#or Geometry2D.segment_intersects_segment(test_star.position[0], test_star.position[1], canidate.position[1] + star.position[0], canidate.position[1] + star.test_positions[1]) != null:
				##print("c.5")
				##prints(Geometry2D.segment_intersects_segment(test_star.position[0], test_star.position[1], star.position[0], star.position[1]) != null, test_star.is_angle_outside_exclusion(star.angle))
				##print(not test_star.is_angle_outside_exclusion(star.angle))
				#intersect = true
				#break
			#
				#
		#if not intersect:
			#
			#selected = canidate
			##print("d")
			#break
	##print(selected)
	#if selected:
		#star.parent_constellation = self
		#star.parent_id = selected.id
		#star.excluded_angles = [star.angle - PI]
		#selected.excluded_angles.append(star.angle)
		#star.children = 0
		#selected.children += 1
		#stars.append(star)
		##print("e")
		#return true
		#
	##print("f")
	#return false
	


func setup(base_star : Star, origin : Vector2, init_id : int, maximum_stars : int):
	base_star.angle = randf_range(0.0, TAU)
	base_star.distance = 0
	base_star.is_constellation_base = true
	base_star.parent_constellation = self
	
	max_stars = maximum_stars
	owner_username = base_star.username
	owner_user_id = base_star.user_id
	id = init_id
	origin_position = origin
	creation_unix_time = Time.get_unix_time_from_system()
	name = Global.dummy_constellation_names.pick_random()
	base_star.add_to_POI()
	stars.append(base_star)
	

func deconstruct() -> Array:
	var deconstructed_stars : Array[Array] = []
	for star : Star in stars:
		deconstructed_stars.append(star.deconstruct())
	
	return [name, owner_user_id, owner_username, origin_position, id, max_stars, deconstructed_stars, neighbors, creation_unix_time]

func construct(data : Array):
	name = data[0]
	owner_user_id = data[1]
	owner_username = data[2]
	origin_position = data[3]
	id = data[4]
	max_stars = data[5]
	stars = []
	for star_data : Array in data[6]:
		var star : Star = Star.new()
		star.parent_constellation = self
		star.construct(star_data)
		stars.append(star)
	
	neighbors = data[7]
	creation_unix_time = data[8]
	add_to_POI()

func _to_string() -> String:
	return str(deconstruct())
