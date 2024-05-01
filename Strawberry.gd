extends Node2D
func _ready():
	$AnimatedSprite2D.play("Idle")
func _on_straw_area_body_entered(body):
	if body.is_in_group("player"):
		$AnimatedSprite2D.play("Grab")
		$StrawArea.queue_free()
		Global.StrawBs += 1
