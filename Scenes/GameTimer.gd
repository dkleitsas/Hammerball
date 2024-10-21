extends Timer

@onready var timer = $"."
@onready var label = $".."
var remaining_time = 91 

func _ready():
	# Connect the timer's timeout signal using a Callable
	timer.timeout.connect(Callable(self, "_on_Timer_timeout"))
	timer.start()  # Start the timer

# Function called when the timer times out
func _on_Timer_timeout():
	remaining_time -= 1  # Decrease the time

	# Calculate minutes and seconds
	var minutes = int(remaining_time / 60)
	var seconds = remaining_time % 60

	# Manually pad seconds with leading zero if it's less than 10
	var padded_seconds = str(seconds)
	if seconds < 10:
		padded_seconds = "0" + str(seconds)

	# Update the label with formatted time (MM:SS)
	label.text = str(minutes) + ":" + padded_seconds

	if remaining_time <= 0:
		timer.stop()  # Stop the timer if the time reaches zero

