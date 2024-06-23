class_name Player
extends CharacterBody2D

signal planted_seed

var speed = 300.0
var jump_v = -450.0
var can_plant = false
var active_planter

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass
	
func _physics_process(delta):
	
	if(can_plant):
		if(Input.is_action_just_pressed("a")):
			active_planter.get_node("SaplingSprite").set_visible(true)
			$PlantActionLabel.set_visible(false)
			planted_seed.emit()
			$PlantAudio.play(0.08)


func _on_interact_area_entered(area):
	
	if(area.is_in_group("planter")):
		active_planter = area.get_parent()
		
		if(not active_planter.get_node("SaplingSprite").visible):
			can_plant = true
			$PlantActionLabel.set_visible(true)


func _on_interact_area_exited(area):
	
	if(area.is_in_group("planter")):
		$PlantActionLabel.set_visible(false)
	can_plant = false
