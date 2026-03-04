extends Node3D

# emote expression constants
@export var eyes_material : StandardMaterial3D
const eyes_expressions : Dictionary = {
	"blink" : preload("res://art/3D/Onira/v0.92/Face/Eyes/blink.png"),
	"closed" : preload("res://art/3D/Onira/v0.92/Face/Eyes/closed.png"),
	"cry" : preload("res://art/3D/Onira/v0.92/Face/Eyes/cry.png"),
	"normal": preload("res://art/3D/Onira/v0.92/Face/Eyes/eyes2.png"),
	"happy" : preload("res://art/3D/Onira/v0.92/Face/Eyes/Happy.png"),
	"omg" : preload("res://art/3D/Onira/v0.92/Face/Eyes/omg.png"),
	"pls" : preload("res://art/3D/Onira/v0.92/Face/Eyes/pls.png"),
	"why" : preload("res://art/3D/Onira/v0.92/Face/Eyes/why.png")
} 

@export var eyebrows_material : StandardMaterial3D
const eyebrows_expressions : Dictionary = {
	"angy" : preload("res://art/3D/Onira/v0.92/Face/Eyebrows/Angy.png"),
	"awh" : preload("res://art/3D/Onira/v0.92/Face/Eyebrows/awh.png"),
	"neutral" : preload("res://art/3D/Onira/v0.92/Face/Eyebrows/Neutral.png")
}

@export var mouth_material : StandardMaterial3D
const mouth_expressions : Dictionary = {
	"colond" : preload("res://art/3D/Onira/v0.92/Face/Mouth/ColonD.png"),
	"colonthree" : preload("res://art/3D/Onira/v0.92/Face/Mouth/colonthree.png"),
	"frown" : preload("res://art/3D/Onira/v0.92/Face/Mouth/frown.png"),
	"pout" : preload("res://art/3D/Onira/v0.92/Face/Mouth/pout.png"),
	"smile" : preload("res://art/3D/Onira/v0.92/Face/Mouth/Smile2.png"),
	"tounge" : preload("res://art/3D/Onira/v0.92/Face/Mouth/Tounge.png"),
	"v" : preload("res://art/3D/Onira/v0.92/Face/Mouth/v.png"),
	"woah" : preload("res://art/3D/Onira/v0.92/Face/Mouth/woah.png")
}

@export var emote_material : StandardMaterial3D
@export var emote_mesh: MeshInstance3D
const emote_expressions : Dictionary = {
	"!!" : preload("res://art/3D/Onira/v0.92/Face/Emote/!!.png"),
	"anger" : preload("res://art/3D/Onira/v0.92/Face/Emote/Anger.png"),
	"zzz" : preload("res://art/3D/Onira/v0.92/Face/Emote/zzz.png"),
	"none" : preload("res://art/3D/Onira/v0.92/Face/Emote/Transparent256x256.png")
}

@export var third_eye : AnimatedSprite3D
@onready var third_eye_sparkles: Array[AnimatedSprite3D] = [%Sparkles3, %Sparkles4]

const emotions : Dictionary = {
	"neutral" :  {"eyes" : "omg", "eyebrows" : "angy", "mouth" : "woah", "emote" : "anger", "third_eye" : true},# {"eyes" : "normal", "eyebrows" : "neutral", "mouth" : "smile", "emote" : "none", "third_eye" : false},
	"hurt" : {"eyes" : "omg", "eyebrows" : "awh", "mouth" : "frown", "emote" : "none", "third_eye" : false},
	"supprised" : {"eyes" : "pls", "eyebrows" : "neutral", "mouth" : "woah", "emote" : "!!", "third_eye" : false},
	#"silly" : {"eyes" : "omg", "eyebrows" : "neutral", "mouth" : "tounge", "emote" : "none", "third_eye" : false},
	"rage" : {"eyes" : "omg", "eyebrows" : "angy", "mouth" : "woah", "emote" : "anger", "third_eye" : true},
	"sad" : {"eyes" : "pls", "eyebrows" : "awh", "mouth" : "frown", "emote" : "none", "third_eye" : true},
	#"cry" : {"eyes" : "cry", "eyebrows" : "awh", "mouth" : "frown", "emote" : "none", "third_eye" : true},
	#"yay" : {"eyes" : "happy", "eyebrows" : "neutral", "mouth" : "colond", "emote" : "none", "third_eye" : true},
	"asleep" : {"eyes" : "closed", "eyebrows" : "neutral", "mouth" : "colonthree", "emote" : "zzz", "third_eye" : true}
}

