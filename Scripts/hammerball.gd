extends Node2D
@onready var timer = $Goal2SecondTimer
@onready var game_timer = $GameTimer
var game_time: float = 91.0

enum PowerUpType { BIG_BALL, DOUBLE_BALL, CRAZY_BALL, SQUARE_BALL, LOW_GRAVITY,
 FLOATING_GOALS, SPEED, JUMP_BOOST }

var power_ups = preload("res://Scenes/power_up.tscn")

@onready var label = $Scoreboard

func _ready():
	label.text = str(Global.score_left) + " - " + str(Global.score_right)
	game_timer.text = "01:30"
	
func _process(delta):
	game_time -= delta
	game_timer.text = "%02d:%02d" % [int(game_time) / 60, int(game_time) % 60]
	if randf() > 0.9988 and get_tree().get_nodes_in_group("Powerups").size() < 4:
		var power_up_instance = power_ups.instantiate()
		add_child(power_up_instance)
		power_up_instance.position = Vector2(randi_range(200, 1150), randi_range(200, 400)) 
		power_up_instance.type = PowerUpType.values().pick_random() 

func _on_goal_left_body_entered(body):
	if body.is_in_group("Balls"):
		Global.score_right += 1
		label.text = str(Global.score_left) + " - " + str(Global.score_right)
		call_deferred("reset")


func _on_goal_right_body_entered(body):
	if body.is_in_group("Balls"):
		Global.score_left += 1
		label.text = str(Global.score_left) + " - " + str(Global.score_right)
		call_deferred("reset")
		
		

		
func reset():
	if timer.time_left <= 0:  # if timer is not running
		timer.wait_time = 2
		timer.one_shot = true  
		add_child(timer)      
		timer.start()
		await timer.timeout  
		get_tree().change_scene_to_file("res://Scenes/hammerball.tscn")


func hard_reset():
	Global.score_right = 0 
	Global.score_left = 0 
	get_tree().change_scene_to_file("res://Scenes/hammerball.tscn")
