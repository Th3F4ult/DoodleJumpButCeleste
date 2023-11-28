extends Node2D
var rng = RandomNumberGenerator.new()
var other = preload("res://platform_normal.tscn").instantiate()
var y = 1050
var NextPlat
var moving = preload("res://platform_moving.tscn").instantiate()
var booster = preload("res://booster_plat.tscn").instantiate()
var killplat = preload("res://platform_kill.tscn").instantiate()
var anotherplat
func _ready():
	pass
	# We will need this for later, assist mode stuff

func _process(delta):
	$Y_MOVABLE.position.y = $Madeline.position.y - 200
	$Y_MOVABLE/Points.text = str(Global.Points)
	if Global.GenTimes > 0:
		GenPlatform()
		anotherplat = rng.randi_range(1,1000)
		if anotherplat > 0 and anotherplat < 300:
			print("Generating one platform")
			other = preload("res://platform_normal.tscn").instantiate()
			other.position.x = rng.randi_range(000,200)
			other.position.y = y + 100
			add_child(other)
		if anotherplat > 300 and anotherplat < 996:
			print("Generating two platforms")
			other = preload("res://platform_normal.tscn").instantiate()
			other.position.x = rng.randi_range(000,200)
			other.position.y = y + 75
			add_child(other)
			other = preload("res://platform_normal.tscn").instantiate()
			other.position.x = rng.randi_range(000,200)
			other.position.y = y + 125
			add_child(other)
		else:
			print("Generating a kill platform")
			killplat = preload("res://platform_kill.tscn").instantiate()
			killplat.position.x = rng.randi_range(000,200)
			killplat.position.y = y + 100
			add_child(killplat)

func GenPlatform():
	NextPlat = rng.randi_range(1,100)
	if NextPlat > 0 and NextPlat < 45:
		other = preload("res://platform_normal.tscn").instantiate()
		other.position.x = rng.randi_range(000,200)
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
		Global.GenTimes = Global.GenTimes - 1 # These push us up like 15 platforms, but their own codes generate another 50 on contact. We SHOULDN'T run out of platforms.

