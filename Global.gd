extends Node

@onready var chat : TwitchChat = %Chat
@onready var twitch: TwitchService = %TwitchService

func _ready():
	
	chat.message_received.connect(_on_chat_message_received)
	#chat.send_message("heyo")
	# If subscribe_on_ready is false, you might need to call this:
	# twitch_chat.subscribe()
	

# Callback function for new messages
func _on_chat_message_received(chat_message: TwitchChatMessage):
	print("paiqwfejnapwenfpiawn")
	print("[%s] %s: %s" % [chat_message.broadcaster_user_name, chat_message.chatter_user_name, chat_message.message.text])

	# Example: Reply "Hello!" to any message containing "hi"
	if "hi" in chat_message.message.text.to_lower():
		var response_data: Array[TwitchSendChatMessage.ResponseData] = await chat.send_message("Hello!", chat_message.message_id)
		if not response_data.is_empty() and response_data[0].is_sent:
			print("Replied successfully!")
		else:
			printerr("Failed to send reply. Reason: ", response_data[0].drop_reason if not response_data.is_empty() else "Unknown")
