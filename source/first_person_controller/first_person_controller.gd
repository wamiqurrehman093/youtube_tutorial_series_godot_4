class_name FirstPersonController extends CharacterBody3D


@export var mouse_sensitivity: float = 0.025
@export var minimum_vertical_camera_angle: float = -15.0
@export var maximum_vertical_camera_angle: float = 45.0
@export var movement_speed: float = 4.0

@onready var camera = $camera
@onready var gravity: float = -ProjectSettings.get("physics/3d/default_gravity")


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	var forward_axis: float = Input.get_axis("ui_up", "ui_down")
	var right_axis: float = Input.get_axis("ui_left", "ui_right")
	
	velocity.x = 0
	velocity.z = 0
	
	velocity.z += forward_axis * movement_speed
	velocity.x += right_axis * movement_speed
	
	var horizontal_rotation_angle: float = global_transform.basis.get_euler().y
	velocity = velocity.rotated(Vector3.UP, horizontal_rotation_angle)
	
	velocity.y += gravity * delta
	
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y += -event.relative.x * mouse_sensitivity
		camera.rotation.x += -event.relative.y * mouse_sensitivity
		camera.rotation_degrees.x = clamp(
			camera.rotation_degrees.x, minimum_vertical_camera_angle, maximum_vertical_camera_angle
		)
