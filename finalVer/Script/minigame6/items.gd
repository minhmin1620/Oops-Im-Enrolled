extends Area2D

signal caught(is_alcohol: bool)

var fall_speed = 150.0

func set_fall_speed(speed: float) -> void:
	fall_speed = speed

func _physics_process(delta: float) -> void:
	position.y += fall_speed * delta
	if position.y > 900:
		queue_free()

func is_alcohol() -> bool:
	return is_in_group("alcohol")

func _on_body_entered(body):
	print("Body entered:", body.name)
	if body.is_in_group("Player"):
		emit_signal("caught", is_alcohol())
		queue_free()
