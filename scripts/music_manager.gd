class_name MusicManager

extends Node

@onready var player: Player = %Player
@onready var music_revolution_base: AudioStreamPlayer = $RevolutionBase
@onready var music_revolution_panic: AudioStreamPlayer = $RevolutionPanic
@onready var game_manager: GameManager = %GameManager

var sounds_registry: Dictionary
var current_sound: AudioStreamPlayer
var sounds_start_volumes: Dictionary
var sounds_volumes_scale: Dictionary

var adaptive_song_audio_array: Array[AudioStreamPlayer] # stores audio stream players used in adaptive song
var adaptive_song_tracks_enabled: Array[bool] # keeps track of witch audio stream players are enabled in adaptive song
var adaptive_song_tracks_default_volumes: Array[float] #keeps track of the starting bolume of audio streams in adaptive song

func _ready() -> void:
	start_adaptive_song([music_revolution_base, music_revolution_panic], [true, true])
	game_manager.floor_cleared.connect(set_song_to_base_varient)
	game_manager.new_floor.connect(set_song_to_panic_varient)
	player.health_component.death.connect(set_song_to_base_varient)


func fade_out():
	adjust_adaptive_song([false,false], 1)


func set_song_to_base_varient():
	adjust_adaptive_song([true,false], 1)


func set_song_to_panic_varient():
	adjust_adaptive_song([true,true], 1)

# plays multiple audio players syncronized with the ability to mute and unmute at will
# audio_array = array of audio tracks to be played
# tracks_enabled = array stating witch of those tracks will be unmuted
func start_adaptive_song(audio_array: Array[AudioStreamPlayer], tracks_enabled: Array[bool]):
	# Note!!!! this DOES NOT reset audio stream players if song is changed! remeber to fix at some point.
	adaptive_song_audio_array = audio_array
	adaptive_song_tracks_enabled = tracks_enabled
	var i = 0
	adaptive_song_tracks_default_volumes.clear()
	for track in adaptive_song_audio_array:
		adaptive_song_tracks_default_volumes.append(track.volume_linear)
		if adaptive_song_tracks_enabled[i]:
			track.volume_linear = adaptive_song_tracks_default_volumes[i]
		else:
			print("disabled")
			track.volume_linear = 0
		track.play()
		i += 1


# mutes or unmutes tracks in the active adaptive song
# tracks_enabled = array stating witch of those tracks will be unmuted
# fade_speed = time in secs to fade from one state to the next
func adjust_adaptive_song(tracks_enabled: Array[bool], fade_speed: float):
	var i = 0
	for track in adaptive_song_audio_array:
		fade_audio_track(track, fade_speed, int(tracks_enabled[i]) * adaptive_song_tracks_default_volumes[i])
		i += 1
	adaptive_song_tracks_enabled = tracks_enabled


# fades the spesified audio stream player to the spesified volume in the spesified amount of time
func fade_audio_track(audio_track: AudioStreamPlayer, time: float, volume_linear: float):
	var tween = get_tree().create_tween()
	tween.tween_property(audio_track, "volume_linear", volume_linear, time)
	tween.play()
