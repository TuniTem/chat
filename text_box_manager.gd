extends VBoxContainer

const DEFAULT_LENGTH = 850
const TEST_INTERVAL = 10
const MAX_TEXT_LINES = 15
const PREFIX = "[pulse freq=0.5 color=#ffffff80 ease=-2.0]"

@export var animation: AnimationPlayer
@export var text_box: RichTextLabel
@export var user_label: RichTextLabel

var USEABLE_CHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-=!@#$%^&*_+()[]{}|\\;:\"\'<>?,./ "
var text : String  = "aaaaaaaasoidujfghbnosierdungosirengoisurengoiuenr"
var color : Color = Color("#8c6da7")
var user : String = "Unknown"
var falling : bool = false

func _ready():
	
	color = Color("8c6da7")
	animation.play("chat")
	text_box.text = PREFIX + filter(text)
	user_label.text = filter(user)
	user_label.modulate = color * Color(1.0, 1.0, 1.0, 0.0)
	create_tween().tween_property(user_label, "modulate", color, 1.0)
	#call_deferred("find_minimum_border_size")
	free_in_time(5.0)
	#for emoji in Global.emojis: 
		#USEABLE_CHARS += emoji[1]

func fall():
	if not falling:
		falling = true
		var angle = randf_range(-90, 90)
		create_tween().tween_property(user_label, "rotation_degrees", angle, 8.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		create_tween().tween_property(user_label, "position:y", -5000, 8.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
		create_tween().tween_property(user_label, "modulate", Color(1.0, 1.0, 1.0, 0.0), 6.0)
		create_tween().tween_property(text_box, "modulate", Color(10.0, 10.0, 10.0, 1.0), 0.1)
		sparkle()
		await get_tree().create_timer(0.3).timeout
		create_tween().tween_property(text_box, "rotation_degrees", angle, 8.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		create_tween().tween_property(text_box, "position:y", -5000, 8.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
		create_tween().tween_property(text_box, "modulate", Color(1.0, 1.0, 1.0, 0.0), 6.0).set_ease(Tween.EASE_OUT)
		await get_tree().create_timer(8.0).timeout
		queue_free()


@onready var sparkle_holder: Node2D = $SparkleHolder
const SPARKLE_1 = preload("res://sparkle/sparkle1.tscn")
const NUM_SPARKLES = 50
func sparkle():
	var bounds : Rect2 = text_box.get_global_rect()
	for i in NUM_SPARKLES:
		var dir : Vector2 = Vector2.from_angle(randf_range(0, TAU))
		var edge = randi() % 4
		match edge:
			0: dir = Vector2(randf_range(bounds.position.x, bounds.position.x + bounds.size.x), bounds.position.y)
			1: dir = Vector2(bounds.position.x + bounds.size.x, randf_range(bounds.position.y, bounds.position.y + bounds.size.y))
			2: dir = Vector2(randf_range(bounds.position.x, bounds.position.x + bounds.size.x), bounds.position.y + bounds.size.y)
			3: dir = Vector2(bounds.position.x, randf_range(bounds.position.y, bounds.position.y + bounds.size.y))
		var inst = SPARKLE_1.instantiate()
		inst.position = dir
		inst.center = bounds.position + bounds.size/2
		Global.sparkle_holder.add_child(inst)
	

func filter(text : String):
	var out = ""
	for char in text:
		if char in USEABLE_CHARS:
			out += char
	
	return out

func free_in_time(time : float):

	await get_tree().create_timer(time).timeout
	fall()
