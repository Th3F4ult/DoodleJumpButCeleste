extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player") and Global.CanBeKilledbyPlatform and not Global.Cheat_Invuln and not Global.isDead:
		Global.isDead = true
