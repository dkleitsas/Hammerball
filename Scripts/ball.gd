extends RigidBody2D
@onready var kick_sound = $"../Sounds/kick_sound"

var last_touched = "L"


func _ready():

	add_to_group("Balls")
	linear_velocity += Vector2(randf_range(-100, 100), randfn(-20, 20))




func _on_player_left_body_entered(body):
	last_touched = "L"


func _on_foot_left_body_entered(body):
	last_touched = "L"


func _on_player_right_body_entered(body):
	last_touched = "R"


func _on_foot_right_body_entered(body):
	last_touched = "R"

	
func slow():
	linear_velocity *= 0.3







func _on_area_2d_body_entered(body):
	kick_sound.play()
