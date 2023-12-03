extends Node2D

@onready var a = $AnimatedSprite2D

func _ready():
	a.play("Idle")

func _on_straw_area_body_entered(body):
	if body.is_in_group("player"):
		a.play("Grab")
		$StrawArea.queue_free()
		Global.StrawBs = Global.StrawBs + 1
