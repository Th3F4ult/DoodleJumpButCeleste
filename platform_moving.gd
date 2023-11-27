extends Node2D


func _on_point_adder_body_exited(body):
	if body.is_in_group("player"):
		Global.Points = Global.Points + 1
		$PointAdder.queue_free()
