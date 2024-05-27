extends CharacterBody3D

const SPEED = 2.5
const JUMP_VELOCITY = 4.5

@onready var state_controller = get_node("State_Controller")
@export var player: CharacterBody3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var direction:Vector3
var Awakening = false
var Attacking = false
var dying = false

var health = 5
var dmg = 2

func _ready():
	state_controller.change_state("Idle")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	if player:
		direction = (player.global_transform.origin - self.global_transform.origin)
	move_and_slide()

func _on_chase_player_detection_body_entered(body):
	if "Player" in body.name and !dying:
		print("Detected")
		state_controller.change_state("Run")

func _on_chase_player_detection_body_exited(body):
	if "Player" in body.name and !dying:
		state_controller.change_state("Idle")

func _on_attack_player_detection_body_entered(body):
	if "Player" in body.name and !dying:
		state_controller.change_state("Attack")

func _on_attack_player_detection_body_exited(body):
	if "Player" in body.name and !dying:
		state_controller.change_state("Run")

func _on_animation_tree_animation_finished(anim_name):
	if "Awaken" in anim_name:
		Awakening = false
	elif "Attack" in anim_name:
		if player in get_node("Attack_Player_Detection").get_overlapping_bodies():
			state_controller.change_state("Attack")
	elif "Death" in anim_name:
		self.queue_free()

func hit(dmg):
	health -= dmg
	if(health<=0):
		state_controller.change_state("Death")
	
	# Knockback
	var tween = create_tween()
	tween.tween_property(self, "global_position", global_position - (direction/1.5), 0.2)


func _on_skeleton_blade_detector_body_entered(body):
	if(body.is_in_group("Player") and Attacking):
		body.hit(dmg)
