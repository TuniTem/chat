extends AnimatedSprite2D

const SPEED_VARIATION = [30.0, 60.0]
const ANIMATIONS : Array[SpriteFrames] = [
	preload("res://art/anims/constellation_tres/jules.tres")
]

@onready var fade: AnimationPlayer = $Fade

var end_pos : Vector2
var speed : float = SPEED_VARIATION[0]
var dir : Vector2
var fade_triggered : bool = false

func _ready() -> void:
	speed = randf_range(SPEED_VARIATION[0], SPEED_VARIATION[1])
	dir = position.direction_to(end_pos)
	sprite_frames = ANIMATIONS.pick_random()
	frame = randi_range(0 , sprite_frames.get_frame_count("default") - 1)
	rotation = randf_range(0.0, TAU)

var prev_distance : float = INF
func _process(delta: float) -> void:
	position += dir * speed * delta
	if position.distance_to(end_pos) > prev_distance and not fade_triggered:
		fade_triggered = true
		fade.play("out")
		await fade.animation_finished
		queue_free()
	
	prev_distance = position.distance_to(end_pos)
