extends VBoxContainer

const DEFAULT_LENGTH = 850
const TEST_INTERVAL = 10
const MAX_TEXT_LINES = 15

@export var animation: AnimationPlayer
@export var text_box: RichTextLabel
@export var user_label: Label

var USEABLE_CHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-=!@#$%^&*_+()[]{}|\\;:\"\'<>?,./ "
var text : String  = "aaaaaaaasoidujfghbnosierdungosirengoisurengoiuenr"
var color : Color = Color("#8c6da7")
var user : String = "Unknown"

func _ready():
	animation.play("chat")
	text_box.text = text
	user_label.text = user
	user_label.modulate = color * Color(1.0, 1.0, 1.0, 0.0)
	create_tween().tween_property(user_label, "modulate", color, 1.0)
	
	call_deferred("find_minimum_border_size")
	free_in_time(5.0)
	#for emoji in Global.emojis: 
		#USEABLE_CHARS += emoji[1]
	
	
	
var prev_input : String
#func _process(delta: float):
	#call_deferred("find_minimum_border_size")
	#if is_instance_valid(input):
		#if input.has_focus() and input.text != prev_input:
			#var carot_pos = input.get_caret_column()
			#input.text = filter(input.text)
			##if input.text.count(":") >= 2:
				##for emoji in Global.emojis:
					##if emoji[0] in input.text:
						##input.text = input.text.replace(emoji[0], emoji[1]) 
			#
			#if text_box.get_line_count() > MAX_TEXT_LINES:
				#input.text = input.text.erase(len(input.text)-1)
			#input.set_caret_column(carot_pos)
			#text_box.text = input.text
			#call_deferred("find_minimum_border_size")
		#text_box.anchor_top = 0.0
		#prev_input = input.text


func filter(text : String):
	var out = ""
	for char in text:
		if char in USEABLE_CHARS:
			out += char
	
	return out

func get_num_lines():
	return text_box.get_line_count()

func free_in_time(time : float):
	await get_tree().create_timer(time).timeout
	#animation.play("float")
	var angle = randf_range(-90, 90)
	create_tween().tween_property(text_box, "rotation_degrees", angle, 8.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	create_tween().tween_property(text_box, "position:y", -5000, 8.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	create_tween().tween_property(user_label, "rotation_degrees", angle, 8.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	create_tween().tween_property(user_label, "position:y", -5000, 8.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	
	await get_tree().create_timer(8.0).timeout
	queue_free()
	

func find_minimum_border_size():
	text_box.offset_right = DEFAULT_LENGTH
	#text_box.offset_top = 665.0
	#text_box.offset_bottom = 665.0
	if text_box.get_line_count() == 1:
		var good_line_size = DEFAULT_LENGTH
		for test_size in range(DEFAULT_LENGTH, int(text_box.custom_minimum_size.x), -TEST_INTERVAL):
			text_box.offset_right = test_size
			if text_box.get_line_count() == 2: break
			else: good_line_size = test_size
		
		text_box.offset_right = good_line_size
		call_deferred("fix_weird_ahh_bug")
	
	print(Engine.get_frames_drawn())
	

func fix_weird_ahh_bug(): text_box.offset_top = 600
