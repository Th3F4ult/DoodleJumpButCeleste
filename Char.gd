extends CharacterBody2D
var aimdirection = "right"
var deaths = []
var isDead = false
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var CanDash = true
var TimerLock
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var STOP
var right
var left

func _ready():
	%Assist_Speed_Text.text = "OFF!"
	if not FileAccess.file_exists("user://save"):
		SAVE()
	LOAD()
	add_to_group("player")
	$DashParts.emitting = false
	$HairBlue.visible = false
	Global.CanBeKilledbyPlatform = false
	await get_tree().create_timer(2).timeout
	Global.CanBeKilledbyPlatform = true
func SAVE():
	var save = FileAccess.open("user://save",FileAccess.WRITE)
	save.store_var(deaths)
	save.close()
func LOAD():
	var save = FileAccess.open("user://save",FileAccess.READ)
	deaths = save.get_var()
	save.close()
func _physics_process(delta):
	if not isDead:
		match Global.ControlMode:
			"touch":
				if Input.is_action_just_pressed("ui_left") and aimdirection == "right":
					$Madeline_Sprite.flip_h = true; $HairBlue.flip_h = true; $HairPink.flip_h = true
					$PlayerHitbox.position.x = $PlayerHitbox.position.x + 5
					$DashParts.position.x =+ 5
					aimdirection = "left"
				elif Input.is_action_just_pressed("ui_right") and aimdirection == "left":
					$Madeline_Sprite.flip_h = false; $HairBlue.flip_h = false; $HairPink.flip_h = false
					$PlayerHitbox.position.x = $PlayerHitbox.position.x - 5
					aimdirection = "right"
					$DashParts.position.x = $DashParts.position.x - 5
				var direction = Input.get_axis("ui_left", "ui_right")
				if direction:
						velocity.x = direction * SPEED
				else:
					velocity.x = move_toward(velocity.x, 0, SPEED)
			"acc":
				if Input.get_accelerometer().x <= -2: position.x -= 1 * -Input.get_accelerometer().x
				if Input.get_accelerometer().x >= 2: position.x += 1 * Input.get_accelerometer().x
				if Input.get_accelerometer().x <= -2 and aimdirection == "right":
					$Madeline_Sprite.flip_h = true; $HairBlue.flip_h = true; $HairPink.flip_h = true
					$PlayerHitbox.position.x = $PlayerHitbox.position.x + 5
					$DashParts.position.x =+ 5
					aimdirection = "left"
				elif Input.get_accelerometer().x >= 2 and aimdirection == "left":
					$Madeline_Sprite.flip_h = false; $HairBlue.flip_h = false; $HairPink.flip_h = false
					$PlayerHitbox.position.x = $PlayerHitbox.position.x - 5
					aimdirection = "right"
					$DashParts.position.x = $DashParts.position.x - 5
				var direction = Input.get_axis("ui_left", "ui_right")
				if direction:
						velocity.x = direction * SPEED
				else:
					velocity.x = move_toward(velocity.x, 0, SPEED)
			"TP":
				if aimdirection == "right":
					if not right:
						$Madeline_Sprite.flip_h = true; $HairBlue.flip_h = true; $HairPink.flip_h = true
						$PlayerHitbox.position.x = $PlayerHitbox.position.x + 5
						$DashParts.position.x =+ 5
						right = true
						left = false
				elif aimdirection == "left":
					if not left:
						$Madeline_Sprite.flip_h = false; $HairBlue.flip_h = false; $HairPink.flip_h = false
						$PlayerHitbox.position.x = $PlayerHitbox.position.x - 5
						$DashParts.position.x = $DashParts.position.x - 5
						left = true
						right = false
				if get_global_mouse_position().x <= 220 and get_global_mouse_position().x >= 5:
					position.x = get_global_mouse_position().x
		if Global.boost:
			Global.boost = false
			velocity.y = JUMP_VELOCITY * 5
		if not is_on_floor():
			velocity.y += gravity * delta
		if is_on_floor():
			if Global.CanGetPoint:
				Global.CanGetPoint = false
				Global.Points = Global.Points + 1
			velocity.y = JUMP_VELOCITY * 1.4
			Global.GenTimes = Global.GenTimes + 1
		if Input.is_action_just_pressed("DASH") and not Global.Cheat_Dash:
			DASH(false)
		elif Input.is_action_just_pressed("DASH") and Global.Cheat_Dash:
			DASH(true)
		move_and_slide()

		if velocity.y <= 0:
			$"../KillArea".position.y = position.y + 190
			$Track.limit_bottom = position.y + 150
			$"../Y_MOVABLE".position.y = position.y - 240
	#		$"../PAUSEBTN".position.y = position.y - 240
			$Madeline_Sprite.play("NOSTART")

		if velocity.y >= 0:
			$DashParts.emitting = false
			$Madeline_Sprite.play("Falling_CanDash")
		if Global.isDead and not STOP:
			STOP = true
			deaths.append(position.y)
			SAVE()
