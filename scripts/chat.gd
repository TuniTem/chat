extends VBoxContainer
const CHAT_BUBBLE = preload("res://scenes/box.tscn")

func _ready() -> void:
	for child in get_children():
		child.queue_free()

func chat(message : String, username : String, color : Color):
	var inst = CHAT_BUBBLE.instantiate()
	inst.text = message
	inst.user = username
	inst.color = color
	add_child(inst)
