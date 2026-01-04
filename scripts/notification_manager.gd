class_name NotificationManager extends Node2D

enum NotificationType {
	FOLLOW,
	SUB,
	SUB_MESSAGE,
	GIFT,
	RAID,
	CHEER
}

const NOTIFICATION_SCENE = preload("res://scenes/notif.tscn")
const NOTIFICATION_GAP_INTERVAL : float = 2.0

@export var location : Marker2D

var curr_notif : Node2D
var notification_buffer : Array[Dictionary]

func _ready() -> void:
	Global.notification_manager = self
	Net.button_pressed.connect(_on_control_button_pressed)

func send_notification(type : NotificationType, time : float, content : Variant, test : bool = false):
	var data : Dictionary = {"type": type, "timestamp" : time, "content" : content}
	notification_buffer.append(data)
	if test:
		print(data)
	else:
		DB.append("notifications", data, 20)
	
	if not attempting and (not curr_notif or not is_instance_valid(curr_notif)):
		_attempt_notif()

func _attempt_notif():
	if notification_buffer.size() >= 1:
		var data : Dictionary = notification_buffer.pop_front()
		var inst : Node2D = NOTIFICATION_SCENE.instantiate()
		var content : Variant = data["content"]
		
		match data["type"]:
			NotificationType.FOLLOW:
				inst.title_text = "Welcome Dreamer"
				inst.sub_text = content
			
			NotificationType.SUB:
				inst.title_text = "New Subscriber!"
				float()
				inst.sub_text = content["username"] + " at tier " + str(roundf(float(content["tier"]))) + " !!"
			
			NotificationType.SUB_MESSAGE:
				if content["message"] != null and content["message"] != "":
					inst.title_text = content["username"] + " subbed \nat tier " + str(roundf(float(content["tier"]))) + " for " + str(roundf(float(content["streak"]))) + " months!"
					inst.sub_text = content["message"]
				else:
					inst.title_text = "~ Subscriber ~"
					inst.sub_text = content["username"] + " subbed \nat tier " + str(roundf(float(content["tier"]))) + " for " + str(roundf(float(content["streak"]))) + " months!"
			
			NotificationType.GIFT:
				inst.title_text = content["username"]
				if str(content["tier"]) == "1":
					inst.sub_text = "Gifted " + str(roundf(float(content["amount"]))) + " subs! \nThank you 💜"
				else:
					inst.sub_text = "Gifted " + str(roundf(float(content["amount"]))) + " subs at tier " + str(roundf(float(content["tier"]))) + "! \nThank you 💜"
			
			NotificationType.CHEER: # "username" : "Unknown", "amount": data["bits"], "message" : data["message"]}
				if content["message"] and content["message"] != "":
					inst.title_text = content["username"] + " cheered " + str(roundf(float(content["amount"]))) + "!"
					inst.sub_text = content["message"]
				else:
					inst.title_text = content["username"]
					inst.sub_text = "Cheered " + str(roundf(float(content["amount"]))) + " bits!"
		
			NotificationType.RAID:
				inst.title_text = "Incoming raid!"
				inst.sub_text = content["username"] + " with " + str(roundf(float(content["amount"]))) + " viewers!"
		
		inst.on_complete.connect(_delayed_attempt)
		location.add_child(inst)
		curr_notif = inst

var attempting : bool = false
func _delayed_attempt():
	attempting = true
	await get_tree().create_timer(NOTIFICATION_GAP_INTERVAL).timeout
	attempting = false
	_attempt_notif() 

func _on_control_button_pressed(data):
	if data == "test_notif":
		send_notification(NotificationType.FOLLOW, Time.get_unix_time_from_system(), "test_username", true)
