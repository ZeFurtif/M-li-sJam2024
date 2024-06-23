extends Node

var musicSP
var musicStreams = []
var musicIdx = 0
var ambientSP
var ambientStreams = []
var ambientIdx = 0

func _ready():
	musicSP = AudioStreamPlayer.new()
	musicSP.bus = "Music"
	add_child(musicSP)
	musicSP.finished.connect(_on_song_ends)
	ambientSP = AudioStreamPlayer.new()
	ambientSP.bus  = "Ambience"
	add_child(ambientSP)
	ambientSP.finished.connect(_on_ambient_ends)
	
	var music_paths = DirAccess.get_files_at("res://Assets/Audio/Music/")
	for path in music_paths:
		if not ".import" in path:
			var stream = load("res://Assets/Audio/Music/" + path)
			musicStreams.append(stream)
	var ambience_paths = DirAccess.get_files_at("res://Assets/Audio/Ambient/")
	for path in ambience_paths:
		if not ".import" in path:
			var stream = load("res://Assets/Audio/Ambient/" + path)
			ambientStreams.append(stream)
	
	musicSP.stream = musicStreams[musicIdx]
	musicSP.play()
	ambientSP.stream = ambientStreams[ambientIdx]
	ambientSP.play()
	
	musicIdx += 1
	if musicIdx >= len(musicStreams):
		musicIdx = 0
	ambientIdx += 1
	if ambientIdx >= len(ambientStreams):
		ambientIdx = 0


func _process(delta):
	pass
	
func _on_song_ends():
	musicSP.stream = musicStreams[musicIdx]
	musicSP.play()
	musicIdx += 1
	if musicIdx >= len(musicStreams):
		musicIdx = 0
	
func _on_ambient_ends():
	ambientSP.stream = ambientStreams[ambientIdx]
	ambientSP.play()
	ambientIdx += 1
	if ambientIdx >= len(ambientStreams):
		ambientIdx = 0
		
func change_volume(value):
	AudioServer.set_bus_volume_db(0, value)
