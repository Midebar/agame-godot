extends Node

var Controller

func _ready():
	Controller = get_parent().get_parent()
	if Controller.Awakening:
		await Controller.get_node("AnimationTree").animation_finished
	Controller.get_node("AnimationTree").get("parameters/playback").travel("Idle")
	Controller.Attacking = false
	
func _physics_process(delta):
	if Controller:
		Controller.velocity.x = 0
		Controller.velocity.z = 0
