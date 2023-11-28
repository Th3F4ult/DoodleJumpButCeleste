extends Node2D
var rng = RandomNumberGenerator.new()
var other = preload("res://platform_normal.tscn").instantiate()
var y = 1050
var NextPlat
var moving = preload("res://platform_moving.tscn").instantiate()
var booster = preload("res://booster_plat.tscn").instantiate()
func _ready():
	pass
	# We will need this for later, assist mode stuff
func _process(delta):
	$Y_MOVABLE.position.y = $Madeline.position.y - 200
	$Y_MOVABLE/Points.text = str(Global.Points)
	if Global.GenTimes > 0:
		print(NextPlat)
		NextPlat = rng.randf_range(1,100)
		if NextPlat > 0 and NextPlat < 45:
			other = preload("res://platform_normal.tscn").instantiate()
			other.position.x = rng.randf_range(100,200)
			other.position.y = y
			add_child(other)
			y = y - 150
			Global.GenTimes = Global.GenTimes - 1
		elif NextPlat > 45 and NextPlat < 98:
			moving = preload("res://platform_moving.tscn").instantiate()
			moving.position.x = 120
			moving.position.y = y
			add_child(moving)
			y = y - 150
			Global.GenTimes = Global.GenTimes - 1
		elif NextPlat > 98:
			booster = preload("res://booster_plat.tscn").instantiate()
			booster.position.x = rng.randf_range(10,230)
			booster.position.y = y
			add_child(booster)
			y = y - 150
			Global.GenTimes = Global.GenTimes - 1
