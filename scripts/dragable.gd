extends Area2D
class_name Dragable

@export var unique_id : String = ""
@export var visible_on_drag : CanvasItem
@export var custom_default_alpha : float = -1.0

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

const SCALE_INCREMENT = 0.1
const OPACITY_INCREMENT = 0.04
const ROTATION_INCREMENT = 0.1

var parent : CanvasItem
var selected : bool = false

var initial_mouse_position : Vector2

var initial_parent_position : Vector2
var initial_parent_rotation : float
var initial_parent_scale : Vector2

var start_parent_position : Vector2
var start_parent_rotation : float
var start_parent_scale : Vector2
var start_parent_alpha : float

var mouse_in_area : bool = false
var is_rotating : bool = false 

var is_held_down : bool = false:
	set(val):
		
		if is_held_down and not val:
			save_data()
		
		is_held_down = val
		is_rotating = false

func _ready() -> void:
	
	parent = get_parent()
	assert(unique_id != "", "Please set the id of the dragable modifier for " + parent.name)
	assert(parent is Node2D or parent is Control, "Dragable only works for node2Ds and controls")
	
	start_parent_alpha = parent.modulate.a if custom_default_alpha == -1.0 else custom_default_alpha
	start_parent_position = parent.position
	start_parent_rotation = parent.rotation
	start_parent_scale = parent.scale
	
	var info : Array = File.load_var("position_" + unique_id, [parent.position, parent.scale, parent.modulate.a])
	parent.position = info[0]
	parent.scale = info[1]
	parent.modulate.a = info[2]
	
	

func _process(delta: float) -> void:
	if Input.is_action_pressed("select_object") and not is_held_down and mouse_in_area and not Global.dragable_held:
		Global.dragable_held = true
		is_held_down = true
		initial_mouse_position = get_global_mouse_position()
		initial_parent_position = parent.position
		initial_parent_rotation = parent.rotation
		initial_parent_scale = parent.scale
		
	elif not Input.is_action_pressed("select_object"):
		is_held_down = false
		Global.dragable_held = false
	
	if is_held_down:
		#if not is_rotating:
			#parent.rotation = initial_parent_rotation + Util.breathe(0.5, PI/32.0)
		
		parent.position = initial_parent_position + get_global_mouse_position() - initial_mouse_position
		
		var offset : Vector2 = parent.global_position - collision_shape.global_position
		parent.global_position.x = offset.x + clamp(collision_shape.global_position.x, 0.0, DisplayServer.window_get_size().x) 
		parent.global_position.y = offset.y + clamp(collision_shape.global_position.y, 0.0, DisplayServer.window_get_size().y)
		if visible_on_drag != null:
			visible_on_drag.show()
	
	elif visible_on_drag != null:
		visible_on_drag.visible = mouse_in_area
	

func reset_to_start():
	parent.modulate.a = start_parent_alpha
	parent.position = start_parent_position
	prints(parent.name, parent.rotation, start_parent_rotation)
	parent.rotation = start_parent_rotation
	prints("A", parent.name, parent.rotation, start_parent_rotation)
	parent.scale = start_parent_scale
	is_held_down = false
	save_data()

func save_data():
	if not is_rotating: 
		parent.rotation = initial_parent_rotation
	
	File.save_var("position_" + unique_id, [parent.position, parent.scale, parent.modulate.a])

func _input(event: InputEvent) -> void:
	if is_held_down:
		if event.is_action_pressed("increase_opacity"):
			parent.modulate.a += OPACITY_INCREMENT
		
		elif event.is_action_pressed("decrease_opacity"):
			parent.modulate.a -= OPACITY_INCREMENT
		
		elif event.is_action_pressed("rotate_cw"):
			is_rotating = true
			parent.rotation += ROTATION_INCREMENT
		
		elif event.is_action_pressed("rotate_ccw"):
			is_rotating = true
			parent.rotation -= ROTATION_INCREMENT
		
		elif event.is_action_pressed("zoom_out"):
			parent.scale *= 1.0 + SCALE_INCREMENT
			
		elif event.is_action_pressed("zoom_in"):
			parent.scale /= 1.0 + SCALE_INCREMENT
		
		elif event.is_action_pressed("cancel_move"):
			parent.scale = initial_parent_scale
			parent.position = initial_parent_position
			parent.rotation = initial_parent_rotation
			is_held_down = false
		
		elif event.is_action_pressed("reset_object"):
			reset_to_start()
		
	if event.is_action_pressed("reset_all"):
		reset_to_start()

func _on_mouse_entered() -> void:
	mouse_in_area = true


func _on_mouse_exited() -> void:
	mouse_in_area = false
