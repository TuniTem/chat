extends Control

const HOLD_TIME : float = 60.0
const GAP_TIME : float = 5.0
const REPEAT_AVOIDENCE : int = 3

@export var messages : Array[String]

@onready var label: RichTextLabel = $Label
@onready var animations: AnimationPlayer = $Animations

var running : bool = false
var history : Array[int]
var enabled : bool = false:
	set(val):
		enabled = val
		if val: start_loop()


func _ready() -> void:
	Net.button_pressed.connect(_on_control_button_pressed)
	hide()

func start_loop():
	if running : return
	show()
	running = true
	while enabled:
		var picked : int = randi_range(0, messages.size() - 1)
		for i in 100:
			if not picked in history:
				break
			
			picked = randi_range(0, messages.size() - 1)
		
		history.append(picked)
		if history.size() > REPEAT_AVOIDENCE:
			history.pop_front()
		
		label.text = messages[picked]
		animations.play("fade_in")
		await animations.animation_finished
		await Util.wait(HOLD_TIME)
		animations.play("fade_out")
		await animations.animation_finished
		await Util.wait(GAP_TIME)
		
	hide()
	running = false

func _on_control_button_pressed(data):
	if data == "promo":
		enabled = not enabled
