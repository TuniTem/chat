extends Control

const PREFIX : String = "[tornado radius=5.0 freq=2.0 connected=1]"
const TEXT_GROUPS : Dictionary = {
	"brb": "BRB...",
	"starting" : "Starting\nSoon 💜",
	"ending" : "Ending\nSoon ;~;"
}

var text_group : String = "brb"
@onready var label: RichTextLabel = $Label


func _ready() -> void:
	label.text = PREFIX + TEXT_GROUPS[Global.screen_id]
