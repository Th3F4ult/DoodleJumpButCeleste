extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player") and Global.CanBeKilledbyPlatform and not Global.Cheat_Invuln:
		get_tree().change_scene_to_file("res://level.tscn")
		Global.GenTimes = 10
		Global.Points = 0
		Global.StrawBs = 0
