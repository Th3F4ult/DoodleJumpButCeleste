extends StaticBody2D
@onready var _follow :PathFollow2D = get_parent()
var rng = RandomNumberGenerator.new()
var MOVERNG = rng.randf_range(50, 300)
func _physics_process(delta):
	_follow.set_progress(_follow.get_progress() + MOVERNG * delta)
