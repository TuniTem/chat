class_name NotificationManager extends Node2D

enum NotificationType {
	FOLLOW
}

const NOTIFICATION_SCENE = preload("res://scenes/notif.tscn")
const NOTIFICATION_GAP_INTERVAL : float = 2.0

@export var location : Marker2D

var curr_notif : Node2D
var notification_buffer : Array[Dictionary]

func _ready() -> void:
	Global.notification_manager = self

func send_notification(type : NotificationType, time : float, content : Variant):
	var data : Dictionary = {"type": type, "timestamp" : time, "content" : content}
	notification_buffer.append(data)
	DB.append("notifications", data, 20)
	if not attempting and (not curr_notif or not is_instance_valid(curr_notif)):
		_attempt_notif()

func _attempt_notif():
	if notification_buffer.size() >= 1:
		var data : Dictionary = notification_buffer.pop_front()
		var inst : Node2D = NOTIFICATION_SCENE.instantiate()
		
		match data["type"]:
			NotificationType.FOLLOW:
				inst.username = data["content"]
		
		inst.on_complete.connect(_delayed_attempt)
		location.add_child(inst)
		curr_notif = inst

var attempting : bool = false
func _delayed_attempt():
	attempting = true
	await get_tree().create_timer(NOTIFICATION_GAP_INTERVAL).timeout
	attempting = false
	_attempt_notif() 
