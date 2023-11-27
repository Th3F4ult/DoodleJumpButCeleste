extends Node2D
var rng = RandomNumberGenerator.new()
var other = preload("res://platform_normal.tscn").instantiate()
var y = 1000
var NextPlat
var moving = preload("res://platform_moving.tscn").instantiate()

func _process(delta):
	$Points.position.y = $Madeline.position.y - 200
	$Points.text = str(Global.Points)
	if Global.GenTimes > 0:
		NextPlat = round((rng.randf_range(1,3) * 10) / 10)
		if NextPlat == 1:
			print(NextPlat, y)
			other = preload("res://platform_normal.tscn").instantiate()
			other.position.x = rng.randf_range(100,200)
			other.position.y = y
			add_child(other)
			y = y - 150
			Global.GenTimes = Global.GenTimes - 1
		elif NextPlat == 2:
			moving = preload("res://platform_moving.tscn").instantiate()
			moving.position.x = 120
			moving.position.y = y
			add_child(moving)
			y = y - 150
			Global.GenTimes = Global.GenTimes - 1



