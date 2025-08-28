class_name InputViewportHolder extends Node

@export var viewport : SubViewport


func _input(event: InputEvent) -> void:
	if viewport: 
		viewport.push_input(event)
