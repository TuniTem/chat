extends VBoxContainer
const CHAT_BUBBLE = preload("res://scenes/box.tscn")


func _ready() -> void:
	for child in get_children():
		child.queue_free()

func chat(message : TwitchChatMessage):
	var loaded_emotes : Dictionary[TwitchEmoteDefinition, SpriteFrames] = await message.load_emotes_from_fragment(Global.media_loader, TwitchEmoteDefinition.SCALE_3)
	var inst = CHAT_BUBBLE.instantiate()
	inst.text = message.message.fragments
	inst.user = message.chatter_user_name
	inst.user_id = message.chatter_user_id
	inst.badges = message.badges
	for key : TwitchEmoteDefinition in loaded_emotes.keys():
		inst.emotes[key.id] = loaded_emotes[key]
		
	inst.color = Color(message.get_color("#8c6da7"))
	add_child(inst)
