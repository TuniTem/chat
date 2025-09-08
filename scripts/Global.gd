extends Node
# General
const DEBUG = true
var dummy_usernames = [
	"pixelNomad",
	"lunar_kicks",
	"ByteHawk",
	"echo42",
	"nebulaScout",
	"chronoTiger",
	"jade_loop",
	"frostbyte77",
	"staticVapor",
	"drift_packet",
	"zerochord",
	"cometRush",
	"wi_fi_wanderer",
	"glitchmint",
	"hexnova",
	"deepfield89",
	"synthwraith",
	"pyro_penguin",
	"vectorKnight",
	"lo_fi_moth",
	"anchorfox",
	"roam_codec",
	"8bitAltar",
	"codec_sleeper",
	"blurhive",
	"quantumDoodle",
	"strayquartz",
	"burntPixel",
	"silentmacro",
	"trex_dump",
	"nullcast",
	"chrome_hollow",
	"denim_crow",
	"coralplex",
	"ghost_tenant",
	"z3r0pulse",
	"sleepyRAM",
	"knuckleEcho",
	"tapecrawler",
	"lightgridX",
	"subwire",
	"chillax_void",
	"crypt_syrup",
	"mechhollow",
	"inkbuffer",
	"quietsync",
	"tombchip",
	"ascii_bard",
	"spoolghost",
	"frozen.circuits",
	"alleycube",
	"switchfox42",
	"breakninja",
	"protofire",
	"iced_panda",
	"j3tstream",
	"molasses_ram",
	"skybandit92",
	"loopjelly",
	"flickrider",
	"beamgoblin",
	"uptime_sage",
	"jaded_piston",
	"vanta_snake",
	"quartzFuel",
	"dusty_header",
	"starlitRAM",
	"analogdreamz",
	"zipjaw",
	"scuffed_angel",
	"knifebubble",
	"vault_idler",
	"echo_blimp",
	"crackling_tea",
	"zoodle_knight",
	"cyanoglyph",
	"owlbyte42",
	"melontracer",
	"fizzletrap",
	"drowsy_golem",
	"crimson_module",
	"tensor_rat",
	"mute.cactus",
	"camo_mirror",
	"atticVoltage",
	"keyedVoid",
	"sprocket_soup",
	"duskweaver",
	"arcgolem",
	"rest_circuit",
	"numlock_hiker",
	"botcrawl",
	"mopethrower",
	"railjacky",
	"vaporwhistle",
	"unplugged_ant",
	"overcast_leaf",
	"carbonJuggler",
	"minidusk",
	"tunnelmouse"
]
var dummy_constellation_names = [
	"Androsia",
	"Perseus",
	"Vulpecula",
	"Drakona",
	"Phoenix",
	"Serpentis",
	"Corvus",
	"Aquilara",
	"Lyra",
	"Telescopium",
	"Chironis",
	"Ophiuchus",
	"Carinax",
	"Scutum",
	"Antlia",
	"Hyronis",
	"Cetus",
	"Monoceros",
	"Eridanus",
	"Felora",
	"Orion",
	"Sagitta",
	"Volans",
	"Deltora",
	"Indus",
	"Fornax",
	"Triangulum",
	"Asterion",
	"Mensa",
	"Capricornus",
	"Sceptrum",
	"Equuleus",
	"Aranea",
	"Columba",
	"Aquila",
	"Lupora",
	"Pyxis",
	"Piscis Austrinus",
	"Caelus",
	"Taurus",
	"Dorado",
	"Leonis Minoris",
	"Lacerta",
	"Vespera",
	"Chamaeleon",
	"Centaurus",
	"Sagittarii",
	"Arboris",
	"Horologium",
	"Hydrus",
	"Cassiopeia",
	"Auriga",
	"Tenebris",
	"Canes Venatici",
	"Microscopium",
	"Vela",
	"Reticulum",
	"Lupus",
	"Geminor",
	"Corvus Major",
	"Pavo",
	"Umbra Serpentis",
	"Canis Major",
	"Crux",
	"Noctua",
	"Pyrrhus",
	"Pegasus",
	"Sculptor",
	"Lacrimosa",
	"Leo",
	"Delphinus",
	"Arbor Vitae",
	"Triangulum Australe",
	"Circinus",
	"Hydrus Minor",
	"Serpens",
	"Altaris",
	"Persephonis",
	"Musca",
	"Cygnus",
	"Vespertilio",
	"Phocis",
	"Hercules",
	"Argo Navis",
	"Umbrae",
	"Crater",
	"Corona Borealis",
	"Octans",
	"Nereis",
	"Volucra",
	"Draco",
	"Ankaa",
	"Ursa Major",
	"Umbellia",
	"Canis Minor",
	"Piscis Borealis",
	"Corona Australis",
	"Cetula",
	"Sagittarius",
	"Lyranthes"
]

const MAX_ID_GENERATION_ATTEMPTS = 1000
var active_ids : Array = []
var active_temp_ids : Array = []

# Commands
const CONSTELLATION_INSTRUCTIONS_LINK = "https://tunicommands.carrd.co/"

const COMMANDS_HELP_LINK : String = "https://tunicommands.carrd.co/"
const LINKTREE_LINK : String = "https://linktr.ee/tunitem"
const DISCORD_LINK : String = "https://discord.gg/ZSsZxYhRRt"
const YOUTUBE_LINK : String = "https://www.youtube.com/@TuniTem"
const VODS_CHANNEL_LINK : String = "https://www.youtube.com/@TuniTemVODs"
const COMMS_INTEREST_LINK : String = "https://forms.gle/gMceMfrQbeGdjSZn9"

const CHARACTER_LIMIT : Array = [3, 25]

