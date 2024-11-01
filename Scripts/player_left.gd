extends RigidBody2D



var speed = 300.0



# JUMP PARAMETERS !! please tweak them TwT... the right player has the old system.
var jump_impulse = 300
var hold_jump_force = 5500
var max_jump_hold_time = 0.15
var jump_hold_timer = 0.0

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
		jump_hold_timer = max_jump_hold_time
		
	if Input.is_action_pressed("jump_l") and jump_hold_timer > 0:
		apply_impulse(Vector2(0, -hold_jump_force * state.step))
		jump_hold_timer -= state.step
		
	if Input.is_action_just_released("jump_l"):
		jump_hold_timer = 0
		
		
	if Input.is_action_pressed("kick_l") and bat.rotation_degrees > -90:
		bat.rotation -= 0.2
	elif !Input.is_action_pressed("kick_l") and bat.rotation_degrees < 0:
		bat.rotation += 0.1
