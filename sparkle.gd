extends Node2D

@onready var animation_player: AnimationPlayer = $Sparkle/AnimationPlayer

const SCALE_FACTOR = 1.0
const SLOW_SPEED = 3.0
const TEXTURES : Array = [
	preload("res://art/star/star2.png"),
	preload("res://art/star/star2.png"),
	preload("res://art/star/star7.png"),
	preload("res://art/star/star3.png"),
	preload("res://art/star/star6.png"),
	preload("res://art/star/star4.png"),
	preload("res://art/star/star4.png")
]

var center : Vector2



func _ready() -> void:
	$Sparkle.texture = TEXTURES.pick_random()
	scale = Vector2.ONE * randf_range(0.2, 1.0)
	animation_player.speed_scale = randf_range(1.5, 2.5)

func _process(delta: float) -> void:
	position += -position.direction_to(center).normalized() * scale / SLOW_SPEED
	scale *= 1.0-SCALE_FACTOR*delta*SLOW_SPEED/2.0
	if scale.x < 0.05: 
		free()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animation_player.speed_scale = randf_range(0.2, 2.5)
	animation_player.play("sparkle")
	#print(name)