const LURK_MESSAGES : Array[String] = [
	"[user] drifts through another fragment",
	"[user] blends in with the ink",
	"[user] stays in faded corners",
	"Shh... [user] is resting nearby",
	"[user] floats quietly with us",
	"[user] watches quietly"
]
const FOLLOW_NOTED : Array[String] = [
	"[user], you will be marked into the stars",
	"[user], you have been recorded in the astral ledger",
	"[user], you are now caught in this fragment with us"
]

const TIME_OF_ARRIVAL = 1773306000

var lurk_messages_buffer : Array[String]

# Emotes
const GLOBAL_EMOTES_PATH : String = "C:/ASSETS/Emotes/Twitch/all/"
const CUSTOM_EMOTES_PATH : String = "C:/ASSETS/Emotes/Twitch/custom/"
const RUNTIME_EMOTES_PATH : String = "res://art/emotes/"

const FOLLOWER_BACKUP_INTERVAL : int = 10
const EMOTE_SUBS : Array = [["_", ":"], ["#", "<"]]

var emotes : Dictionary = {}

# Tree
const HASH_LIMIT : int = 4294967295
const MAX_GENERATION_ATTEMPTS : int = 100
const BRANCH_DIST_MULT : float = 15.0
const BRANCH_ANGLE_CLAMP : int = 30
const RARITY : float = 144.0
const BRANCH_SPLITS : int = 3
const CHAR_ORDER : String = "aAb0BcCdD1eEfFg2GhHiI3jJkKl4LmMnN5oOpPq6QrRsS7tTuUv8VwWxX9yYzZ_"
const MATCH_WORD : String = "dreaming"
const MATCH_THRESH = 4
const BRANCH_COLLISION : bool = true
const DEBUG_GEN_USERS : int = 100
const GEN_TREE : bool = false

var tree : Array[Branch] = []
var ends : Dictionary[int, Array] = {-1: [Vector2.ZERO, 0.0]}
var avalable_branches : Array[Branch] = []
var max_branch_id : int = 0

# Star
const STARS_OPENING_ANIMATION_LENGTH : float = 8.0
#const STAR_ANGLE_CLAMP : int = 160
const STAR_ANGLE_EXCLUSION : float = 20.0
const STAR_DIST_MULT : float = 15.0
const STAR_SPLITS : int = 2
const STAR_COLLISION : bool = true
const MAX_CONSTELLATION_GENERATION_ATTEMPTS : int = 2000
const CONSTELLATION_MIN_DISTANCE = 1500
const CONSTELLATION_NEIGHBOR_DISTANCE = 3000
const CONSTELLATION_SPAWN_DISTANCE = 2000
const NEW_CONSTELLATION_MATCH_THRESH = 6
const GLITCHED_STAR_POSITION_VARIATION = Vector2.ONE * 2000
const BASE_CONSTELLATION_MAX_CHILDREN : int = 7
const GEN_STARS = true

var constellations : Array[Constellation] = []
var glitched_stars : Array[Star]

# POI
const POI_DISTANCE : float = 100
const POI_DRAW_DISTANCE : float = 500
const LOCATION_MULTIPLIER : float = 0.0015

var POIs : Array[Dictionary]
var closest_POI : Dictionary = {}

var simplify_constellations : bool = true

# Twitch 
const STREAMER_ID : String = "1050685508"
const STREAMER_USERNAME : String = "tunitemvt"
const MODS : Array[String] = [STREAMER_ID, "587345584"]
const NULL_ARG_CHAR = "͏"
const FOLLOWER_VERIFY_INDEXES : Array[int] = [1, 2]

@onready var chat : TwitchChat = %Chat
@onready var twitch: TwitchService = %TwitchService
@onready var api: TwitchAPI = %API

var followers : Array = []

# Nodes
var sparkle_holder : Node2D

var notification_manager : NotificationManager

var constellation_manager : Node2D



# Util
const EPSILON = 0.001
const FINE_EPSILON = 0.00001

var screen_id : String = "brb"
var debug_draw_pos : Vector2
var music_widget : Control
var crosshair : DrawCrosshair
var main : Control


func _ready():
	DisplayServer.window_set_title("Overlay")
	chat.message_received.connect(_on_chat_message_received)
	
	cashe_emotes()
	active_ids = DB.list("UID")
	followers = DB.list("followers")
	
	if GEN_TREE:
		DB.delete_DB("followers")
		DB.delete_DB("branches")
		
		DB.backup("followers", true)
		if DB.size("branches") == 0: 
			DB.append("branches", ["1050685508", "TuniTemVT", -PI/2.0, 100, 3000, false, 0, -1, 0, 2])
		
		for i in range(DEBUG_GEN_USERS):
			DB.append("followers" , [str(randi_range(1000, 99999)), dummy_usernames.pick_random() + str(randi_range(1, 1000))])
		verify_branches()
	
	if GEN_STARS:
		#for i in range(DEBUG_GEN_USERS):
			#print(i, "/", DEBUG_GEN_USERS)
			#DB.append("followers" , [str(randi_range(1000, 99999)), dummy_usernames.pick_random() + str(randi_range(1, 1000)), Time.get_unix_time_from_system()])
		load_constellations()
		
		await verify_followers()
		followers.sort_custom(Util.sort_ascending.bind(2))
		verify_constellations()

func _input(event: InputEvent) -> void:
	#if Util.input_context != "default" : return
	if DEBUG and event.is_action_pressed("debug"):
		return
		#if is_instance_valid(constellation_manager.telescope):
			#constellation_manager.telescope.queue_free()
			#
			#
		#constellation_manager._create_telescope()
		#constellation_manager.telescope.stop_loop(false)
		_on_follow_received({
			"user_id" : str(randi_range(100000, 9999999)),
			"user_name" : dummy_usernames.pick_random() + str(randi_range(1, 1000)),
			"followed_at": Time.get_datetime_string_from_system()
		})

