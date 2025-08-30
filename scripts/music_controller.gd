extends Node

const REAPEAT_AVOID_BUFFER_PERCENT = 0.2
const FADE_TIME = 1.0
const LINKS : Dictionary[String, String] = {
	#password
	"access_denied.mp3" : "https://youtu.be/T_nPfDd_ZvQ&t=2193",
	"A-D_converted_thoughts.mp3": "https://youtu.be/GEYye5TNWuA",
	"cloud_music.mp3": "https://youtu.be/owe8d1mU8T4",
	"command_line.mp3": "https://youtu.be/T_nPfDd_ZvQ&t=1574",
	"decrypted_decepted.mp3": "https://youtu.be/8E2W-UQFza4",
	"fumei.mp3": "https://youtu.be/jZi59yiOZ7s",
	"I_am_okay.mp3": "https://youtu.be/Yakw-9qXY0Y",
	"I_never_left.mp3": "https://youtu.be/vtRqKbyNwFY",
	"I_was_here_now_im_gone.mp3": "https://youtu.be/T_nPfDd_ZvQ&t=2835",
	"multilevel_parking_music.mp3": "https://youtu.be/xRK2d_MKOT0",
	"non-static.mp3": "https://youtu.be/T_nPfDd_ZvQ&t=1224",
	"petrol_stain_patterns.mp3": "https://youtu.be/sDyPXoQmHfw",
	"plug_me_in_reconnect.mp3": "https://youtu.be/ZP3MYtMx0AA",
	"recycle_bin_music.mp3": "https://youtu.be/nh90nqvuxXw",
	"scatter_me_rearrange.mp3": "https://youtu.be/twzgvrwpHt0",
	"shutdown_music.mp3": "https://youtu.be/T_nPfDd_ZvQ&t=668",
	"silent_mode.mp3": "https://youtu.be/T_nPfDd_ZvQ&t=212",
	"stopmotion_music.mp3": "https://youtu.be/U8OGzkC3tMo",
	"stuck_in_the_clipboard.mp3": "https://youtu.be/jz97CQ6uJ-Y",
	"taking_my_body_elsewhere.mp3": "https://youtu.be/T_nPfDd_ZvQ&t=2526",
	"tetsudou_no_uta.mp3": "https://youtu.be/T_nPfDd_ZvQ&t=482",
	"thank_you_for_always_being_with_me.mp3": "https://youtu.be/T_nPfDd_ZvQ&t=914",
	"third_death.mp3": "https://youtu.be/T_nPfDd_ZvQ&t=1785",
	"update_music.mp3": "https://youtu.be/T_nPfDd_ZvQ&t=0",
	"waterfall_music.mp3": "https://youtu.be/T_nPfDd_ZvQ&t=1366",
	"Morning Dew": "https://youtu.be/NQw8YFByO3Y",
	
	#frog
	"Lilypad": "youtu.be/9O6-VJJLoUw",
	"Comfort Zone": "youtu.be/VZgEzeG-8BM",
	"Serenity": "youtu.be/a5wSePF_Fdg",
	"Foggy Froggy": "youtu.be/3Z4GNTrQNvk",
	"For the Better": "youtu.be/7K9rs2md_jU",
	"Ponderer": "youtu.be/kiPiiqHaB2A",
	"Wanderer": "youtu.be/q4hRu95nv5o",
	"Unknown Waters": "youtu.be/z5CivjQygOc",
	"Beyond the Pond": "youtu.be/zwhSVwHba44",
	"Wetlands": "youtu.be/kOhfVyUez8Q",
	"So Long...": "youtu.be/ZkEa29p1xBI",
}

const AUTHOR_SONG_DELIMITER : String = "—"
const REPLACE_CHARS : Array[Array] = [
	["·", "."],
	["╱", "/"]
]

@onready var playlist_lowpass : AudioEffectLowPassFilter = preload("res://audio/FX/music_lowpass.tres")

@onready var playlist_node: Node = %Playlists
@onready var music_node: Node = %Music

signal music_changed(to : String)

var music : Dictionary[String, AudioStreamPlayer]
var playlists : Dictionary[String, Array]
var queue : Array[Dictionary]

var current_playlist : String = ""
var current_song : String:
	get():
		if queue.size() != 0:
			return queue[0]["name"]
		else:
			return ""

var current_artist : String:
	get():
		if queue.size() != 0:
			return queue[0]["author"]
		else:
			return ""

func get_current_song_as_string() -> String:
	return current_artist + " - " + current_song

func get_current_song_link() -> String:
	var song : String = current_song
	if LINKS.keys().has(song):
		return LINKS[song]
	else:
		printerr(song)
		return "[link bork, pls fix tuni!!]"


func _ready() -> void:
	Net.button_pressed.connect(_on_control_button_pressed)
	
	for playlist : Node in playlist_node.get_children():
		var playlist_name : String = playlist.name
		playlists[playlist_name] = []
		for song : AudioStreamPlayer in playlist.get_children():
			var node_name : String = song.name
			for replace : Array in REPLACE_CHARS:
				node_name = node_name.replace(replace[0], replace[1])
			
			playlists[playlist_name].append({
				"author" : node_name.split(AUTHOR_SONG_DELIMITER)[0],
				"name" : node_name.split(AUTHOR_SONG_DELIMITER)[1],
				"node" : song
			})
			
			song.finished.connect(_on_finished)
	
	for child : AudioStreamPlayer in music_node.get_children():
		music[child.name] = child


func play_music():
	pass

