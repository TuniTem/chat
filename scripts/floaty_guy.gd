extends AnimatedSprite2D

const SPEED_VARIATION = [10.0, 20.0]
const ZOOM_RANGE : Array[float] = [1.1, 10.0]
const BOX_SIZE : float = 32
const BOX_OFFSET : Vector2 = Vector2(0.0, 0)

const ANIMATIONS : Dictionary[String, SpriteFrames] = {
	"jules" : preload("res://art/anims/constellation_tres/jules.tres")
}

@onready var fade: AnimationPlayer = $Fade

var end_pos : Vector2
var speed : float = SPEED_VARIATION[0]
var dir : Vector2
var fade_triggered : bool = false
var character : String = ""
var POI_id : int = -1

func _ready() -> void:
	speed = randf_range(SPEED_VARIATION[0], SPEED_VARIATION[1])
	dir = position.direction_to(end_pos)
	character = ANIMATIONS.keys().pick_random()
	sprite_frames = ANIMATIONS[character]
	frame = randi_range(0 , sprite_frames.get_frame_count("default") - 1)
	rotation = randf_range(0.0, TAU)
	
	match character:
		"jules":
			POI_id = Global.add_POI(
				"unknown_object." + str(randi_range(100, 999)),
				"Jules",
				"lost",
				"???",
				"A fellow dreamer, they found their way here... somehow? They look lost.",
				position + BOX_OFFSET,
				ZOOM_RANGE,
				Vector2.ONE * BOX_SIZE,
				[
					["abstracted", "true"], 
					["lat", position.y * Global.LOCATION_MULTIPLIER], 
					["lgt", position.x * Global.LOCATION_MULTIPLIER]
				], 
				-2, false, true
			)
	
	

var prev_distance : float = INF
func _process(delta: float) -> void:
	position += dir * speed * delta
	if position.distance_to(end_pos) > prev_distance and not fade_triggered:
		fade_triggered = true
		fade.play("out")
		await fade.animation_finished
		Global.remove_POI(POI_id)
		queue_free()
	
	prev_distance = position.distance_to(end_pos)
	
	Global.update_POI(POI_id, "location", position + BOX_OFFSET)
	Global.update_POI(POI_id, "extra_info", [["abstracted", "true"], ["lat", position.y * Global.LOCATION_MULTIPLIER], ["lgt", position.x * Global.LOCATION_MULTIPLIER]])
