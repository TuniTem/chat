@tool
extends Node

const COARSE_EPSILON : float = 0.01
const EPSILON : float  = 0.001
const FINE_EPSILON : float  = 0.00001
const FINEST_EPSILON : float  = 0.000000001
const _EPSILON_ARR : Array = [COARSE_EPSILON, EPSILON, FINE_EPSILON, FINEST_EPSILON]

# breathe
enum BreatheMode {
	ADD,
	MULTIPLY
}

var TIME : float = 0.0
var _breathe_properties : Dictionary[Array, Dictionary] = {}
var _breathe_methods : Dictionary[Callable, Dictionary] = {}
var _breathe_enabled : bool = false
var _active_promises : Array[Promise]


# [Object, property] : {
#    "init" : float
#    "wavelength_seconds" : float
#    "amplitude" : float
#    "min" : float
#    "max" : float
#    "mode" : breatheMode 
#}


func _process(delta: float) -> void:
	TIME += delta
	if _breathe_enabled:
		for property : Array in _breathe_properties.keys():
			var data : Dictionary = _breathe_properties[property]
			if data["subscribed"]:
				match data["mode"]:
					BreatheMode.ADD:
						property[0].set(property[1],
							data["init"] + breathe_remap(data["wavelength_seconds"], data["min"], data["max"], data["use_sin"])
						)
					BreatheMode.MULTIPLY:
						property[0].set(property[1],
							data["init"] * breathe_remap(data["wavelength_seconds"], data["min"], data["max"], data["use_sin"])
						)
		
		for property : Callable in _breathe_methods.keys():
			var data : Dictionary = _breathe_methods[property]
			if data["subscribed"]:
				match data["mode"]:
					BreatheMode.ADD:
						property.call(data["init"] + breathe_remap(data["wavelength_seconds"], data["min"], data["max"], data["use_sin"]))
					BreatheMode.MULTIPLY:
						property.call(data["init"] * breathe_remap(data["wavelength_seconds"], data["min"], data["max"], data["use_sin"]))

func breathe(wavelength_seconds : float, amplitude : float, use_sin : bool = true, phase : float = 0.0) -> float:
	if use_sin:
		return sin((TIME - phase) * wavelength_seconds * TAU ) * amplitude
	else:
		return cos((TIME - phase) * wavelength_seconds * TAU) * amplitude

func breathe_remap(wavelength_seconds : float, min : float, max : float, use_sin : bool = true, phase : float = 0.0) -> float:
	return remap(breathe(wavelength_seconds, 1.0, use_sin, phase), -1.0, 1.0, min, max)

func breathe_property(object : Object, property : StringName, wavelength_seconds : float, amplitude : float, mode : BreatheMode, phase : float = TIME, use_amplitude : bool = true, min : float = 0.0, max : float = 1.0, use_sin : bool = true):
	_breathe_enabled = true
	_breathe_properties[[object, property]] = {
		"init" : object.get(property) if not _breathe_properties.has([object, property]) else _breathe_properties[[object, property]]["init"],
		"wavelength_seconds" : wavelength_seconds,
		"min" : min if not use_amplitude else object.get(property) - amplitude,
		"max" : max if not use_amplitude else object.get(property) + amplitude,
		"use_sin" : use_sin,
		"phase" : phase,
		"mode" : mode,
		"subscribed" : true
	}

func breathe_method(method : Callable, inital_value : float, wavelength_seconds : float, amplitude : float, mode : BreatheMode, phase : float = TIME, use_amplitude : bool = true, min : float = 0.0, max : float = 1.0, use_sin : bool = true):
	_breathe_enabled = true
	_breathe_methods[method] = {
		"init" : inital_value,
		"wavelength_seconds" : wavelength_seconds,
		"min" : min if not use_amplitude else inital_value - amplitude,
		"max" : max if not use_amplitude else inital_value + amplitude,
		"use_sin" : use_sin,
		"phase" : phase,
		"mode" : mode,
		"subscribed" : true
	}

func set_breathe_property_subscribe(object : Object, property : StringName, subscribed : bool, delete : bool = false):
	if delete: 
		_breathe_properties.erase([object, property])
	elif _breathe_properties.has([object, property]):
		_breathe_properties[[object, property]]["subscribed"] = subscribed
		if not subscribed: object.set(property, _breathe_properties[[object, property]]["init"])
	else:
		printerr("Breathe property not found: " + str([object, property]))

func set_breathe_method_subscribe(method : Callable, subscribed : bool, delete : bool = false):
	if delete: 
		_breathe_methods.erase(method)
	elif _breathe_methods.has(method):
		_breathe_methods[method]["subscribed"] = subscribed
		if not subscribed: method.call(_breathe_methods[method]["init"])
	else:
		printerr("Breathe method not found: " + str(method))

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
	print(array)
	print_stack()
	return on_fail

func between(value : Variant, lower : Variant, upper : Variant) -> bool:
	return value > lower and value < upper

func wait(time : float):
	await get_tree().create_timer(time).timeout
	return

func compound_signal(signals : Array[Signal], mode : Promise.Mode = Promise.Mode.ANY) -> Signal:
	return Promise.new(signals, mode).completed

func set_mute_bus(bus : String, on : bool):
	var idx : int = AudioServer.get_bus_index(bus)
	AudioServer.set_bus_mute(idx, on)

func toggle_mute_bus(bus : String):
	var idx : int = AudioServer.get_bus_index(bus)
	AudioServer.set_bus_mute(idx, not AudioServer.is_bus_mute(idx))

func set_bus_volume(bus : String, volume : float, linear : bool = true):
	var idx : int = AudioServer.get_bus_index(bus)
	if linear: AudioServer.set_bus_volume_linear(idx, volume)
	else: AudioServer.set_bus_volume_db(idx, volume)

func get_bus_volume(bus : String, linear : bool = true):
	var idx : int = AudioServer.get_bus_index(bus)
	if linear: AudioServer.get_bus_volume_linear(idx)
	else: AudioServer.get_bus_volume_db(idx)

func change_bus_volume_linear(bus: String, change : float, clamp_min : float = 0.0, clamp_max : float = 1.0) -> float:
	var idx : int = AudioServer.get_bus_index(bus)
	var set_vol : float = AudioServer.get_bus_volume_linear(idx) + change
	set_vol = clampf(set_vol, clamp_min, clamp_max)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index(bus), set_vol)
	return set_vol

# Note: these funcs don't use each other in order to run quicker
## checks if a == b, accounting for a customizable epsilon
func fequal(a : float, b : float, epsilon : int = 1) -> bool: 
	return absf(a - b) < _EPSILON_ARR[epsilon]

## checks if a < b, accounting for a customizable epsilon
func fless(a : float, b : float, epsilon : int = 1) -> bool: 
	return a < b and not absf(a - b) < _EPSILON_ARR[epsilon]

## checks if a > b, accounting for a customizable epsilon
func fgreat(a : float, b : float, epsilon : int = 1) -> bool:
	return a > b and not absf(a - b) < _EPSILON_ARR[epsilon]

## checks if a <= b, accounting for a customizable epsilon
func fless_equal(a : float, b : float, epsilon : int = 1) -> bool:
	return a < b or absf(a - b) < _EPSILON_ARR[epsilon]

## checks if a <= b, accounting for a customizable epsilon
func fgreat_equal(a : float, b : float, epsilon : int = 1) -> bool:
	return a > b or absf(a - b) < _EPSILON_ARR[epsilon]

## checks if a == 0.0, accounting for a customizable epsilon
func fzero(a : float, epsilon : int = 1) -> bool:
	return absf(a) < _EPSILON_ARR[epsilon]
