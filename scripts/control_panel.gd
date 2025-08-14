extends Window

const CONTROL_BUTTON = preload("res://scenes/control_button.tscn")

@onready var playlists: HBoxContainer = %Playlists

signal button_pressed(data)

func _ready() -> void:
	update_playlists()

func update_playlists():
	for playlist : String in Music.playlists.keys():
		var inst = CONTROL_BUTTON.instantiate()
		inst.text = playlist.capitalize()
		inst.data = playlist
		playlists.add_child(inst)
