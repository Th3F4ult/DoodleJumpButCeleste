extends Area2D

@onready var animation = $Sprite

func _ready():
	animation.play("Idle")

func _on_body_entered(body):
	if body.is_in_group("player"):
		animation.play("Break")
		print("Player_Enter")
		await get_tree().create_timer(0.1).timeout
		Global.boost = true
		Global.GenTimes = Global.GenTimes + 50
		Global.CanBeKilledbyPlatform = false
		await get_tree().create_timer(2).timeout
		Global.CanBeKilledbyPlatform = true
		queue_free()