func verify_followers():
	print("Fetching followers...")
	var opt : TwitchGetChannelFollowers.Opt = TwitchGetChannelFollowers.Opt.new()
	opt.first = 100
	var api_followers : TwitchGetChannelFollowers.Response = await api.get_channel_followers(opt, STREAMER_ID)
	var cannonical_followers : Array = []
	while cannonical_followers.size() == 0 or cannonical_followers[-1][1] != "Desilkan":
		for follower : TwitchGetChannelFollowers.ResponseData in api_followers.data:
			var formatted : Array = [follower.user_id, follower.user_name, Time.get_unix_time_from_datetime_string(follower.followed_at), true]
			cannonical_followers.append(formatted)
		
		print("(", cannonical_followers.size(), " / ", api_followers.total, ")")
		await api_followers.next_page()
	
	# followers in api but not in db
	var missed : Array = cannonical_followers.duplicate()
	for follower : Array in cannonical_followers:
		if Util.search(followers, 0, follower[0]):
			missed.erase(follower)
	
	# followers in db but not api
	var added : Array = followers.duplicate()
	for follower : Array in followers:
		if Util.search(cannonical_followers, 0, follower[0]):
			added.erase(follower)
	
	# mismatched data
	var mismatched : Dictionary[int, Array] = {}
	for check_idx : int in FOLLOWER_VERIFY_INDEXES:
		var to_add : Array = []
		for follower : Array in cannonical_followers:
			var _match = Util.search(followers, 0, follower[0])
			if _match and follower[check_idx] != _match[check_idx]:
				to_add.append([follower, _match])
		
		mismatched[check_idx] = to_add
	
	var err : bool = missed.size() + added.size() > 0
	if not err:
		for key in mismatched.keys():
			if mismatched[key].size() > 0:
				err = true
				break
	
	if err:
		printerr("Verify Followers: Something's up! Printing errors, make the bool below true to auto fix")
		
		print_rich("\n[color=red]Followers in the twitch API but not in the db:")
		if missed.size() == 0: print("<none>")
		else:
			for miss : Array in missed:
				print(miss)
		
		print_rich("\n[color=purple]Followers in the db but not in the twitch API:")
		if added.size() == 0: print("<none>")
		else:
			for add : Array in added:
				print(add)
		
		for idx in mismatched.keys():
			print_rich("\n[color=light_blue]Mismatched values on index ", idx, ":")
			if mismatched[idx].size() == 0: print("<none>")
			else:
				for mismatch : Array in mismatched[idx]:
					print(mismatch[0], "\n", mismatch[1], "\n")
		
		print("Break to allow cancellation...")
		var do_fix : bool = true
		if do_fix:
			for add : Array in added:
				followers.erase(add)
			
			for miss : Array in missed:
				followers.append(miss) # these will be added to constellation later
			
			for idx in mismatched.keys():
				for mismatch : Array in mismatched[idx]:
					mismatch[1][idx] = mismatch[0][idx]
					
					match idx:
						1:
							for star : Star in get_stars():
								if star.user_id == mismatch[1][0]:
									star.username = mismatch[1][1]
									break
							
							for constellation : Constellation in constellations:
								if constellation.owner_user_id == mismatch[1][0]:
									constellation.owner_username = mismatch[1][1]
									break
			
			save_constellation(true)
			DB.replace("followers", followers, true, true)


func get_nearby_POIs(position : Vector2, zoom : float, zoom_dependent_distance : bool = true) -> Array:
	var closest_POI_dist : float = INF
	closest_POI = {}
	#if closest_POI != {}: 
		#if position.distance_to(closest_POI["location"]) > POI_DRAW_DISTANCE:
			#closest_POI = {}
		#else:
			#closest_POI_dist = position.distance_to(closest_POI["location"])
	#else:
		#closest_POI_dist = INF
	
	var nearby_POIs : Array[Dictionary] = []
	
	for POI : Dictionary in POIs:
		if POI["zoom_range"][0] < zoom and zoom < POI["zoom_range"][1]:
			var distance : float = position.distance_to(POI["location"]) * (zoom if zoom_dependent_distance else 1.0)
			if distance < POI_DISTANCE and distance < closest_POI_dist:
				closest_POI = POI
				closest_POI_dist = distance
			
			elif distance < POI_DRAW_DISTANCE:
				nearby_POIs.append(POI)
	
	return [closest_POI, nearby_POIs]

func add_POI(type : String, object_name : String, object_status : String, _owner : String, description : String, location : Vector2, zoom_range : Array[float], bounding_box : Vector2, extra_info : Array = [], dupe_verify : int  = -2, draw_name : bool = false, is_dynamic : bool = false, can_select : bool = true) -> int: 
	if dupe_verify != -2:
		for POI in POIs:
			if POI["dupe_verify"]  == dupe_verify:
				return -1
	
	var id : int = create_temp_unique_id()
	
	POIs.append({
		"id" : id,
		"location" : location,
		"zoom_range" : zoom_range,
		"bounding_box" : bounding_box,
		"type" : type,
		"name" : object_name,
		"owner" : _owner,
		"status" : object_status,
		"description" : description,
		"extra_info" : extra_info,
		"draw_name" : draw_name,
		"drawing_name" : false,
		"dupe_verify": dupe_verify,
		"dynamic" : is_dynamic,
		"can_select": can_select
	})
	
	return id