func _on_control_button_pressed(to : String):
	if to in playlists.keys():
		load_playlist_to_queue(to)
	#
	match to:
		"music_off":
			clear()
		
		"music_random":
			var exclusive : Array[String] = playlists.keys()
			exclusive.erase(current_playlist)
			var selected : String = exclusive.pick_random()
			load_playlist_to_queue(selected)
			
		"toggle_constellation_audio":
				Util.toggle_mute_bus("Constellation")

func clear():
	current_playlist = ""
	if queue.size() > 0:
		fade_song(queue[0]["node"])
		
	for playlist_str : String in playlists.keys():
		var playlist : Array = playlists[playlist_str]
		for song : Dictionary in playlist:
			if queue.size() == 0 or song != queue[0]:
				song["node"].stop()
	
	queue = []

func fade_song(song : AudioStreamPlayer, to : float = 0.0):
	if to != 0.0: song.play()
	var tween : Tween = create_tween()
	tween.tween_property(song, "volume_linear", to, FADE_TIME)
	await tween.finished
	if to == 0.0:
		song.stop()

func next():
	if queue.size() >= 2:
		fade_song(queue[0]["node"])
		queue.pop_front()
		fade_song(queue[0]["node"], 1.0)
		music_changed.emit(queue[0]["author"] + " - " + queue[0]["name"])
	
	
	elif queue.size() == 1:
		fade_song(queue[0]["node"])
		current_playlist = ""

func _on_finished():
	next()

func load_playlist_to_queue(playlist : String, unload_previous : bool = true, shuffle : bool = true, load_times : int = 20):
	if unload_previous: clear()
	current_playlist = playlist
	if shuffle:
		var repeat_avoid_thresh : int = floor(REAPEAT_AVOID_BUFFER_PERCENT * playlists[playlist].size())
		var hist : Array = []
		
		var buffer : Array = playlists[playlist].duplicate()
		var count : int = 0
		while count < load_times:
			var to_add : Dictionary = buffer.pick_random()
			var temp_buffer : Array = buffer.duplicate()
			while hist.has(to_add) and temp_buffer.size() != 0:
				to_add = temp_buffer.pick_random()
				temp_buffer.erase(to_add)
			
			buffer.erase(to_add)
			if buffer.size() - 2 < repeat_avoid_thresh:
				buffer.append_array(playlists[playlist].duplicate())
				count += 1
			
			hist.append(to_add)
			if hist.size() >= repeat_avoid_thresh:
				hist.pop_front()
			
			queue.append(to_add)
			
	else:
		for i in load_times:
			queue.append_array(playlists[playlist])
	
	if unload_previous:
		next()
	
	
	
		#var repeat_avoid_thresh : int = floor(REAPEAT_AVOID_BUFFER_PERCENT * playlists[playlist].size())
		#print("repeat avoid: ", repeat_avoid_thresh)
		#var count = 0
		#var buffer : Array = playlists[playlist].duplicate()
		#for i in 100000:
			#var to_add : Dictionary = buffer.pick_random()
			#if not to_add in queue.slice(repeat_avoid_thresh + 1, 0, -1):
				#buffer.erase(to_add)
				#queue.append(to_add)
				#prints(queue.size(), count)
				#
				#if buffer.size() - 2 < repeat_avoid_thresh:
					#buffer.append_array(playlists[playlist].duplicate())
					#count += 1
					#if count >= load_times: break
		
		
		#var previous_shuffle : Array
		#var repeat_avoid_thresh : int = floor(REAPEAT_AVOID_BUFFER_PERCENT * playlists[playlist].size())
		#
		#for i in load_times:
			#var current_shuffle : Array = playlists[playlist].duplicate()
			#current_shuffle.shuffle()
			#
			#if previous_shuffle:
				#var previous_slice : Array = previous_shuffle.slice(repeat_avoid_thresh + 1, 0, -1)
				#for j in repeat_avoid_thresh + 1:
					#var current_slice : Array = current_shuffle.slice(0, repeat_avoid_thresh + 1)
					#
					#var hit : bool = false
					#for slice in current_slice:
						#if slice in previous_slice:
							#hit = true
							#current_shuffle.erase(slice)
							#current_shuffle.insert(randi_range(current_shuffle.size() - repeat_avoid_thresh - 1, current_shuffle.size() - 1), slice)
					#
					#if not hit : break
			#
			#queue.append_array(current_shuffle)
			#previous_shuffle = current_shuffle
	
	
	#else:
		#for i in load_times:
			#queue.append_array(playlists[playlist])
		
		

#var prev_progress : float = INF
#var stream : AudioStreamPlaylist
#func _process(delta: float) -> void:
	#AudioStreamPlaybackInteractive
	#if stream: 
		#pass
		##print(stream.get_bpm())


			

#func fade_playlist(playlist : String, to : float = 0.0):
	#var playlist_to_fade : AudioStreamPlayer = playlists.get_node(playlist)
	#
	#if to != 0.0: playlist_to_fade.play()
	#var tween : Tween = create_tween()
	#tween.tween_property(playlist_to_fade, "volume_linear", to, PLAYLIST_FADE_TIME)
#
#func fade_all(out : bool = true):
	#for playlist : String in playlist_names:
		#fade_playlist(playlist, 0.0 if out else 1.0)
#
#func change_playlist(to : String):
	#if current_playlist != "": fade_playlist(current_playlist)
	#current_playlist = to
	##stream = active_playlist.stream
	#await get_tree().create_timer(PLAYLIST_FADE_TIME).timeout
	#fade_playlist(current_playlist, 1.0)
#
#
#func _on_password_finished() -> void:
	#print("wompwomp")
