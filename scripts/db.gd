extends Node

const DB_EXT : String = ".db"
const DB_PATH : String = "user://data/"
const BACKUPS_PATH : String = "user://data/backups/"

func list(db : String) -> Array:
	var file = FileAccess.open(DB_PATH + db + ".db", FileAccess.READ)
	if not file or file.get_error() != 0:
		printerr("List failed with error code " + str(file.get_error() if file else null)) 
		return []
	var out : Array = []
	var line : Variant = file.get_var(true)
	while line != null:
		out.append(line)
		line = file.get_var(true)
	
	file.close()
	return out

func size(db: String):
	return list(db).size()

func find(db: String, key: Variant):
	var data : Array = list(db)
	for entry in data:
		if entry.size() > 0 and entry[0] == key:
			return entry

func remove(db: String, key: Variant):
	var data : Array = list(db)
	for i in data.size():
		if data[i].size() > 0 and data[i][0] == key:
			data.remove_at(i)
			var file = FileAccess.open(DB_PATH + db + ".db", FileAccess.WRITE)
			for val in data: file.store_var(val, true)
			file.close()
			return

func update(db: String, key: Variant, new : Variant, index : int = -10, custom_backup_interval : int = 10):
	var data : Array = list(db)
	for i in data.size():
		if data[i].size() > 0 and data[i][0] == key:
			if index == -10: data[i] = new
			else: data[i][index] = new
			
			var file = FileAccess.open(DB_PATH + db + ".db", FileAccess.WRITE)
			for val in data: file.store_var(val, true)
			file.close()
			return
	
	append(db, new, custom_backup_interval)

func append(db : String, content : Variant, custom_backup_interval : int = 10):
	var file = FileAccess.open(DB_PATH + db + DB_EXT, FileAccess.READ_WRITE if FileAccess.file_exists(DB_PATH + db + DB_EXT) else FileAccess.WRITE)
	file.seek_end()
	file.store_var(content, true)
	file.close()
	
	if size(db) % custom_backup_interval == 1:
		backup(db)

func backup(db : String, mark_start : bool = false, max_backups : int = 100):
	var path = BACKUPS_PATH + db + "/"
	if not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(path)):
		DirAccess.make_dir_absolute(ProjectSettings.globalize_path(path))
		
	var dir = DirAccess.open(path)
	dir.copy_absolute(
		ProjectSettings.globalize_path(DB_PATH + db + DB_EXT), 
		ProjectSettings.globalize_path(path + ("STARTUP " if mark_start else "") + Time.get_datetime_string_from_system().replace(":", "-") + DB_EXT)
	)
	
	if dir.get_files().size() > max_backups:
		var oldest_file = ""
		var oldest_time = INF
		var file_name = dir.get_next()
		dir.list_dir_begin()
		for file in dir.get_files():
			var mod_time = FileAccess.get_modified_time(path + file)
			if mod_time < oldest_time:
				oldest_time = mod_time
				oldest_file = file
		dir.list_dir_end()
		dir.remove(oldest_file)
