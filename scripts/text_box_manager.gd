extends VBoxContainer

const DEFAULT_LENGTH = 850
const TEST_INTERVAL = 10
const MAX_TEXT_LINES = 15
const PREFIX = "[pulse freq=0.5 color=#ffffff80 ease=-2.0]"

@export var animation: AnimationPlayer
@export var text_box: RichTextLabel
@export var user_label: RichTextLabel
@export var text_box_pannel : Panel

var USEABLE_CHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-=!@#$%^&*_+()[]{}|\\;:\"\'<>?,./ "
var text : String  = "aaaaaaaasoidujfghbnosierdungosirengoisurengoiuenr"
var color : Color = Color("#8c6da7")
var user : String = "Unknown"
var falling : bool = false
var big_emote : bool = false
var sprite_effect = SpriteFrameEffect.new()

func _ready():
	color = Color("8c6da7")
	animation.play("chat")
	GifImporterImagemagick
	text_box.install_effect(sprite_effect)
	text_box.text = sprite_effect.prepare_message(PREFIX + replace_emotes(text) + " ", text_box)
	#text_box.text = sprite_effect.prepare_message("[sprite id=1]res://art/runtime_emotes/AlienDance.gif[/sprite]", text_box)
	user_label.text = filter(user)
	
	user_label.modulate = color * Color(1.0, 1.0, 1.0, 0.0)
	create_tween().tween_property(user_label, "modulate", color, 0.1)
	call_deferred("trunc_text")
	free_in_time(5.0)
	#for emoji in Global.emojis: 
		#USEABLE_CHARS += emoji[1]

func trunc_text():
	for i in 25:
		print(user_label.get_line_count())
		if user_label.get_line_count() > 1:
			user_label.text = user_label.text.left(-2)
			user_label.text += "…"
		else:
			break

const SMALL_EMOTE_SIZE = 32
const BIG_EMOTE_SIZE = 112

func replace_emotes(str : String):
	var words : Array = str.split(" ")
	for word in words:
		if Global.emote_exists(word):
			#text_box.add_image(ImageTexture.create_from_image(Image.load_from_file(Global.emotes[word])), 
				#0, 112, Color(1, 1, 1, 1), INLINE_ALIGNMENT_TO_BASELINE, Rect2(), word)
			if words.size() == 1: # big emote
				str = str.replace(word, "[img height=" + str(BIG_EMOTE_SIZE) + "]" + Global.emotes[word] + "[/img]")
				text_box_pannel.hide()
				big_emote = true
			else:
				str = str.replace(word, "[img height=" + str(SMALL_EMOTE_SIZE) + "]" + Global.emotes[word] + "[/img]")
			print(str)
	
	return str

func fall():
	if not falling:
		falling = true
		var angle = randf_range(-90, 90)
		create_tween().tween_property(user_label, "rotation_degrees", angle, 8.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		create_tween().tween_property(user_label, "position:y", -5000, 8.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
		create_tween().tween_property(user_label, "modulate", Color(1.0, 1.0, 1.0, 0.0), 6.0)
		
		create_tween().tween_property(text_box, "modulate", Color(10.0, 10.0, 10.0, 1.0), 0.1)
		$Shine.play(0.1)
		sparkle()
		await get_tree().create_timer(0.3).timeout
		create_tween().tween_property(text_box, "rotation_degrees", angle, 8.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		create_tween().tween_property(text_box, "position:y", -5000, 8.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
		create_tween().tween_property(text_box, "modulate", Color(1.0, 1.0, 1.0, 0.0), 6.0).set_ease(Tween.EASE_OUT)
		await get_tree().create_timer(8.0).timeout
		queue_free()


const SPARKLE_1 = preload("res://sparkle/sparkle1.tscn")
const NUM_SPARKLES = 50
func sparkle():
	var bounds : Rect2 = text_box.get_global_rect()
	if big_emote: 
		bounds.size = Vector2.ONE * (BIG_EMOTE_SIZE - BIG_EMOTE_SIZE * 0.2)
		bounds.position += Vector2.ONE * (BIG_EMOTE_SIZE * 0.1)
		
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
	$Popup.play()
	await get_tree().create_timer(time).timeout
	fall()
