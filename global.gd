extends Node

func _ready():
	var savefile = FileAccess.file_exists("user://CONTROLDATA")
	if savefile: var data = FileAccess.open("user://CONTROLDATA",FileAccess.READ); ControlMode = data.get_var()
	else: var data = FileAccess.open("user://CONTROLDATA",FileAccess.WRITE); data.store_var("touch")
func reset():
	GenTimes = 10
	Points = 0
	StrawBs = 0
	isDead = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://level.tscn")
func SAVE(type:String): # We change control type and save it to the config file
	ControlMode = type
	var data = FileAccess.open("user://CONTROLDATA",FileAccess.WRITE); data.store_var(type)
var GenTimes = 10
var Points = 0
var boost = false
var CanBeKilledbyPlatform = true
var StrawBs = 0
var Cheat_Invuln = false
var Cheat_Dash = false
var isDead = false
var CheatsUsed = false
var CanGetPoint = false
var ControlMode
