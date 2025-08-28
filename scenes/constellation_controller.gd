extends Node2D

const TELESCOPE = preload("res://scenes/telescope.tscn")
const PREVIEW_ZOOM : float = 1.1
const POSTVIEW_ZOOM : float = 0.56

@export var preview_viewport : SubViewport
@export var preview_animations : AnimationPlayer
@export var preview_title: RichTextLabel
@export var preview_username: RichTextLabel
@export var preview_info: RichTextLabel
@export var preview_window: Sprite2D

@export var main_viewport : SubViewport
@export var main_window: Sprite2D
@export var main_animations : AnimationPlayer

signal display_end
signal telescope_freed

var telescope : Node2D
var displaying : bool = false
var buffer : Array[Star] = []
var big_mode : bool = false

var looping : bool = false
var miniplayer : bool = true
var show_new : bool = true

func _ready() -> void:
	Global.constellation_manager = self
	ControlPanel.button_pressed.connect(_on_control_button_pressed)
	if Global.simplify_constellations:
		#$SubViewport/Telescope.scale = Vector2.ONE * 
		preview_viewport.size.y = 1920.0

func _input(event: InputEvent) -> void:
	if Global.simplify_constellations and preview_viewport: 
		preview_viewport.push_input(event)
	
	if not Global.simplify_constellations and main_viewport:
		main_viewport.push_input(event)
	
	if Util.input_context != "default" : 
		return
	if event.is_action_pressed("constellation"):
		big_mode = not big_mode
		if big_mode:
			free_telescope()
			_create_telescope(false)
			preview_window.hide()
			main_window.show()
			main_animations.play("open")
		
		else:
			main_animations.play("close")
			big_mode = true
			await main_animations.animation_finished
			big_mode = false
			free_telescope()
			preview_window.show()
			main_window.hide()

func free_telescope():
	#if is_instance_valid(telescope): 
		#telescope.queue_free()
	#
	for child in main_viewport.get_children():
		child.queue_free()
	
	for child in preview_viewport.get_children():
		child.queue_free()
	
	telescope = null

func _on_control_button_pressed(data):
	match data:
		"toggle_auto_loop":
			looping = not looping
			prints("LOOP:", looping)
			if miniplayer:
				if looping and not displaying: 
					
					if not is_instance_valid(telescope):
						_create_telescope()
						preview_animations.play("show_bg")
						await Util.wait(Global.STARS_OPENING_ANIMATION_LENGTH)
					
					else:
						preview_animations.play("show_bg")
					
						
					telescope.start_loop()
				elif is_instance_valid(telescope): telescope.stop_loop()
		
		"toggle_miniplayer":
			miniplayer = not miniplayer
			prints("MINIPLAYER:", miniplayer)
			if not miniplayer:
				if is_instance_valid(telescope):
					if looping: 
						await telescope.stop_loop(true)
					
					if displaying:
						await display_end
					
					if not miniplayer:
						preview_animations.play("hide", 10.0)
						await preview_animations.animation_finished
				
				if not miniplayer:
					free_telescope()
				
			else:
				if is_instance_valid(telescope):
					free_telescope()
				
				if looping:
					_create_telescope()
					preview_animations.play("show_bg")
					await Util.wait(Global.STARS_OPENING_ANIMATION_LENGTH)
					if miniplayer: telescope.start_loop()
					
		"toggle_show_new":
			show_new = not show_new
			prints("SHOW NEW FOLLOWS:", show_new)
		
		
		
		"hide", "show", "hide_text", "show_text":
			preview_animations.play(data)

func _create_telescope(mini_ver : bool = true):
	Global.simplify_constellations = mini_ver
	Util.set_mute_bus("Constellation", mini_ver)
	var inst = TELESCOPE.instantiate()
	if mini_ver:
		inst.position = Vector2(960.0, 960.0)
		preview_viewport.add_child(inst)
		
	else:
		inst.position = Vector2(960.0, 540.0)
		main_viewport.add_child(inst)
	
	telescope = inst
	

