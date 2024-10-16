extends RigidBody2D


# Movement speed
var speed = 300.0
# Jump impulse strength
var jump_impulse = 1000.0

@onready var ground_ray = $GroundRay
@onready var left_ray = $LeftRay
@onready var right_ray = $RightRay
@onready var bat = $Bat


func _integrate_forces(state):
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_left_l") and not left_ray.is_colliding():
		direction.x -= 1
	if Input.is_action_pressed("move_right_l")and not right_ray.is_colliding():
		direction.x += 1
		

	direction = direction.normalized()
	
	# Apply linear velocity
	if direction != Vector2.ZERO:
		linear_velocity.x = direction.x * speed
	else:
		linear_velocity.x = 0
		
	var on_ground = ground_ray.is_colliding()
	
	if Input.is_action_just_pressed("jump_l") and on_ground:
		apply_impulse(Vector2(0, -jump_impulse))
		
		
	if Input.is_action_pressed("kick_l") and bat.rotation_degrees > -90:
		bat.rotation -= 0.2
	elif !Input.is_action_pressed("kick_l") and bat.rotation_degrees < 0:
		bat.rotation += 0.1
