extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var CanDash = true
var TimerLock
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") 
@onready var Anim = $Madeline_Sprite
func _ready():
	add_to_group("player")
	$DashParts.emitting = false
	Anim.play("NOSTART")
	

func _physics_process(delta):

	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_floor():
		velocity.y = JUMP_VELOCITY * 1.4
		Global.GenTimes = Global.GenTimes + 1
		
	if Input.is_action_just_pressed("DASH") and CanDash:
		TimerLock = true
		CanDash = false
		velocity.y = JUMP_VELOCITY * 2
		Global.GenTimes = Global.GenTimes + 3
		$DashParts.emitting = true
		
		

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	
	if velocity.y <= 0:
		$"../KillArea".position.y = position.y + 300
		$Track.limit_bottom = position.y + 300
	if velocity.y >= 0:
		$DashParts.emitting = false
	
	
	if TimerLock:
		$"../TimeToDash".start()
		TimerLock = false




func _on_kill_area_body_entered(body):
	if body.is_in_group("player"):
		queue_free()
		get_tree().change_scene_to_file("res://level.tscn")
		Global.GenTimes = 10


func _on_time_to_dash_timeout():
		CanDash = true
