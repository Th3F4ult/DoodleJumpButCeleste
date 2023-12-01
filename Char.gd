extends CharacterBody2D

var aimdirection = "right"

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var CanDash = true
var TimerLock
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") 
@onready var Anim = $Madeline_Sprite
func _ready():
	add_to_group("player")
	$DashParts.emitting = false
	$HairBlue.visible = false
	Global.CanBeKilledbyPlatform = false
	await get_tree().create_timer(2).timeout
	Global.CanBeKilledbyPlatform = true
	

func _physics_process(delta): 
	
	if Input.is_action_just_pressed("ui_left") and aimdirection == "right":
		$Madeline_Sprite.flip_h = true
		$HairBlue.flip_h = true
		$PlayerHitbox.position.x = $PlayerHitbox.position.x + 5
		$DashParts.position.x =+ 5
		aimdirection = "left"
	elif Input.is_action_just_pressed("ui_right") and aimdirection == "left":
		$Madeline_Sprite.flip_h = false
		$HairBlue.flip_h = false
		$PlayerHitbox.position.x = $PlayerHitbox.position.x - 5
		aimdirection = "right"
		$DashParts.position.x = $DashParts.position.x - 5
		
	if Global.boost:
		Global.boost = false
		velocity.y = JUMP_VELOCITY * 5
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_floor():
		velocity.y = JUMP_VELOCITY * 1.4
		Global.GenTimes = Global.GenTimes + 1
		
	if Input.is_action_just_pressed("DASH") and CanDash and not Global.Cheat_Dash:
		TimerLock = true
		CanDash = false
		velocity.y = JUMP_VELOCITY * 2
		Global.GenTimes = Global.GenTimes + 3
		$DashParts.emitting = true
		$HairBlue.visible = true
		Global.CanBeKilledbyPlatform = false
		await get_tree().create_timer(0.8).timeout
		Global.CanBeKilledbyPlatform = true
	elif Input.is_action_just_pressed("DASH") and Global.Cheat_Dash:
		velocity.y = JUMP_VELOCITY * 2
		Global.GenTimes = Global.GenTimes + 3
		$DashParts.emitting = true
		$HairBlue.visible = true
		await get_tree().create_timer(0.1).timeout
		$HairBlue.visible = false


	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if Input.get_accelerometer().x < -3:
		velocity.x = velocity.x - 200
	if Input.get_accelerometer().x > 3:
		velocity.x = velocity.x + 200
	move_and_slide()
	
	if velocity.y <= 0:
		$"../KillArea".position.y = position.y + 180
		$Track.limit_bottom = position.y + 150
		$"../Y_MOVABLE".position.y = position.y - 240
		$"../PAUSEBTN".position.y = position.y - 240
		Anim.play("NOSTART")

	if velocity.y >= 0:
		$DashParts.emitting = false
		Anim.play("Falling_CanDash")

	if TimerLock:
		$"../TimeToDash".start()
		TimerLock = false






func _on_kill_area_body_entered(body):
	if body.is_in_group("player") and not Global.Cheat_Invuln:
		Global.isDead = true
	elif body.is_in_group("player") and Global.Cheat_Invuln:
		velocity.y = -600



func _on_time_to_dash_timeout():
		CanDash = true
		$HairBlue.visible = false


func _on_touch_screen_button_pressed():
	velocity.x = +200
