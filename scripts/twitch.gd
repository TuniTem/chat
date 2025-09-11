extends Control

const HIDDEN_USERS = [] # "TuniTemVT", "tunitemvt"

@onready var chat: VBoxContainer = %Chat
@onready var chat_window: TextureRect = %ChatWindow

func _ready() -> void:
	Global.main = self
	Global.sparkle_holder = %SparkleHolder
	
	var setup_successful: bool = await Global.twitch.setup()
	print(setup_successful)
	if setup_successful:
		print("Twitch Service successfully set up and authenticated!")
		# Now you can proceed with other Twitch interactions
		await get_self_info()
	else:
		printerr("Twitch Service setup failed. Check authentication.")
	
	
	Global.chat.message_received.connect(_on_message_received)

func _on_message_received(message: TwitchChatMessage):
	#for frag : TwitchChatMessage.Fragment in message.message.fragments:
		#print("fragment: ", frag.text)
		#print(frag.type)
	#
	if not Global.DEBUG:
		if not message.chatter_user_name in HIDDEN_USERS and not message.message.text.begins_with("!"):
			if not Global.message_sent or message.chatter_user_name.to_lower() != Global.STREAMER_USERNAME.to_lower():
				chat.chat(message)
			
			else:
				Global.message_sent = false
	else:
		chat.chat(message)


func get_self_info():
	var current_user: TwitchUser = await Global.twitch.get_current_user()
	if current_user:
		print("Authenticated as: %s (ID: %s)" % [current_user.display_name, current_user.id])
	else:
		printerr("Could not get current user info.")
