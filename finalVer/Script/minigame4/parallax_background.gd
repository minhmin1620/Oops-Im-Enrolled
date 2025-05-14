extends ParallaxBackground


# Called when the node enters the scene tree for the first time.
func _ready():
	# This prevents sub-pixel jittering
	get_viewport().canvas_transform.origin = Vector2.ZERO
	get_viewport().snap_2d_transforms_to_pixel = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
