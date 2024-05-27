extends Node3D

var camroot_h = 0
var camroot_v = 0

@export var cam_v_max = 35
@export var cam_v_min = -25
var h_sens: float = 0.001
var v_sens: float = 0.001
var h_accel: float = 6.5
var v_accel: float = 6.5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camroot_h += -event.relative.x * h_sens
		camroot_v += event.relative.y * v_sens
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _physics_process(delta: float) -> void:
	camroot_v = clamp(camroot_v, deg_to_rad(cam_v_min), deg_to_rad(cam_v_max))
	get_node("h").rotation.y = lerpf(get_node("h").rotation.y, camroot_h, delta*h_accel)
	get_node("h/v").rotation.x = lerpf(get_node("h/v").rotation.x, camroot_v, delta*v_accel)
