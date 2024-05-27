extends Node

var Controller
var run = false
func _ready():
	Controller = get_parent().get_parent()
	if Controller.Attacking:
		await Controller.get_node("AnimationTree").animation_finished
		Controller.Attacking = false
	else:
		Controller.get_node("AnimationTree").get("parameters/playback").travel("Awaken")
		Controller.Awakening = true
		await Controller.get_node("AnimationTree").animation_finished
	run = true
	Controller.Awakening = false
	Controller.get_node("AnimationTree").get("parameters/playback").travel("Run")
	
func _physics_process(delta):
	if Controller and run:
		Controller.velocity.x = Controller.direction.x * Controller.SPEED
		Controller.velocity.z = Controller.direction.z * Controller.SPEED
		Controller.look_at(Controller.global_transform.origin + Controller.direction, Vector3(0,1,0))
