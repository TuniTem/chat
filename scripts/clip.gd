extends Sprite2D

@export var clip_node : AnimatedSprite2D

func _process(delta: float) -> void:
	var shader_material : ShaderMaterial = material
	
	shader_material.set_shader_parameter("mask_texture", clip_node.sprite_frames.get_frame_texture(clip_node.animation, clip_node.frame))
	#shader_material.set_shader_param("mask_size", clip_node.texture.get_size())
