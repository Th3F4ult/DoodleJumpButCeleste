extends Node2D
var rng = RandomNumberGenerator.new()
var other = preload("res://platform_normal.tscn").instantiate()
var y = 1050
var NextPlat
var moving = preload("res://platform_moving.tscn").instantiate()
var booster = preload("res://booster_plat.tscn").instantiate()
var killplat = preload("res://platform_kill.tscn").instantiate()
var anotherplat
var strawberry = preload("res://strawberry.tscn").instantiate()

func _ready():
	$DeathCam/Assist_Indicator.visible = false
	# We will need this for later, assist mode stuff

func _process(delta):
	if Global.isDead:
		$Madeline.velocity.y = 0
		$DeathCam.make_current()
		DEAD()
		$UI_Elements.visible = false
		get_tree().paused = true



	
	$UI_Elements/StrawberryDisplay.text = str(Global.StrawBs)
	$UI_Elements/Points.text = str("Points: ", Global.Points)
	
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


func _on_strawberry_gen_body_entered(body):
	if body.is_in_group("player"):
		strawberry = preload("res://strawberry.tscn").instantiate()
		strawberry.position.y = $Madeline.position.y - 1000
		strawberry.position.x = rng.randf_range(10,230)
		add_child(strawberry)
		$"Strawberry Gen".position.y = $"Strawberry Gen".position.y - 1000


func _on_pausebtn_pressed():
	$UI_Elements.visible = false
	$Pause_Menu_1_Cam.make_current()
	get_tree().paused = not get_tree().paused
	# This SOMEWHAT works. Will do for now.



func _on_assist_engine_speed_value_changed(value):
	if value == 0:
		$Assist_Options_cam/Assist_Engine_Speed/Assist_Speed_Text.text = str("OFF")
		Engine.time_scale = 1
	if value == 1:
		$Assist_Options_cam/Assist_Engine_Speed/Assist_Speed_Text.text = str("50%")
		Engine.time_scale = 0.5
	elif value == 2:
		$Assist_Options_cam/Assist_Engine_Speed/Assist_Speed_Text.text = str("60%")
		Engine.time_scale = 0.6
	elif value == 3:
		$Assist_Options_cam/Assist_Engine_Speed/Assist_Speed_Text.text = str("70%")
		Engine.time_scale = 0.7
	elif value == 4:
		$Assist_Options_cam/Assist_Engine_Speed/Assist_Speed_Text.text = str("80%")
		Engine.time_scale = 0.8
	elif value == 5:
		$Assist_Options_cam/Assist_Engine_Speed/Assist_Speed_Text.text = str("90%")
		Engine.time_scale = 0.9
	else:
		Engine.time_scale = 1


func _on_pausebtn_2_pressed():
	get_tree().paused = not get_tree().paused
	$Madeline/Track.make_current()
	$UI_Elements.visible = true


func _on_as_sist_pressed():
	$Assist_Options_cam.make_current()
	if $Assist_Options_cam/Assist_Engine_Speed.value == 0:
		$Assist_Options_cam/Assist_Engine_Speed/Assist_Speed_Text.text = str("OFF")


func _on_back_btn_pressed():
	
	$Pause_Menu_1_Cam.make_current()


func _on_assist_invuln_toggled(button_pressed):
	if button_pressed:
		Global.Cheat_Invuln = true
		print("NOW")
		$Assist_Options_cam/Assist_Invuln/Assist_Invuln_Text2.text = "Invulnerable"
	else:
		Global.Cheat_Invuln = false
		$Assist_Options_cam/Assist_Invuln/Assist_Invuln_Text2.text = "OFF"
		print("NOT")


func _on_assist_dash_toggled(button_pressed):
	if button_pressed:
		Global.Cheat_Dash = true
		$Assist_Options_cam/Assist_Dash/Assist_dash_text.text = "Unlimited"
	else:
		Global.Cheat_Dash = false
		$Assist_Options_cam/Assist_Dash/Assist_dash_text.text = "Default"
		

func DEAD():
	if Global.Cheat_Dash or Global.Cheat_Invuln or Engine.time_scale != 1:
		$DeathCam/Assist_Indicator.visible = true
	$DeathCam/Label_Text_1.text = "You died!"
	$DeathCam/Label_Text_2.text = "Points:"
	$DeathCam/Label_Text_POINTS.text = str(Global.Points)
	$DeathCam/Label_Text_3.text = "Strawberries:"
	$DeathCam/Label_Text_STRAWBERRIES.text = str(Global.StrawBs)



func _on_button_retry_pressed():
	get_tree().change_scene_to_file("res://level.tscn")
	Global.GenTimes = 10
	Global.Points = 0
	Global.StrawBs = 0
	Global.isDead = false
	get_tree().paused = false


func _on_button_exit_pressed():
	get_tree().quit()