# emotion
var current_emotion : String = "neutral"

# blinking
const BLINK_LOOP_INTERVAL_RANGE = [2.0, 10.0]
const DISABLE_BLINK = ["blink", "closed"] #"happy", "omg"

var blinking = false
var enable_blink_loop : bool = false
var sparkle_max_scale : Array[Vector3]

func _ready() -> void:
	emote(current_emotion)
	start_blink_loop()
	third_eye.play("close")
	for sparkle in third_eye_sparkles:
		sparkle_max_scale.append(sparkle.scale)
	
	while true:
		for expression : String in emotions.keys():
			await Util.wait(85.0)
			emote(expression)
	

func emote(emotion : String):
	current_emotion = emotion
	eyes_material.albedo_texture = eyes_expressions["blink"]
	await Util.wait(0.1)
	if not blinking: eyes_material.albedo_texture = eyes_expressions[emotions[emotion]["eyes"]]
	eyebrows_material.albedo_texture = eyebrows_expressions[emotions[emotion]["eyebrows"]]
	mouth_material.albedo_texture = mouth_expressions[emotions[emotion]["mouth"]]
	emote_material.albedo_texture = emote_expressions[emotions[emotion]["emote"]]
	if emotions[emotion]["emote"] != "none":
		emote_mesh.scale = Vector3.ZERO
		Util.tween_value(emote_mesh, "scale", Vector3.ONE, 0.4, Tween.EaseType.EASE_OUT, Tween.TransitionType.TRANS_BACK)
	
	var open : bool = emotions[current_emotion]["third_eye"]
	
	if open:
		if third_eye.animation != "open" and third_eye.animation != "idle": 
			open_third_eye()
	
	elif third_eye.animation != "close": 
		close_third_eye()
		
	

func start_blink_loop():
	enable_blink_loop = true
	while enable_blink_loop:
		if emotions[current_emotion]["eyes"] not in DISABLE_BLINK: blink()
		await Util.wait(Util.randf_array(BLINK_LOOP_INTERVAL_RANGE))

func stop_blink_loop():
	enable_blink_loop

func blink(time : float = 0.1):
	eyes_material.albedo_texture = eyes_expressions["blink"]
	blinking = true
	await Util.wait(time)
	eyes_material.albedo_texture = eyes_expressions[emotions[current_emotion]["eyes"]]
	blinking = false

func open_third_eye():
	third_eye.play("open")
	for i in range(third_eye_sparkles.size()):
		var sparkle : AnimatedSprite3D = third_eye_sparkles[i]
		sparkle.show()
		sparkle.scale.x = 0.0
		sparkle.scale.y = sparkle_max_scale[i].y
		Util.tween_value(sparkle, "scale:x", sparkle_max_scale[i].x, 0.25, Tween.EaseType.EASE_OUT, Tween.TransitionType.TRANS_BACK, 0.85)
	await third_eye.animation_finished
	third_eye.play("idle")
	

func close_third_eye():
	if third_eye.animation == "open":
		await third_eye.animation_finished
		await get_tree().process_frame
		await get_tree().process_frame
	
	third_eye.play("close")
	for i in range(third_eye_sparkles.size()):
		var sparkle : AnimatedSprite3D = third_eye_sparkles[i]
		Util.tween_value(sparkle, "scale:y", 0.0, 0.25, Tween.EaseType.EASE_IN, Tween.TransitionType.TRANS_SINE, 0.5).finished
	
	#await Util.wait(0.25)
	#for sparkle in third_eye_sparkles:
		#sparkle.hide()