#"id" : id,
#"location" : Vector2,
#"zoom_range" : Array, [numerical lower, numerical higher]
#"bounding_box" : Vector2,
#"type" : String,
#"name" : String,
#"owner" : String,
#"status" : String,
#"description" : String,
#"draw_name" : bool
#"drawing_name" : bool
#"extra_info" : Array[Array[String]] [["title1", value1 (variant)], "title2", value2 (variant)]]
#"dupe_verify": int
#"dynamic" : bool

func update_POI(id : int, entry : String, new_value : Variant):
	var selected : Dictionary = find_POI(id)
	if selected != {}:
		selected[entry] = new_value
			 
	

func remove_POI(id : int):
	POIs.erase(find_POI(id))

func find_POI(id : int) -> Dictionary:
	var selected_POI : Dictionary = {}
	for POI : Dictionary in POIs:
		if POI["id"] == id:
			return POI
	
	printerr("Could not find POI ", id, " avalable POIs printed")
	return {} 

func get_follower_data(id : String, key : String = "", username : bool = false):
	return Util.search(followers, 0 if not username else 1, id, true, null, {"id" : 0, "name" : 1, "time" : 2, "" : -1}[key])


func create_unique_id() -> int:
	for i in MAX_ID_GENERATION_ATTEMPTS:
		var test_id : int = randi()
		if not active_ids.has(test_id):
			active_ids.append(test_id)
			DB.append("UID", test_id, 1000)
			return test_id
	
	printerr("MAX UID GENERATION ATTEMPTS EXCEEDED, THIS REALLY SHOULD NOT HAPPEN!! CONTINUING GRACEFULLY AND YOU WILL NOT NOTICE ANYTHING BREAK UNLESS UR REALLY UNLUCKY BUT LIKE TOTTALLY FIX THIS COS THE UID SYSTEM JUST ISNT WORKING")
	return randi()

func create_temp_unique_id() -> int:
	for i in MAX_ID_GENERATION_ATTEMPTS:
		var test_id : int = randi()
		if not active_temp_ids.has(test_id):
			active_temp_ids.append(test_id)
			return test_id
	
	printerr("MAX TUID GENERATION ATTEMPTS EXCEEDED, THIS REALLY SHOULD NOT HAPPEN!! CONTINUING GRACEFULLY AND YOU WILL NOT NOTICE ANYTHING BREAK UNLESS UR REALLY UNLUCKY BUT LIKE TOTTALLY FIX THIS COS THE UID SYSTEM JUST ISNT WORKING")
	return randi()

func get_stars() -> Array[Star]:
	var out : Array[Star] = []
	for constellation : Constellation in constellations:
		out.append_array(constellation.stars)
	
	return out 

func get_user_star(user_id : String):
	for star : Star in get_stars():
		if star.user_id == user_id:
			return star

func load_constellations():
	var db_constellations : Array = DB.list("constellations")
	constellations = []
	for constellation : Array in db_constellations:
		var new_constellation : Constellation = Constellation.new()
		new_constellation.construct(constellation)
		constellations.append(new_constellation)

func verify_constellations():
	var created_ids : Array[String] = []
	for star : Star in get_stars():
		created_ids.append(star.user_id)
	
	var new_followers : Array = []
	for follower : Array in followers:
		if not created_ids.has(follower[0]):
			new_followers.append(follower)
	
	if new_followers.size() != 0: 
		printerr("Unstellar Followers: Something's up! Printing errors, make the bool below true to auto fix")
		
		print_rich("\n[color=pink]Followers that don't own stars:")
		for follower : Array in new_followers:
			print(follower)
		
		print("Break to allow cancellation...")
		var fix : bool = true
		if fix:
			for follower : Array in new_followers:
				generate_star(follower[1], follower[0])
			save_constellation(true)
	
	for constellation : Constellation in constellations:
		constellation.add_to_POI()

func save_constellation(backup : bool, mark_start : bool = false):
	var data : Array[Array] = []
	for constellation : Constellation in constellations:
		data.append(constellation.deconstruct())
	
	DB.replace("constellations", data, backup, mark_start)

func add_glitched_star(star : Star):
	# TODO do something fun here
	var glitch_pos : Vector2 = GLITCHED_STAR_POSITION_VARIATION * randf_range(-1.0, 1.0)
	star.position = [glitch_pos, glitch_pos]
	glitched_stars.append(star)

