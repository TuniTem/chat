extends Node

@export var default_group : String
var animation_groups : Dictionary[String, Array] = {
	"Idle": [
		"AntenaeIdle",
		"BodyFloat",
		"CloakIdle",
		"EarsIdle",
		"FeetIdle",
		"HandsIdle",
		"HeadIdle",
		"FireIdle",
		"RotateLoad"
	]
}

var animation_players : Array[AnimationPlayer]

func _ready() -> void:
	print(default_group)
	print("a")
	if animation_groups.has(default_group):
		print("b")
		for animation_player_name : String in animation_groups[default_group]:
			print("c")
			play_animation(animation_player_name)

func play_animation(anim : String):
	print("d")
	var player : AnimationPlayer = get_node(anim)
	print("e ", player.name)
	if player:
		print("f ", player.name)
		player.play()

func stop_animation(anim : String):
	var player : AnimationPlayer = get_node(anim)
	if player:
		player.stop()
