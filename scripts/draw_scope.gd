@tool
extends Node2D

@export var COLOR : Color = Color(1.0, 1.0, 1.0, 1.0)
@export var RADIUS : float = 400
@export var MAX_LENGTH : float = 20
@export var ALL_MAX : bool = false
@export var LINE_MULT : Array[float] = [1.0, 0.75, 0.3]

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var num_lines : int = pow(2, LINE_MULT.size())
	var delta_angle : float = TAU / float(num_lines)
	var idx : Array = pattern(LINE_MULT.size())
	
	for i in range(num_lines):
		var theta : float = delta_angle * i
		draw_line(Vector2.from_angle(theta) * RADIUS, Vector2.from_angle(theta) * (RADIUS - MAX_LENGTH * LINE_MULT[idx[i]]), COLOR, 4, false)
	
	
func pattern(n: int) -> Array:
	if n <= 0:
		return []
	
	var block := [0] 
	for k in range(2, n + 1):
		var tail := []
		for i in range(1, block.size()):
			tail.append(block[i])
		block = block + [k - 1] + tail
	
	return block + block
