extends Node

signal button_pressed(data)

func _ready() -> void:
	print("Creating ENet server...")
	var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	peer.create_server(25565, 2)
	get_tree().set_multiplayer(SceneMultiplayer.new(), self.get_path())
	multiplayer.multiplayer_peer = peer
	print("ENet server created!")


@rpc("any_peer", "reliable", "call_remote")
func send_control_press(data : Variant):
	button_pressed.emit(data)
	if data == "test":
		print_rich("[color=yellow]Test recived!")
