extends Node

const GLOBAL_EMOTES_PATH : String = "C:/ASSETS/Emotes/Twitch/all/"
const CUSTOM_EMOTES_PATH : String = "C:/ASSETS/Emotes/Twitch/custom/"
const RUNTIME_EMOTES_PATH : String = "res://art/emotes/"

const FOLLOWER_BACKUP_INTERVAL : int = 10
const EMOTE_SUBS : Array = [["_", ":"], ["#", "<"]]

#branch stuff
const HASH_LIMIT : int = 4294967295
const DIST_MULT : float = 15.0
const ANGLE_CLAMP : int = 30
const RARITY : float = 144.0
const SPLITS : int = 3
const CHAR_ORDER : String = "aAb0BcCdD1eEfFg2GhHiI3jJkKl4LmMnN5oOpPq6QrRsS7tTuUv8VwWxX9yYzZ_"
const MATCH_WORD : String = "dreaming"
const MATCH_THRESH = 4

var tree : Array[Branch] = []
var avalable_branches : Array[Branch] = []
var max_branch_id : int = 0
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

var sparkle_holder : Node2D
var emotes : Dictionary = {}


@onready var chat : TwitchChat = %Chat
@onready var twitch: TwitchService = %TwitchService

func _ready():
	chat.message_received.connect(_on_chat_message_received)
	cashe_emotes()
	DB.backup("followers", true)
	if DB.size("branches") == 0: 
		DB.append("branches", ["1050685508", "TuniTemVT", PI/2.0, 100, 3000, false, 0, -1, 0, 2])
	
	for i in range(10):
		DB.append("followers" , [str(randi_range(1000, 99999)), dummy_usernames.pick_random()])
	
	verify_branches()

func verify_branches():
	var followers : Array = DB.list("followers")
	var branches : Array = DB.list("branches")
	var created_ids : Array[String] = []
	for branch : Array in branches:
		created_ids.append(branch[0])
		
	for follower : Array in followers:
		if created_ids.has(follower[0]):
			followers.erase(follower)
	
	if followers.size() != 0: 
		printerr("Unbranched followers! uncomment below line to fix")
		for follower : Array in followers:
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
		

func generate_branch(source : String, id : String, trigger_anim : bool = false) -> Branch:
	var branch : Branch = Branch.new()
	branch.username = source
	branch.user_id = id
	branch.angle = remap(float(CHAR_ORDER.find(source[0])) / float(CHAR_ORDER.length() - 1), 0.0, 1.0, -ANGLE_CLAMP, ANGLE_CLAMP)
	branch.distance = source.length() * DIST_MULT
	branch.curve_radius = branch.distance + branch.distance * float(CHAR_ORDER.find(source[-1])) / float(CHAR_ORDER.length() - 1)
	max_branch_id += 1
	branch.id = max_branch_id
	var selected : Branch = avalable_branches.pick_random()
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
	
	for i : float in range(1, SPLITS):
		if hash(source) < (float(HASH_LIMIT) / float(SPLITS)) * i:
			branch.max_children = i
		else:
			branch.max_children = SPLITS
			
	if hash(source) > HASH_LIMIT - float(HASH_LIMIT) / RARITY:
		branch.max_children = SPLITS + 1
	
	avalable_branches.append(branch)
	DB.update("branches", id, branch.deconstruct())
	
	print("generated branch ", branch)
	return branch



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
	
	print(emotes)
	
	if restart:
		printerr("Import needed, closing. U can just reopen")
		get_tree().quit()


# Callback function for new messages
func _on_chat_message_received(chat_message: TwitchChatMessage):
	print("[%s] %s: %s" % [chat_message.broadcaster_user_name, chat_message.chatter_user_name, chat_message.message.text])

	# Example: Reply "Hello!" to any message containing "hi"
	#if "hi" in chat_message.message.text.to_lower():
		#var response_data: Array[TwitchSendChatMessage.ResponseData] = await chat.send_message("Hello!", chat_message.message_id)
		#if not response_data.is_empty() and response_data[0].is_sent:
			#print("Replied successfully!")
		#else:
			#printerr("Failed to send reply. Reason: ", response_data[0].drop_reason if not response_data.is_empty() else "Unknown")


func _on_follow_received(data: Dictionary) -> void:
	DB.update("followers", data["user_id"], [data["user_id"], data["user_name"], Time.get_unix_time_from_datetime_string(data["followed_at"]), true])
	if not DB.find("branches", data["user_id"]):
		generate_branch(data["user_name"], data["user_id"], true)
		update_branches()
	
