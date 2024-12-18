extends Node2D

@onready var timer = $Goal2SecondTimer
@onready var game_timer = $GameTimer
@onready var collision_shape_rightgoal = $GoalRight/GoalArea/CollisionShape2D
@onready var collision_shape_leftgoal = $GoalLeft/GoalArea/CollisionShape2D
var collisions_disabled = false
var done_hard_reset = false

@onready var goal_sound = $Sounds/goal_sound
@onready var whistle_end = $Sounds/whistle_end
@onready var cheer_sound = $Sounds/cheer_sound
@onready var short_cheer_sound = $Sounds/short_cheer_sound
@onready var ambience = $Sounds/ambience


enum PowerUpType { BIG_BALL, DOUBLE_BALL, CRAZY_BALL, SQUARE_BALL, LOW_GRAVITY, FLOATING_GOALS, SPEED, JUMP_BOOST, INCREASE_TIME, REDUCE_TIME }
var power_ups = preload("res://Scenes/power_up.tscn")
@onready var label = $Scoreboard

func _ready():
	label.text = str(Global.score_left) + " - " + str(Global.score_right)
	game_timer.text = "%02d:%02d" % [int(Global.game_time) / 60, int(Global.game_time) % 60]
	ambience.play(Global.ambience_sound_pos)
	
func _process(delta):
	Global.ambience_sound_pos = ambience.get_playback_position()
	Global.game_time -= delta
	if Global.game_time > 0:
		game_timer.text = "%02d:%02d" % [int(Global.game_time) / 60, int(Global.game_time) % 60]
	else:
		game_timer.text = "00:00"
		if not done_hard_reset:
			hard_reset()
	if randf() > 0.998 and get_tree().get_nodes_in_group("Powerups").size() < 3:
		var power_up_instance = power_ups.instantiate()
		power_up_instance.type = PowerUpType.values().pick_random() 
		add_child(power_up_instance)
		power_up_instance.position = Vector2(randi_range(200, 1150), randi_range(200, 400)) 
		

func _on_goal_left_body_entered(body):
	if body.is_in_group("Balls"):
		goal_sound.play()
		short_cheer_sound.play()
		Global.score_right += 1
		label.text = str(Global.score_left) + " - " + str(Global.score_right)
		call_deferred("reset")

func _on_goal_right_body_entered(body):
	if body.is_in_group("Balls"):
		goal_sound.play()
		short_cheer_sound.play()
		Global.score_left += 1
		label.text = str(Global.score_left) + " - " + str(Global.score_right)
		call_deferred("reset")
		
func _on_goal_area_body_exited(body):
	if body.is_in_group("Balls"):
		body.slow()
		disable_collisions()

func disable_collisions():
	if not collisions_disabled:
		if collision_shape_rightgoal and collision_shape_leftgoal:
			collision_shape_rightgoal.queue_free()
			collision_shape_leftgoal.queue_free()
		collisions_disabled = true

func reset():
	if Global.game_time > 4:
		timer.wait_time = 2  # 2 seconds after entering goal area
		timer.start()
		await timer.timeout
		get_tree().change_scene_to_file("res://Scenes/hammerball.tscn")

func hard_reset():
	done_hard_reset = true
	whistle_end.play()
	cheer_sound.play()
	if not collisions_disabled:
		disable_collisions()
	timer.wait_time = 5  # end scene 5 seconds after timer reached 00:00
	timer.start()
	await timer.timeout
	Global.score_right = 0 
	Global.score_left = 0 
	Global.game_time = 91.0
	get_tree().change_scene_to_file("res://Scenes/hammerball.tscn")
