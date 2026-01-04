extends Node3D

@export var eyes : Mesh
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

@export var eyebrows : Mesh
const eyebrows_expressions : Dictionary = {
	"angy" : preload("res://art/3D/Onira/v0.92/Face/Eyebrows/Angy.png"),
	"awh" : preload("res://art/3D/Onira/v0.92/Face/Eyebrows/awh.png"),
	"neutral" : preload("res://art/3D/Onira/v0.92/Face/Eyebrows/Neutral.png")
}

@export var mouth : Mesh
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

@export var emote : Mesh
const emote_expressions : Dictionary = {
	"!!" : preload("res://art/3D/Onira/v0.92/Face/Emote/!!.png"),
	"anger" : preload("res://art/3D/Onira/v0.92/Face/Emote/Anger.png"),
	"zzz" : preload("res://art/3D/Onira/v0.92/Face/Emote/zzz.png")
}

@export var eye_sparkles : Mesh
@export var moon_sparkles : Mesh


#const emotions : Dictionary = {
	#"rage" : {"eyes" : "omg", "eyebrows" : "angy", "mouth" : "woah", "emote" : "anger"},
	#"sad" : {"eyes" : "pls", "eyebrows" : "awh", "mouth" : "frown", "emote" : "none"},
	#"cry" : {"eyes" : "cry", "eyebrows" : "awh", "mouth" : "frown", "emote" : "none"},
	#"hurt" : {"eyes" : "omg", "eyebrows" : "awh", "mouth" : "frown", "emote" : "none"},
	#"hurt" : {"eyes" : "pls", "eyebrows" : "awh", "mouth" : "frown", "emote" : "none"},
#}
