extends Node2D


func _on_point_adder_body_exited(body):
	if body.is_in_group("player"):
		Global.CanGetPoint = true
		$Path2D/PathFollow2D/PointAdder.queue_free()
