extends Node

signal button_pressed(data)

func _ready() -> void:
	print("Creating ENet server...")
	var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	peer.create_server(25567, 2)
	get_tree().set_multiplayer(SceneMultiplayer.new(), self.get_path())
	multiplayer.multiplayer_peer = peer
	multiplayer.multiplayer_peer.peer_connected.connect(_on_peer_connected)
	multiplayer.multiplayer_peer.peer_disconnected.connect(_on_peer_disconnected)
	print("ENet server created!")

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("debug"):
		#send_input("Tab", true)
		#call_deferred("send_input", "Tab", false)
	

func _on_peer_disconnected(id : int):
	print("Remote peer ", id, " disconnected")

func _on_peer_connected(id : int):
	print("Remote peer ", id, " connected")

@rpc("any_peer", "reliable", "call_remote")
func send_control_press(data : Variant):
	button_pressed.emit(data)
	if data == "connect_test":
		print_rich("[color=yellow]Test recived!")

@rpc("any_peer", "reliable", "call_remote")
func send_input(action_name : String, pressed : bool):
	prints("sim input :", action_name, pressed)
	var a = InputEventAction.new()
	a.action = action_name
	a.pressed = pressed
	Input.parse_input_event(a)
