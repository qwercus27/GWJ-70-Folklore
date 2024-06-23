extends Node2D

var view_width = 0
var game_scale = 6
var planter_count = 0
var planted_count = 0
var current_level
var level_cleared = false

# Called when the node enters the scene tree for the first time.
func _ready():
	view_width = get_viewport().size.x
	planted_count = 0
	level_cleared = false
	
	current_level = Global.current_level.instantiate()
	add_child(current_level)
	
	$Player.z_index = 1
	$Player.position = current_level.get_node("StartPos").position * 6
	$Player.get_node("StateMachine").transition_to("Air")

	$HUD.get_node("LevelLabel").text = "Level " + str(current_level.get_path()).split("_")[1]	
	$HUD.get_node("LevelLabel").set_visible(true)
	$HUD.get_node("LevelLabelTimer").start()

	planter_count = current_level.get_node("TileMap").get_used_cells(1).size()
	print(planter_count)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	camera_control()
	player_boundaries()
	
	$HUD.get_node("PlantNumber").text = str(planted_count) + " / " + str(planter_count)
	
func camera_control():
	$Camera.position.x = $Player.position.x
	$Camera.position.x = clamp($Camera.position.x, view_width/2, 
		current_level.get_node("TileMap").get_used_rect().size.x*8*game_scale - view_width/2)

func player_boundaries():
	$Player.position.x = clamp($Player.position.x, 0, 
		current_level.get_node("TileMap").get_used_rect().size.x*8*game_scale)
	
func change_level(level_id):
	current_level.queue_free()
	Global.current_level = load("res://scenes/levels/level_" + str(level_id) + ".tscn")
	_ready()

func _on_player_planted_seed():
	planted_count += 1
	if(planted_count == planter_count):
		level_cleared = true
		$NextLevelTimer.start()
		$HUD/ClearedLabel.visible = true


func _on_next_level_timer_timeout():
	
	print(current_level.get_path())
	var next_level = int(str(current_level.get_path()).split("_")[1]) + 1
	change_level(next_level)
	level_cleared = false
	$HUD/ClearedLabel.visible = false