func generate_constellation(base_star : Star) -> bool:
	#print("a")
	var average_position : Vector2 = Vector2.UP
	var star_count : float = 0
	var star_positions : Array[Array] = []
	
	for constellation : Constellation in constellations:
		for star : Star in constellation.stars:
			star_count += 1.0
			star_positions.append([star.position[1] + constellation.origin_position, constellation.id])
	
	if star_positions.size() == 0:
		star_positions = [[Vector2.ZERO, 0]]
	
	
	if star_count != 0.0:
		for star : Array in star_positions:
			average_position += star[0] / star_count
	else:
		average_position == Vector2.UP
	
	var spawn_position : Vector2
	for i in MAX_CONSTELLATION_GENERATION_ATTEMPTS:
		#print("b")
		var star_info : Array = star_positions.pick_random()
		var star_pos : Vector2 = star_info[0]
		var constellation_id : int = star_info[1]
		
		
		var test_pos : Vector2 = average_position.direction_to(star_pos).rotated(randf_range(-PI/3,PI/3)) * CONSTELLATION_SPAWN_DISTANCE + star_pos
		#prints(test_pos, star_pos, average_position, (star_pos - average_position).normalized())
		var neigboring_constellations : Array[int] = []
		var cont : bool = false
		for star : Array in star_positions:
			var distance : float = test_pos.distance_to(star[0])
			#prints(test_pos, star[0], distance)
			if distance < CONSTELLATION_MIN_DISTANCE:
				cont = true
				#print("c")
				break
			if i < MAX_CONSTELLATION_GENERATION_ATTEMPTS / 2.0:
				#prints(distance, CONSTELLATION_NEIGHBOR_DISTANCE)
				if (distance < CONSTELLATION_NEIGHBOR_DISTANCE and not neigboring_constellations.has(star[1])):
					#print("c.5")
					neigboring_constellations.append(star[1])
			else:
				#print("c.3")
				neigboring_constellations = [-1]
		#prints(neigboring_constellations.size(), cont, not (neigboring_constellations.size() != 0 and neigboring_constellations[0] == -1), neigboring_constellations.size() < 2)
		if cont:
			#print("d1")
			continue
			
		if neigboring_constellations.size() > 2:#  or (neigboring_constellations.size() != 0 and neigboring_constellations[0] == -1)
			#print("d2")
			print("ncon", neigboring_constellations)
			spawn_position = test_pos
			break
			
		
		
		
		spawn_position = test_pos
	
	if spawn_position:
		#print("e")
		var constellation : Constellation = Constellation.new()
		constellation.setup(base_star, spawn_position, create_unique_id(), BASE_CONSTELLATION_MAX_CHILDREN + base_star.username.length())
		constellations.append(constellation)
		print("New constellation! ", constellation.deconstruct())
		return true
	
	return false

func generate_star(source : String, id : String, trigger_anim : bool = false) -> Star:
	var star : Star = Star.new()
	star.username = source
	star.user_id = id
	star.angle = remap(float(CHAR_ORDER.find(source[0])) / float(CHAR_ORDER.length() - 1), 0.0, 1.0, 0.0, TAU)
	star.distance = source.length() * STAR_DIST_MULT
	star.color = randi_range(0,3)
	
	star.id = create_unique_id()
	if Util.TIME > 0.2: star.draw_amount = 0.0 
	# TODO idea for not here have stars added to people with similar names
	for i : float in range(1, STAR_SPLITS):
		if hash(source) < (float(HASH_LIMIT) / float(STAR_SPLITS)) * i:
			star.max_children = i
		else:
			star.max_children = STAR_SPLITS
			
	if hash(source) > HASH_LIMIT - float(HASH_LIMIT) / RARITY:
		star.max_children = STAR_SPLITS + 1
	
	# check if they get a new constellation
	var total : int = 0
	for letter in MATCH_WORD:
		if source.to_lower().contains(letter):
			total += 1
	
	if total < NEW_CONSTELLATION_MATCH_THRESH:
		var shuffled_constellations : Array[Constellation] = constellations
		shuffled_constellations.shuffle()
		var star_added : bool = false
		for constellation : Constellation in shuffled_constellations:
			if constellation.attempt_add_star(star):
				star_added = true
				break
				#print("add succ")
			#else:
				#print("add failed")
		
		if not star_added and not generate_constellation(star):
			print("errr1 star ", star)
			add_glitched_star(star)
	
	else:
		if not generate_constellation(star):
			print("errr2 star ", star)
			add_glitched_star(star)
			
	print("generated star ", star)
	return star
	


func emote_exists(emote : String):
	return emotes.keys().has(emote)

func cashe_emotes():
	var restart : bool = false
	var global_emotes = DirAccess.open(GLOBAL_EMOTES_PATH)
	var custom_emotes = DirAccess.open(CUSTOM_EMOTES_PATH)
	var runtime_emotes = DirAccess.open(RUNTIME_EMOTES_PATH)
	
	for file in global_emotes.get_files():
		var emote : String = file.split(".")[0]
		for sub in EMOTE_SUBS:
			emote = emote.replace(sub[0], sub[1]) 
		
		if not runtime_emotes.file_exists(file):
			print("copy " + file)
			restart = true
			global_emotes.copy(GLOBAL_EMOTES_PATH + file, ProjectSettings.globalize_path(RUNTIME_EMOTES_PATH + file))
		
		emotes.set(emote, RUNTIME_EMOTES_PATH + file)
	
	for file in custom_emotes.get_files():
		var emote : String = file.split(".")[0]
		for sub in EMOTE_SUBS:
			emote = emote.replace(sub[0], sub[1]) 
		
		if not runtime_emotes.file_exists(file):
			print("copy " + file)
			restart = true
			custom_emotes.copy(CUSTOM_EMOTES_PATH + file, ProjectSettings.globalize_path(RUNTIME_EMOTES_PATH + file))
		
		emotes.set(emote, RUNTIME_EMOTES_PATH + file)
	
	
	if restart:
		printerr("Import needed, closing. U can just reopen")
		get_tree().quit()

func send_message(message : String, mention : String = ""):
	if mention != "": message = "@" + mention + " " + message
	var response_data: Array[TwitchSendChatMessage.ResponseData] = await chat.send_message(message)
	if not response_data.is_empty() and response_data[0].is_sent:
		print("Sent: " + message)
	else:
		printerr("Failed to send " + message + ". Reason: ", response_data[0].drop_reason if not response_data.is_empty() else "Unknown")

func update_constellation_name(constellation : Constellation, to : String):
	constellation.name = to
	save_constellation(Util.cooldown("const_backup", 3600.0))
	update_POI(constellation.POI_id, "name", to)

func locate_constellation(constellation : Constellation):
	display_POI(constellation.POI_id)

func update_star_name(star : Star, to : String):
	star.name = to
	save_constellation(Util.cooldown("const_backup", 3600.0))
	update_POI(star.POI_id, "name", to)

func locate_star(star : Star):
	display_POI(star.POI_id)
	

