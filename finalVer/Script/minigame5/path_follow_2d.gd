extends PathFollow2D

var is_patrolling = true

func _process(delta):
	if is_patrolling:
		progress += 100 * delta  # or your patrol speed

func start_patrol():
	is_patrolling = true

func stop_patrol():
	is_patrolling = false
