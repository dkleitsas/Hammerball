extends Area2D

@onready var player_right = $"../PlayerRight"
@onready var player_left = $"../PlayerLeft"


const BALL = preload("res://Scenes/ball.tscn")

const POWER_UP_DURATION = 10

enum PowerUpType { BIG_BALL, DOUBLE_BALL, CRAZY_BALL, SQUARE_BALL, LOW_GRAVITY,
 FLOATING_GOALS, SPEED, JUMP_BOOST }

var type: PowerUpType
var player
var ball

var acctive_effect
var effect_time_left


func power_up_collected(body):
	
	ball = body
	
	if ball.last_touched == "L":
		player = player_left
	elif ball.last_touched == "R":
		player = player_right
		
	match type:
		PowerUpType.BIG_BALL:
			for b in get_tree().get_nodes_in_group("Balls"):
				var big_ball = CircleShape2D.new()
				big_ball.radius = 32
				b.get_node("CollisionShape2D").set_deferred("shape", big_ball)
		PowerUpType.DOUBLE_BALL:
			var new_ball = BALL.instantiate()
			new_ball.add_to_group("Balls")
			new_ball.position = ball.position
			new_ball.linear_velocity = ball.linear_velocity / 1.2
			get_parent().call_deferred("add_child", new_ball)
		PowerUpType.CRAZY_BALL:
			for b in get_tree().get_nodes_in_group("Balls"):
				var crazy_ball = CircleShape2D.new()
				crazy_ball.radius = 12
				b.get_node("CollisionShape2D").set_deferred("shape", crazy_ball)
				b.physics_material_override.set_bounce(0.8)
		PowerUpType.SQUARE_BALL:
			for b in get_tree().get_nodes_in_group("Balls"):
				var rect = RectangleShape2D.new()
				rect.extents = Vector2(15, 15)
				b.get_node("CollisionShape2D").set_deferred("shape", rect)
		PowerUpType.LOW_GRAVITY:
			for b in get_tree().get_nodes_in_group("Balls"):
				b.gravity_scale = 0.3
				b.mass = 0.5
		PowerUpType.FLOATING_GOALS:
			pass
		PowerUpType.SPEED:
			player.speed = 500.0
		PowerUpType.JUMP_BOOST:
			player.jump_impulse = 1200.0

			
	var timer = Timer.new()
	timer.wait_time = POWER_UP_DURATION
	timer.one_shot = true
	timer.timeout.connect(_on_power_up_timeout)
	add_child(timer)
	timer.start()
	set_deferred("monitoring", false)
	visible = false

func _on_power_up_timeout():
	
	match type:
		PowerUpType.BIG_BALL:
			# var normal_ball = CircleShape2D.new()
			# normal_ball.radius = 16
			# ball.get_node("CollisionShape2D").shape = normal_ball
			pass
		PowerUpType.DOUBLE_BALL:
			pass
		PowerUpType.CRAZY_BALL:
			# ball.get_node("CollisionShape2D").scale *= 2
			# ball.physics_material_override.set_bounce(0.55)
			pass
		PowerUpType.SQUARE_BALL:
			# var circle = CircleShape2D.new()
			# circle.radius = 16
			# ball.get_node("CollisionShape2D").shape = circle
			pass
		PowerUpType.LOW_GRAVITY:
			for b in get_tree().get_nodes_in_group("Balls"):
				b.gravity_scale = 1
				b.mass = 0.33
		PowerUpType.FLOATING_GOALS:
			pass
		PowerUpType.SPEED:
			player.speed = 300.0
		PowerUpType.JUMP_BOOST:
			player.jump_impulse = 1000.0



func _on_body_entered(body):
	if body.is_in_group("Balls"):
		power_up_collected(body)
		