func display_POI(POI_id : int):
	constellation_manager.add_to_buffer(find_POI(POI_id))

func user_is_mod(user : String) -> bool:
	if user.to_lower() == STREAMER_USERNAME: return true
	return MODS.has(Global.get_follower_data(user, "id", true))

func clean_args(args : PackedStringArray):
	for i in range(args.size()):
		if args[i] == NULL_ARG_CHAR:
			args.remove_at(i)
			break
	

func _on_chat_message_received(chat_message: TwitchChatMessage):
	print("[%s] %s: %s" % [chat_message.broadcaster_user_name, chat_message.chatter_user_name, chat_message.message.text])
	#notification_manager.send_notification(NotificationManager.NotificationType.FOLLOW, Time.get_unix_time_from_system(), chat_message.chatter_user_name)
	# Example: Reply "Hello!" to any message containing "hi"
	#if "hi" in chat_message.message.text.to_lower():
		#var response_data: Array[TwitchSendChatMessage.ResponseData] = await chat.send_message("Hello!", chat_message.message_id)
		#if not response_data.is_empty() and response_data[0].is_sent:
			#print("Replied successfully!")
		#else:
			#printerr("Failed to send reply. Reason: ", response_data[0].drop_reason if not response_data.is_empty() else "Unknown")


func _on_follow_received(data: Dictionary) -> void:
	# TODO add ppl to stars
	prints("follow: " + str(data))
	var follower_arr : Array = [data["user_id"], data["user_name"], Time.get_unix_time_from_datetime_string(data["followed_at"]), true]
	DB.update("followers", data["user_id"], follower_arr)
	followers.append(follower_arr)
	notification_manager.send_notification(NotificationManager.NotificationType.FOLLOW, Time.get_unix_time_from_datetime_string(data["followed_at"]), data["user_name"])
	#if not DB.find("branches", data["user_id"]):
		##send_message(FOLLOW_NOTED.pick_random().replace("[user]", data["user_name"]))
		#if GEN_TREE:
			#generate_branch(data["user_name"], data["user_id"], true)
			#update_branches()
		
	if GEN_STARS:
		constellation_manager.add_to_buffer(generate_star(data["user_name"], data["user_id"], true))

func _on_lurk_command_received(from_username: String, info: TwitchCommandInfo, args: PackedStringArray) -> void:
	if lurk_messages_buffer.size() == 0 : lurk_messages_buffer = LURK_MESSAGES.duplicate()
	send_message(lurk_messages_buffer.pop_at(randi_range(0, lurk_messages_buffer.size() - 1)).replace("[user]", from_username))

func _on_timeleft_command_received(from_username: String, info: TwitchCommandInfo, args: PackedStringArray) -> void:
	var seconds_total : int = TIME_OF_ARRIVAL - Time.get_unix_time_from_system()
	print("stotal ", seconds_total)
	var seconds_left : int = seconds_total % 60
	var minutes_left : int = (seconds_total % 3600) / 60
	var hours_left : int = (seconds_total % 86400) / 3600
	var days_left : int = (seconds_total / 86400)
	send_message(str(days_left) + " days, " + str(hours_left) + " hours, " + str(minutes_left) + " minutes, " + str(seconds_left) + " seconds.", from_username)

func _on_music_command_received(from_username: String, info: TwitchCommandInfo, args: PackedStringArray) -> void:
	send_message("Currently playing . . . . . " + Music.get_current_song_as_string() + " " + Music.get_current_song_link())
	music_widget.visiblity = 10.0

func _on_constellation_command_received(from_username: String, info: TwitchCommandInfo, args: PackedStringArray) -> void:
	if from_username == "nebn3b": from_username = "Desilkan"
	clean_args(args)
	if args.size() == 0 or args[0] == "info":
		#send_message("Every follower gets a permanent star in dreamspace! You can rename it with \"!s name <star name>\" and if you own a constellation, name it with \"!c name <constellation name>\"", from_username)
		#await Util.wait(0.5)
		send_message("You can learn about constellations at the bottom of this page: " + CONSTELLATION_INSTRUCTIONS_LINK, from_username)
		return
	
	var constellation : Constellation
	for con : Constellation in constellations:
		if con.owner_username.to_lower() == from_username.to_lower():
			constellation = con
			break
	
	if not constellation:
		send_message("You do not own a constellation!", from_username)
		return
	
	match args[0]:
		"name":
			if args.size() == 1:
				send_message("Format: !c name <name>", from_username)
				return
			
			var new_name : String = ""
			var temp_args : PackedStringArray = args.duplicate()
			temp_args.remove_at(0)
			for i in range(temp_args.size()):
				new_name += temp_args[i]
				if i != temp_args.size() - 1: new_name += " "
			
			
			if not Util.is_alphanumeric(new_name):
				send_message("Names can only contain A-Z and 0-9", from_username)
				return
			
			if not Util.between(new_name.length(), CHARACTER_LIMIT[0], CHARACTER_LIMIT[1], true):
				send_message("Names must be between " + str(CHARACTER_LIMIT[0]) + " and " + str(CHARACTER_LIMIT[1]) + " characters", from_username)
				return
			
			if Util.cooldown(from_username + "cname", 600.0):
				update_constellation_name(constellation, new_name)
				send_message("Constellation name updated!", from_username)
			
			else:
				send_message("Cooldown: " + Util.cooldown_timeleft_string(from_username + "cname", 600.0), from_username)
				
		"locate":
			if Util.cooldown(from_username + "clocate", 120.0):
				locate_constellation(constellation)
			else:
				send_message("Cooldown: " + Util.cooldown_timeleft_string(from_username + "clocate", 120.0), from_username)
		
		"status":
			send_message("STATUS : " + find_POI(constellation.POI_id)["status"], from_username)
		
		"age", "found":
			send_message("FOUND : " + Time.get_datetime_string_from_unix_time(constellation.creation_unix_time), from_username)
		
		"has":
			send_message("You own a constellation!", from_username)
		
		_:
			send_message("Unknown argument \"" + args[0] + "\"", from_username)

