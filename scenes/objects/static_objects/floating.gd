extends Node3D

# Variables to control bobbing
var bob_height: float = 0.5  # Maximum height for bobbing
var bob_speed: float = 2.0   # Speed of bobbing movement
var time_passed: float = 0.0 # Tracks time
var is_going_up: bool = true

# Timer for random intervals
var random_bob_timer: Timer

func _ready() -> void:
	# Create and start a timer for random intervals
	random_bob_timer = Timer.new()
	random_bob_timer.wait_time = randf_range(0.5, 2.0)  # Random time between 0.5 to 2 seconds
	random_bob_timer.one_shot = false  # Repeat indefinitely
	random_bob_timer.timeout.connect(_on_random_bob_timeout)
	add_child(random_bob_timer)
	random_bob_timer.start()

func _process(delta: float) -> void:
	# Check if the random timer is currently running
	if random_bob_timer.is_stopped() == false:
		time_passed += delta
		var bob_offset = sin(time_passed * bob_speed) * bob_height
		# Adjust the object's position by updating translation
		if(is_going_up):
			position.y += bob_offset * delta  # Bobbing the object up and down
		else:
			position.y -= bob_offset * delta 

func _on_random_bob_timeout() -> void:
	# When the timer triggers, reset time_passed to create random bobbing intervals
	time_passed = 0.0
	random_bob_timer.wait_time = randf_range(0.5, 2.0)  # Set new random interval
	is_going_up = not is_going_up
