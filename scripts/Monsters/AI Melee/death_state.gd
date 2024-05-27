extends Node

var Controller

func _ready():
	Controller = get_parent().get_parent()
	Controller.get_node("AnimationTree").get("parameters/playback").travel("Death")
	
func _physics_process(delta):
	if Controller:
		Controller.velocity.x = 0
		Controller.velocity.z = 0
