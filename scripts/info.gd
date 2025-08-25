extends Label
@onready var anims: AnimationPlayer = $InfoAnims
@onready var infobox: ReferenceRect = $MarginContainer/Infobox
@export var attach_point : Marker2D

var line_offset : Vector2:
	get():
		return attach_point.global_position# + Vector2(-20.0, -300.0)
#"id" : id,
#"location" : Vector2,
#"zoom_range" : Array, [numerical lower, numerical higher]
#"bounding_box" : Vector2,
#"type" : String,
#"name" : String,
#"status" : String,
#"description" : String,
#"draw_name" : bool
#"drawing_name" : bool
#"extra_info" : Array[Array[String]] = [["title1", value1 (variant)], "title2", value2 (variant)]]
#"dupe_verify": int

func hide_node():
	if not hidden:
		anims.play("InfoHide")
		await anims.animation_finished
		hide()

func display_POI_data(POI : Dictionary, update : bool = false):
	show()
	var info : Array[Array] = [["type", POI["type"]], ["name", POI["name"]], ["status", POI["status"]]]
	info.append_array(POI["extra_info"])
	info.append_array([["\n"], ["description", "\n" + POI["description"]]])
	
	text = ""
	for entry : Array in info:
		if entry[0] != "\n":
			text += entry[0].to_upper() + " : " + str(entry[1]).to_upper() + ("\n" if entry != info[-1] else "")
		else : text += "\n"
	
	if not update: anims.play("InfoShow")