func DASH(cheat:bool):
	if not cheat:
		if CanDash:
			Global.CanBeKilledbyPlatform = false
			CanDash = false
			velocity.y = JUMP_VELOCITY * 2
			Global.GenTimes = Global.GenTimes + 3
			$DashParts.emitting = true
			$HairBlue.visible = true
			await get_tree().create_timer(2).timeout
			$HairBlue.visible = false
			CanDash = true
			Global.CanBeKilledbyPlatform = true
	else:
			velocity.y = JUMP_VELOCITY * 2
			Global.GenTimes = Global.GenTimes + 3
			$DashParts.emitting = true
			$HairPink.visible = true

func _input(event):
	if event is InputEventMouseMotion and Global.ControlMode == "TP" and not isDead:
		if event.relative.x <= 0: aimdirection = "right"
		else: aimdirection = "left"
func _on_kill_area_body_entered(body):
	if body.is_in_group("player") and not Global.Cheat_Invuln:
		DIE()
	elif body.is_in_group("player") and Global.Cheat_Invuln:
		velocity.y = -900
func DIE():
	$PlayerHitbox.queue_free()
	isDead = true
	$"../UI_Elements/DeathScreen".visible = true
	if Global.CheatsUsed or Global.Cheat_Dash or Global.Cheat_Invuln or Engine.time_scale != 1:
		%Assist_Indicator.visible = true
	$"../UI_Elements/DeathScreen/Label_Text_1".text = "You died!"
	$"../UI_Elements/DeathScreen/Label_Text_2".text = "Points:"
	$"../UI_Elements/DeathScreen/Label_Text_POINTS".text = str(Global.Points)
	$"../UI_Elements/DeathScreen/Label_Text_3".text = "Strawberries:"
	$"../UI_Elements/DeathScreen/Label_Text_STRAWBERRIES".text = str(Global.StrawBs)



#func _on_touch_screen_button_pressed(): 
	#velocity.x = +200
# I don't remember what this does. Nothing breaks if I remove it.

func DELETE_SAVES():
	var save = FileAccess.open("user://save",FileAccess.WRITE)
	deaths = []
	save.store_var(deaths)
	save.close()
func PAUSE():
	isDead = true
	$"../UI_Elements/Pause_Men".visible = true
func ASSIST_OPTIONS_VISIBLE():
	$"../UI_Elements/Pause_Men/Assist_Invis".visible = not $"../UI_Elements/Pause_Men/Assist_Invis".visible 
func CHANGED_ASSIST_ENGINE_SPEED(value):
	match int(value): # Match does not work with floats, we convert it to an int.
		0: Engine.time_scale = 1; %Assist_Speed_Text.text = "OFF!"
		1: Engine.time_scale = 0.9; %Assist_Speed_Text.text = "90%"
		2: Engine.time_scale = 0.8; %Assist_Speed_Text.text = "80%"
		3: Engine.time_scale = 0.7; %Assist_Speed_Text.text = "70%"
		4: Engine.time_scale = 0.6; %Assist_Speed_Text.text = "60%"
		5: Engine.time_scale = 0.5; %Assist_Speed_Text.text = "50%"
func _on_unpause_pressed():
	isDead = false
	$"../UI_Elements/Pause_Men".visible = false
func RETRY():
	Global.reset()
func INV_TOG(toggled_on):
	Global.CheatsUsed = true
	match toggled_on:
		true: Global.Cheat_Invuln = true; %Assist_Invuln_Text.text = "Invulnerable"
		false: Global.Cheat_Invuln = false; %Assist_Invuln_Text.text = "OFF"
func DASH_INF(toggled_on):
	Global.CheatsUsed = true
	match toggled_on:
		true: Global.Cheat_Dash = true; %Assist_dash_text.text = "Unlimited"; $HairPink.visible = true
		false: Global.Cheat_Dash = false; %Assist_dash_text.text = "Default"; $HairPink.visible = false
