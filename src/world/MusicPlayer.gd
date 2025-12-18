extends Node
class_name MusicPlayer


## A list of music tracks
@export var music_tracks : Array[AudioStream]
@onready var player1 : AudioStreamPlayer = $AudioStreamPlayer
@onready var player2 : AudioStreamPlayer = $AudioStreamPlayer2
var current_player : AudioStreamPlayer



func switch_to_track(track : AudioStream) -> void:
	if current_player != player1:
		current_player = player1
		$AnimationPlayer.play("fade_to_1")
	else:
		current_player = player2
		$AnimationPlayer.play("fade_to_2")
		
	current_player.stream = track



func _on_audio_player_finished(player : AudioStreamPlayer) -> void:
	player.playing = true
