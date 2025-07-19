extends Node

const GLOBAL_EMOTES_PATH : String = "C:/ASSETS/Emotes/Twitch/all/"
const CUSTOM_EMOTES_PATH : String = "C:/ASSETS/Emotes/Twitch/custom/"
const RUNTIME_EMOTES_PATH : String = "res://art/emotes/"
const EMOTE_SUBS : Array = [["_", ":"], ["#", "<"]]

var sparkle_holder : Node2D
var emotes : Dictionary = {}


@onready var chat : TwitchChat = %Chat
@onready var twitch: TwitchService = %TwitchService

func _ready():
	chat.message_received.connect(_on_chat_message_received)
	#chat.send_message("heyo")
	# If subscribe_on_ready is false, you might need to call this:
	# twitch_chat.subscribe()
	cashe_emotes()


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
		print("Import needed, closing. U can just reopen")
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