func _on_star_command_received(from_username: String, info: TwitchCommandInfo, args: PackedStringArray) -> void:
	if from_username == "nebn3b": from_username = "Desilkan"
	clean_args(args)
	if args.size() == 0 or args[0] == "info":
		send_message("You can learn about constellations at the bottom of this page: " + CONSTELLATION_INSTRUCTIONS_LINK, from_username)
		return
	
	var star : Star
	for s : Star in get_stars():
		if s.username.to_lower() == from_username.to_lower():
			star = s
			break
	
	if not star:
		send_message("Could not find star, you might be unfollowed!", from_username)
		return
	
	match args[0]:
		"name":
			if args.size() == 1:
				send_message("Format: !s name <name>", from_username)
				return
			
			var new_name : String = ""
			var temp_args : PackedStringArray = args.duplicate()
			temp_args.remove_at(0)
			for i in range(temp_args.size()):
				new_name += temp_args[i]
				if i != temp_args.size() - 1: new_name += " "
			
			if not Util.is_alphanumeric(new_name):
				send_message("Names can only contain A-Z and 0-9", from_username)
				return
			
			if not Util.between(new_name.replace(" ", "").length(), CHARACTER_LIMIT[0], CHARACTER_LIMIT[1], true):
				send_message("Names must be between " + str(CHARACTER_LIMIT[0]) + " and " + str(CHARACTER_LIMIT[1]) + " characters", from_username)
				return
			
			if Util.cooldown(from_username + "sname", 300.0):
				update_star_name(star, new_name)
				send_message("Star name updated!", from_username)
			
			else:
				send_message("Cooldown: " + Util.cooldown_timeleft_string(from_username + "sname", 300.0), from_username)
				
		"locate":
			if Util.cooldown(from_username + "slocate", 120.0):
				locate_star(star)
			else:
				send_message("Cooldown: " + Util.cooldown_timeleft_string(from_username + "slocate", 120.0), from_username)
		
		"status":
			send_message("STATUS : " + find_POI(star.POI_id)["status"], from_username)
		
		"age", "found":
			var time = Global.get_follower_data(from_username, "time", true)
			if time:
				var str_time : PackedStringArray = Time.get_datetime_string_from_unix_time(time).split("T")[0].split("-")
				send_message("FOUND : " + str_time[1] + "/" + str_time[2] + "/" + str_time[0], from_username)
		
		_:
			send_message("Unknown argument \"" + args[0] + "\"", from_username)

# format: !rn <name> [s or c, it defaults both] [name to set to, default names by default]
func _on_reset_name_command_received(from_username: String, info: TwitchCommandInfo, args: PackedStringArray) -> void:
	if from_username == "nebn3b": from_username = "Desilkan"
	clean_args(args)
	print(from_username)
	if not user_is_mod(from_username): 
		print("not mod " + from_username)
		return
	var size : int = args.size()
	if size == 0:
		send_message("Format: !rn <name> [s or c, defaults both] [name to set to]", from_username)
		return
	
	var star : Star
	for s : Star in get_stars():
		if s.username.to_lower() == args[0].to_lower():
			star = s
			break
	print(star)
	if not star:
		send_message("Could not find user " + args[0], from_username)
		return
	
	var to : String = ""
	if size >= 3:
		var new_name : String = ""
		var temp_args : PackedStringArray = args.duplicate()
		temp_args.remove_at(0)
		temp_args.remove_at(0)
		for i in range(temp_args.size()):
			new_name += temp_args[i]
			if i != temp_args.size() - 1: new_name += " "
		
		to = new_name
	
	var constellation : Constellation
	if size > 1:
		match args[1]:
			"s":
				update_star_name(star, args[0] + "'s Star" if to == "" else to)
				send_message("Reset star name: " + args[0], from_username)
				return
			"c": 
				if star.is_constellation_base:
					constellation = star.parent_constellation
					update_constellation_name(constellation, Global.dummy_constellation_names.pick_random() if to == "" else to)
					send_message("Reset constellation name: " + args[0], from_username)
					return
				else:
					send_message(args[0] + " does not appear to own their constellation", from_username)
					return
			_:
				send_message("Unknown argument \"" + args[1] + "\" use 'c' [constellation] or 's' [star]", from_username)
				return
	
	else:
		if star.is_constellation_base:
			constellation = star.parent_constellation
	
	
	
	update_star_name(star, args[0] + "'s Star" if to == "" else to)
	
	if constellation:
		update_constellation_name(constellation, Global.dummy_constellation_names.pick_random() if to == "" else to)
		
	
	send_message("Reset user: " + args[0], from_username)

func _on_followed_command_received(from_username: String, info: TwitchCommandInfo, args: PackedStringArray) -> void:
	if from_username == "nebn3b": from_username = "Desilkan"
	clean_args(args)
	var user : String = from_username
	if args.size() == 1:
		user = args[0]
	
	var time = Global.get_follower_data(user, "time", true)
	
	
	if time:
		var str_time : PackedStringArray = Time.get_datetime_string_from_unix_time(time).split("T")[0].split("-")
		send_message("followed on " + str_time[1] + "/" + str_time[2] + "/" + str_time[0], from_username)
	elif args.size() == 1:
		send_message("Unknown user " + args[0], from_username)
	else:
		send_message("Not followed", from_username)

