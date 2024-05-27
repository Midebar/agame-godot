extends Node

var Controller

func _ready():
	Controller = get_parent().get_parent()
	if Controller.Awakening:
		await Controller.get_node("AnimationTree").animation_finished
	Controller.Attacking = true
	Controller.get_node("AnimationTree").get("parameters/playback").travel("Attack")
	Controller.look_at(Controller.global_transform.origin + Controller.direction, Vector3(0,1,0))
	
func _physics_process(delta):
	if Controller:
		Controller.velocity.x = 0
		Controller.velocity.z = 0
