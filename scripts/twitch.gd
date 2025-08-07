extends Control

const HIDDEN_USERS = ["TuniTemVT", "tunitemvt"]

@onready var chat: VBoxContainer = $chat

func _ready() -> void:
	Global.sparkle_holder = $SparkleHolder
	
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
	if not Global.DEBUG:
		if not message.chatter_user_name in HIDDEN_USERS:
			chat.chat(message.message.text, message.chatter_user_name, Color(message.get_color("#8c6da7")))
	
	else:
		chat.chat(message.message.text, message.chatter_user_name, Color(message.get_color("#8c6da7")))


func get_self_info():
	var current_user: TwitchUser = await Global.twitch.get_current_user()
	if current_user:
		print("Authenticated as: %s (ID: %s)" % [current_user.display_name, current_user.id])
	else:
		printerr("Could not get current user info.")
