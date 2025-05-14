extends Camera2D

@export var brian : CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var cam_width = get_viewport_rect().size.x / self.zoom.x
	var cam_height = get_viewport_rect().size.y / self.zoom.y
	var level_width = 1152
	var level_height = 648
	position.x = clamp(brian.position.x, cam_width / 2, level_width - cam_width / 2)
	position.y = clamp(brian.position.y, cam_height / 2, level_height - cam_height / 2)
