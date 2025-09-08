extends VBoxContainer
const CHAT_BUBBLE = preload("res://scenes/box.tscn")


func _ready() -> void:
	for child in get_children():
		child.queue_free()

func chat(message : TwitchChatMessage):
	var inst = CHAT_BUBBLE.instantiate()
	inst.text = message.message.text
	inst.user = message.chatter_user_name
	inst.user_id = message.chatter_user_id
	inst.badges = message.badges
	inst.color = Color(message.get_color("#8c6da7"))
	add_child(inst)
