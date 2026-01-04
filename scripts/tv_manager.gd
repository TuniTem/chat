extends Node2D
 
const TV_SCENE = preload("res://scenes/shoutout_tv.tscn")

var current_scene : Sprite2D

func _ready() -> void:
	Global.tv_manager = self
	Net.button_pressed.connect(_on_control_button_press)

func show_tv():
	if not is_instance_valid(current_scene):
		var inst = TV_SCENE.instantiate()
		add_child(inst)
		current_scene = inst
	else:
		current_scene.get_node("SubViewport/AnimationPlayer").play("Appear")
	
	await Util.wait(5.0)
	hide_tv()

func hide_tv():
	if is_instance_valid(current_scene):
		current_scene.get_node("SubViewport/AnimationPlayer").play("Disappear")


func _on_control_button_press(data):
	if data == "tv":
		if is_instance_valid(current_scene):
			if current_scene.get_node("SubViewport/AnimationPlayer").current_animation != "Disappear":
				current_scene.get_node("SubViewport/AnimationPlayer").play("Disappear")
			else:
				current_scene.queue_free()
