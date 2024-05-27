extends CharacterBody3D

@onready var animation_tree = get_node("AnimationTree")
@onready var playback = animation_tree.get("parameters/playback")

@onready var player_mesh = get_node("Knight")
@onready var camroot_h = get_node("Camroot/h")

@export var gravity = 98
@export var jump_force = 100
@export var walk_speed = 7.0
@export var run_speed = 15.0

var idle_node_name = "Idle"
var walk_node_name = "Walk"
var run_node_name = "Run"
var jump_node_name = "Jump"
var attack1_node_name = "Attack1"
var death_node_name = "Death"

# State
var is_attacking:bool
var is_walking:bool
var is_running:bool
var is_dead:bool

# Values
var direction:Vector3
var h_vel:Vector3
var v_vel:Vector3
var aim_turn: float
var movement: Vector3
var mv_speed: int
var angl_accel: int
var accel: int
var just_hit = false

func _ready() -> void:
	direction = Vector3.BACK.rotated(Vector3.UP, camroot_h.global_transform.basis.get_euler().y)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		aim_turn = -event.relative.x * 0.01
	if event.is_action_pressed("aim"):
		direction = camroot_h.global_transform.basis.z
	
func _physics_process(delta:float) ->void:
	var on_floor = is_on_floor()
	if !is_dead:
		attack1()
		if (!is_on_floor()):
			v_vel = Vector3.DOWN*gravity*delta*2.25
		if(Input.is_action_just_pressed("jump") and is_on_floor() and (!is_attacking)):
			v_vel = Vector3.UP*jump_force
		angl_accel = 12
		mv_speed = 0
		accel = 12
		
		if(attack1_node_name in playback.get_current_node()):
			is_attacking = true
		else:
			is_attacking = false
		
		var h_rot = camroot_h.global_transform.basis.get_euler().y
		if(Input.is_action_pressed("forward") \
		 || Input.is_action_pressed("backward") \
		 || Input.is_action_pressed("right") \
		 || Input.is_action_pressed("left")):
			direction = Vector3(Input.get_action_strength("left")\
			-Input.get_action_strength("right"),\
			0,\
			Input.get_action_strength("forward")\
			 - Input.get_action_strength("backward"))
			direction = direction.rotated(Vector3.UP, h_rot).normalized()
			if(Input.is_action_pressed("run") and (is_walking)):
				mv_speed = run_speed
				is_running = true
			else:
				is_walking = true
				mv_speed = walk_speed
		else:
			is_walking = false
			is_running = false
		if(Input.is_action_pressed("aim")):
			player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, \
			camroot_h.rotation.y, delta*angl_accel)
		else:
			player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y,\
			atan2(direction.x, direction.z), delta*angl_accel)
		if(is_attacking):
			h_vel = h_vel.lerp(direction.normalized()*0.2, delta*accel)
		else:
			h_vel = h_vel.lerp(direction.normalized()*mv_speed, delta*accel)
		velocity.x = h_vel.x +v_vel.x
		velocity.y = h_vel.y+ v_vel.y
		velocity.z = h_vel.z +v_vel.z
		move_and_slide()
	animation_tree["parameters/conditions/IsOnFloor"] = on_floor
	animation_tree["parameters/conditions/IsOnAir"] = !on_floor
	animation_tree["parameters/conditions/IsRunning"] = is_running
	animation_tree["parameters/conditions/IsNotRunning"] = !is_running
	animation_tree["parameters/conditions/IsWalking"] = is_walking
	animation_tree["parameters/conditions/IsNotWalking"] = !is_walking
	animation_tree["parameters/conditions/IsDying"] = is_dead

func attack1():
	if(idle_node_name in playback.get_current_node() or \
	walk_node_name in playback.get_current_node()):
		if Input.is_action_just_pressed("attack"):
			if(!is_attacking):
				playback.travel(attack1_node_name)

func _on_sword_damage_detector_body_entered(body):
	if(body.is_in_group("Monsters") and is_attacking):
		body.hit(GameUi.player_dmg)
		
func hit(dmg):
	if(!just_hit):
		get_node("just_hit").start()
		GameUi.player_health -= dmg
		if(GameUi.player_health <= 0):
			is_dead = true
			playback.travel(death_node_name)

func _on_just_hit_timeout():
	just_hit = false


func _on_animation_tree_animation_finished(anim_name):
	if("Death" in anim_name):
		await get_tree().create_timer(1).timeout
		get_node("../GameOver_overlay").game_over()
