extends Node

var TIME : float = 0.0

func _process(delta: float) -> void:
	TIME += delta

func rect_from_center(position : Vector2, size : Vector2) -> Rect2:
	return Rect2(
		position + size / 2.0,
		size
	)

func get_all_children(node : Node, data : Array = []):
	data.push_back(node)
	for child in node.get_children():
		data = get_all_children(child, data)
	
	return data

func search(array : Array, index : Variant, key : Variant, duplicate : bool = false, on_fail : Variant = null, sub_key : Variant = -1):
	for item in array:
		if item[index] == key:
			if sub_key == -1:
				return item.duplicate() if duplicate else item
			else:
				return item[sub_key]
	
	printerr("Util search error: Could not find iteration ", key, " avalable iterations printed")
	print_stack()
	print(array)
	return on_fail

func between(value : Variant, lower : Variant, upper : Variant) -> bool:
	return value > lower and value < upper
