extends Node2D
@onready var timer = $Timer

enum PowerUpType { BIG_BALL, DOUBLE_BALL, CRAZY_BALL, SQUARE_BALL, LOW_GRAVITY,
 FLOATING_GOALS, SPEED, JUMP_BOOST }

var power_ups = preload("res://Scenes/power_up.tscn")

@onready var label = $Scoreboard

func _ready():
	label.text = str(Global.score_left) + " - " + str(Global.score_right)

	
func _process(delta):
	if randf() > 0.9988:
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
