@tool
class_name CameraBehaviourNode
extends Node3D


enum target_update_modes {
	NEVER,
	ON_READY,
	PROCESS,
	PHYSICS_PROCESS,
}


@export var behaviour: CameraBehaviour
@export var target_update_mode: target_update_modes = target_update_modes.NEVER:
		set = _set_target_update_mode
@export var _update_target: bool = false:
		set = _set_update_target
@export var camera: ModularCamera


func update_target():
	if behaviour:
		behaviour.target_override = global_position


func _ready():
	_update_target_update_mode()
	if target_update_mode == target_update_modes.ON_READY:
		update_target()


func _process(_delta: float):
	_actual_process(_delta)


func _physics_process(_delta: float):
	_actual_process(_delta)


func _actual_process(_delta: float):
	if behaviour:
		behaviour.target_override = global_position


func _set_target_update_mode(value: target_update_modes):
	target_update_mode = value
	_update_target_update_mode()


func _update_target_update_mode():
	match target_update_mode:
		target_update_modes.NEVER:
			set_process(false)
			set_physics_process(false)
		target_update_modes.ON_READY:
			set_process(false)
			set_physics_process(false)
		target_update_modes.PROCESS:
			set_process(true)
			set_physics_process(false)
		target_update_modes.PHYSICS_PROCESS:
			set_process(false)
			set_physics_process(true)


func _set_update_target(value: bool):
	if value:
		update_target()