func _on_inspect_command_received(from_username: String, info: TwitchCommandInfo, args: PackedStringArray) -> void:
	if STREAMER_USERNAME != from_username.to_lower(): return
	clean_args(args)
	if args.size() == 0 or args[0] == "͏": return
	
	print_rich("[color=purple]", Global.get_follower_data(args[0], "", true))

func _on_link_command_recived(from_username: String, info: TwitchCommandInfo, args: PackedStringArray) -> void:
	clean_args(args)
	var ping : String = from_username
	if args.size() > 0: 
		ping = args[0]
	
	match info.command.command:
		"commands": send_message("List of commands: " + COMMANDS_HELP_LINK, ping)
		"linktree": send_message("All socials: " + LINKTREE_LINK, ping)
		"discord": send_message("Dream with me <3 " + DISCORD_LINK, ping)
		"youtube": send_message("My fractured dreams <3 " + YOUTUBE_LINK, ping)
		"vods": send_message("Past streams: " + VODS_CHANNEL_LINK, ping)
		"comms": send_message("Comission interest form: " + COMMS_INTEREST_LINK, ping)

# ---------------------------------
# Old code below for an old branch/tree idea that i dont really want cuttering up my actually active code

func verify_branches():
	var followers : Array = DB.list("followers")
	var branches : Array = DB.list("branches")
	var created_ids : Array[String] = []
	for branch : Array in branches:
		created_ids.append(branch[0])
	#print("a",DB.list("branches", 6))
	var new_followers : Array = []
	for follower : Array in followers:
		if not created_ids.has(follower[0]):
			new_followers.append(follower)
		
	#print("b",DB.list("branches", 6))
	#prints("follow", new_followers)
	#prints("cid",created_ids)
	if new_followers.size() != 0: 
		printerr("Unbranched followers! uncomment below line to fix")
		for follower : Array in new_followers:
			update_branches()
			generate_branch(follower[1], follower[0])
	else:
		update_branches()

func update_branches():
	tree.clear()
	avalable_branches.clear()
	
	for de_branch : Array in DB.list("branches"):
		var branch : Branch = Branch.new()
		branch.construct(de_branch)
		tree.append(branch)
		if branch.children < branch.max_children:
			avalable_branches.append(branch)
		
		max_branch_id = max(branch.id, max_branch_id)
	
	tree.sort_custom(func sort_id(a, b): return a.id < b.id)
	for branch: Branch in tree:
		var abs_angle = wrapf(branch.angle + ends[branch.parent_id][1], 0.0, TAU)
		ends[branch.id] = [Vector2.RIGHT.rotated(abs_angle) * branch.distance + ends[branch.parent_id][0], abs_angle]

func find_branch_end(parent_pos: Vector2, parent_angle: float, angle: float, distance: float) -> Vector2:
	return parent_pos + Vector2.RIGHT.rotated(parent_angle + angle) * distance

func get_branch(id : int) -> Branch:
	#print(tree)
	#if id == -1 : 
	for branch : Branch in tree:
		#prints("GB", id, branch.id)
		if branch.id == id:
			return branch
	#print("betrlucknextim")
	return tree[0]

func generate_branch(source : String, id : String, trigger_anim : bool = false) -> Branch:
	var branch : Branch = Branch.new()
	branch.username = source
	branch.user_id = id
	branch.angle = remap(float(CHAR_ORDER.find(source[0])) / float(CHAR_ORDER.length() - 1), 0.0, 1.0, deg_to_rad(-BRANCH_ANGLE_CLAMP), deg_to_rad(BRANCH_ANGLE_CLAMP))
	branch.distance = source.length() * BRANCH_DIST_MULT
	branch.curve_radius = branch.distance + branch.distance * float(CHAR_ORDER.find(source[-1])) / float(CHAR_ORDER.length() - 1)
	
	var selected : Branch = avalable_branches.pick_random()
	if BRANCH_COLLISION:
		for attempt in MAX_GENERATION_ATTEMPTS:
			#if selected.id == 0: break
			var new_branch_end : Vector2 = find_branch_end(ends[selected.id][0], ends[selected.id][1], branch.angle, branch.distance)
			
			var intersects := false
			for test_branch_id in ends.keys():
				if test_branch_id == selected.id: continue
				var parent_end : Vector2 = ends[get_branch(test_branch_id).parent_id][0]
				if Geometry2D.segment_intersects_segment(ends[selected.id][0], new_branch_end, ends[test_branch_id][0], parent_end) != null:
					intersects = true
					break
			
			if not intersects:
				break
			
			if attempt == MAX_GENERATION_ATTEMPTS - 1:
				printerr("Could not find avalable branch parent")
			
			selected = avalable_branches.pick_random()
	
	
	max_branch_id += 1
	branch.id = max_branch_id
	
	branch.parent_id = selected.id
	selected.children += 1
	if selected.children >= selected.max_children:
		avalable_branches.erase(selected)
	
	DB.update("branches", selected.user_id, selected.deconstruct())
	var total : int = 0
	for letter in MATCH_WORD:
		if source.to_lower().contains(letter):
			total += 1
	
	branch.cw = total < MATCH_THRESH
	
	for i : float in range(1, BRANCH_SPLITS):
		if hash(source) < (float(HASH_LIMIT) / float(BRANCH_SPLITS)) * i:
			branch.max_children = i
		else:
			branch.max_children = BRANCH_SPLITS
			
	if hash(source) > HASH_LIMIT - float(HASH_LIMIT) / RARITY:
		branch.max_children = BRANCH_SPLITS + 1
	
	avalable_branches.append(branch)
	DB.append("branches", branch.deconstruct())
	print("generated branch ", branch)
	return branch
