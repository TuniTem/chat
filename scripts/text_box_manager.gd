extends VBoxContainer

const DEFAULT_LENGTH = 850
const TEST_INTERVAL = 10
const MAX_TEXT_LINES = 15
const BIG_EMOTE_COUNT_LIMIT : int = 3
const BIG_EMOTE_SIZE : float = 4.0

const PREFIX = "[pulse freq=0.5 color=#ffffff80 ease=-2.0]"
const STAR_TEXTURES : Dictionary[Star.Colors, Texture2D] = {
	Star.Colors.PURPLE : preload("res://art/NewStars/Soft/Soft1001.png"),
	Star.Colors.PINK : preload("res://art/NewStars/Soft/Soft1000.png"),
	Star.Colors.YELLOW : preload("res://art/NewStars/Soft/Soft1002.png"),
	Star.Colors.WHITE : preload("res://art/NewStars/Soft/Soft1003.png")
}

@export var animation: AnimationPlayer
@export var text_box: RichTextLabel
@export var user_label: RichTextLabel
@export var user_label_container: HBoxContainer
@export var text_box_pannel : Panel
@export var text_box_outline : Panel
@export var star: TextureRect

@export var mod_icon: Control
@export var broadcaster_icon: Control

@export var mod_color : Color

var USEABLE_CHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-=!@#$%^&*_+()[]{}|\\;:\"\'<>?,./ "
var emotes : Dictionary[String, SpriteFrames] 
var _emote_internal_ids : Dictionary[String, SpriteFrames]
var text : Array[TwitchChatMessage.Fragment] = []
var color : Color = Color("#8c6da7")
var user : String = "Unknown"
var user_id : String = "-1"
var badges : Array[TwitchChatMessage.Badge]
var falling : bool = false
var big_emote : bool = false
var sprite_effect = SpriteFrameEffect.new()
var emote_size_mult : float = 1.0

func _ready():
	hide()
	var replace_emotes_result : String = await replace_emotes(text)
	text_box.text = sprite_effect.prepare_message(PREFIX + replace_emotes_result + " ", text_box, _emote_internal_ids, emote_size_mult)
	show()
	color = Color("8c6da7")
	animation.play("chat")
	text_box.install_effect(sprite_effect)
	#text_box.text = sprite_effect.prepare_message("[sprite id=1]res://art/runtime_emotes/AlienDance.gif[/sprite]", text_box)
	user_label.text = filter(user)
	
	
	
	for badge : TwitchChatMessage.Badge in badges:
		match badge.set_id:
			"broadcaster":
				broadcaster_icon.show()
				color = mod_color
			
			"moderator":
				mod_icon.show()
				color = mod_color
	
	
	user_label.modulate = color * Color(1.0, 1.0, 1.0, 0.0)
	var user_star : Star = Global.get_user_star(user_id)
	if user_star: star.texture = STAR_TEXTURES[user_star.color]
	
	create_tween().tween_property(user_label, "modulate", color, 0.1)
	call_deferred("trunc_text")
	free_in_time(60.0)
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

#const SMALL_EMOTE_SIZE = 32
#const BIG_EMOTE_SIZE = 112

func replace_emotes(fragments : Array[TwitchChatMessage.Fragment]) -> String:
	var out : String = ""
	var uid_gen : UniqueIdentifierGenerator = UniqueIdentifierGenerator.new()
	var only_emotes : bool = true
	var emote_count : int = 0
	
	for fragment : TwitchChatMessage.Fragment in fragments:
		var sprite_frames : SpriteFrames
		match fragment.type:
			TwitchChatMessage.FragmentType.text, TwitchChatMessage.FragmentType.mention:
				out += fragment.text
				only_emotes = false
			
			TwitchChatMessage.FragmentType.cheermote:
				sprite_frames = await fragment.cheermote.get_sprite_frames(Global.media_loader, TwitchCheermoteDefinition.SCALE_3)
				emote_count += 1
			
			TwitchChatMessage.FragmentType.emote:
				emote_count += 1
				if emotes.has(fragment.emote.id):
					sprite_frames = emotes[fragment.emote.id]
				else:
					sprite_frames = await fragment.emote.get_sprite_frames(Global.media_loader, TwitchEmoteDefinition.SCALE_3)
		
		if sprite_frames:
			var id : String = str(uid_gen.create_unique_id())
			out += "[sprite id=" + id + "]" + id + "[/sprite]"
			_emote_internal_ids[id] = sprite_frames
	
	if only_emotes and emote_count <= BIG_EMOTE_COUNT_LIMIT:
		emote_size_mult = 1.0
		text_box_pannel.hide()
		text_box_outline.hide()
		big_emote = true
	else:
		emote_size_mult = 0.25
	
	
	
	return out
	
	
	
	
	
	#var words : Array = str.split(" ")
	#var replaces : Array[String]
	#for word in words:
		#if Global.emote_exists(word) and not replaces.has(word):
			#replaces.append(word)
			#if words.size() == 1: # big emote
				#str = str.replace(word, "[img height=" + str(BIG_EMOTE_SIZE) + "]" + Global.emotes[word] + "[/img]")
				#text_box_pannel.hide()
				#text_box_outline.hide()
				#big_emote = true
			#else:
				#str = str.replace(word, "[img height=" + str(SMALL_EMOTE_SIZE) + "]" + Global.emotes[word] + "[/img]")
			
			#text_box.add_image(ImageTexture.create_from_image(Image.load_from_file(Global.emotes[word])), 
				#0, 112, Color(1, 1, 1, 1), INLINE_ALIGNMENT_TO_BASELINE, Rect2(), word)
	#
	#return str

func fall():
	if not falling:
		falling = true
		var angle = randf_range(-90, 90)
		create_tween().tween_property(user_label_container, "rotation_degrees", angle, 8.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		create_tween().tween_property(user_label_container, "position:y", -5000, 8.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
		create_tween().tween_property(user_label_container, "modulate", Color(1.0, 1.0, 1.0, 0.0), 6.0)
		
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
	#var window_pos : Vector2 = Global.main.chat_window.position
	if big_emote: 
		bounds.size = Vector2.ONE * 32
		bounds.position += Vector2.ONE * 16
		
	for i in NUM_SPARKLES:
		var dir : Vector2 = Vector2.from_angle(randf_range(0, TAU))
		var edge = randi() % 4
		match edge:
			0: dir = Vector2(randf_range(bounds.position.x, bounds.position.x + bounds.size.x), bounds.position.y)
			1: dir = Vector2(bounds.position.x + bounds.size.x, randf_range(bounds.position.y, bounds.position.y + bounds.size.y))
			2: dir = Vector2(randf_range(bounds.position.x, bounds.position.x + bounds.size.x), bounds.position.y + bounds.size.y)
			3: dir = Vector2(bounds.position.x, randf_range(bounds.position.y, bounds.position.y + bounds.size.y))
		var inst = SPARKLE_1.instantiate()
		inst.position = dir# + window_pos
		inst.center = bounds.position + bounds.size/2# + window_pos
		Global.sparkle_holder.add_child(inst)
	

func filter(_text : String):
	var out = ""
	for char in _text:
		if char in USEABLE_CHARS:
			out += char
	
	return out

func free_in_time(time : float):
	$Popup.play()
	await get_tree().create_timer(time).timeout
	fall()
