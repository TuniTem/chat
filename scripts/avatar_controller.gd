extends Node3D

@onready var cube: MeshInstance3D = $Cube

var face_tracking : XRFaceTracker = XRFaceTracker.new()

#func _process(delta: float) -> void:
	##print(VmcPlugin.latest_data.keys())
	##if VmcPlugin.latest_data.keys().size() > 3:
	#for blend_shape : String in VmcPlugin.latest_data.keys():
		#var idx : int = cube.find_blend_shape_by_name(blend_shape)
		#if idx != -1:
			#cube.set_blend_shape_value(idx, VmcPlugin.latest_data[blend_shape])
