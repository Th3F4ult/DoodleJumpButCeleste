extends Node2D
var rng = RandomNumberGenerator.new()
var other = preload("res://platform_normal.tscn").instantiate()
var y = 1000


func _process(delta):
	if Global.GenTimes > 0:
		other = preload("res://platform_normal.tscn").instantiate()
		other.position.x = rng.randf_range(100,200)
		other.position.y = y
		add_child(other)
		y = y - 150
		Global.GenTimes = Global.GenTimes - 1
		print(Global.GenTimes)