func add_to_buffer(star : Star):
	if show_new:
		if miniplayer or big_mode:
			if not displaying:
				display_new_star(star)
			else:
				buffer.append(star)
		else:
			buffer.append(star)

func try_buffer() -> bool:
	if buffer.size() != 0 and (miniplayer or big_mode):
		if preview_animations.current_animation !=  "hide":  
			preview_animations.play("hide_text")
			if not big_mode: await preview_animations.animation_finished
		
		var data : Star = buffer.pop_front()
		displaying = false
		display_end.emit()
		display_new_star(data)
		return true
	return false

func display_new_star(star : Star):
	#print("a")
	if not miniplayer:
		print("miniplayer disabled, blocking display")
		return
		
	if displaying:
		printerr("trying to display a star while another is already being displayed!! aaaa dont do this!!")
		return
	
	displaying = true
	#print("b")
	if not big_mode:
		if not star.is_constellation_base:
			preview_title.text = "[wave amp=50.0]New Star Found!"
		else:
			preview_title.text = "[wave amp=50.0]New Constellation Found!"
		
		preview_username.text = "[tornado radius=4.0 freq=4.0][pulse freq=0.5 color=#dddddd ease=-2.0]" + star.username
		
		if not is_instance_valid(telescope): 
			#print("c1")
			_create_telescope()
			preview_animations.play("show")
			await Util.wait(Global.STARS_OPENING_ANIMATION_LENGTH)
		
		else:
			if not telescope.intro_finished:
				await Util.compound_signal([telescope.intro_finish, telescope_freed])
			await telescope.stop_loop(true)
			preview_animations.play("show_text")
		#print("d")
		#preview_animations.play("show")
		await telescope.stars.move_to_location(star.global_position[1], PREVIEW_ZOOM, true)
		#print("e")
		var tween : Tween = create_tween()
		tween.tween_property(star, "draw_amount", 1.0, 2.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		await tween.finished
		telescope.stars.camera.send_ping(false, false)
		tween = create_tween()
		tween.tween_property(telescope.stars, "zoom", POSTVIEW_ZOOM, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
		await tween.finished
		await Util.wait(telescope.LOOP_REST)
		#print("f")
		
		if await try_buffer(): return
		
		if looping: 
			#print("h?")
			preview_animations.play("hide_text")
			telescope.start_loop()
			
		else:
			#print("i?")
			preview_animations.play("hide")
			await preview_animations.animation_finished
			free_telescope()
			
			if await try_buffer(): return
			
	else:
		if looping and is_instance_valid(telescope):
			if not telescope.intro_finished:
				await Util.compound_signal([telescope.intro_finish, telescope_freed])
			
			await telescope.stop_loop(true)
			
			await telescope.stars.move_to_location(star.global_position[1], PREVIEW_ZOOM, true)
			
			var tween : Tween = create_tween()
			telescope.stars.camera.send_ping(false)
			tween.tween_property(star, "draw_amount", 1.0, 2.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
			await tween.finished
			await Util.wait(0.5)
			telescope.stars.camera.send_ping(false, false)
			tween = create_tween()
			tween.tween_property(telescope.stars, "zoom", POSTVIEW_ZOOM, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
			await tween.finished
			await Util.wait(telescope.LOOP_REST)
			#print("f")
			
			if await try_buffer(): return
			
			if looping:
				telescope.start_loop()
		
				
			
			
		else:
			buffer.append(star)
	
	displaying = false
	display_end.emit()
	

#const SPARKLE = preload("res://sparkle/sparkle1.tscn")
#const NUM_SPARKLES : int = 100
#func sparkle():
	#for i in NUM_SPARKLES:
		#var inst = SPARKLE.instantiate()
		#inst.position = preview_window.position
		#inst.dir =
