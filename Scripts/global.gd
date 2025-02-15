extends Node

var score_left = 0
var score_right = 0
var game_time: float = 91.0
var ambience_sound_pos = 0
var audio_stream_player = AudioStreamPlayer.new()
const AMBIENCE = preload("res://Art/sounds/ambience.wav")
var selected_player_left
var selected_player_right

func _ready():
	add_child(audio_stream_player)
	audio_stream_player.stream = AMBIENCE
	audio_stream_player.process_mode = Node.PROCESS_MODE_ALWAYS
	audio_stream_player.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
