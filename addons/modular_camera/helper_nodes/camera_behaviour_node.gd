## A helper node to better allow behaviours to interact with the current scene.
@tool
class_name CameraBehaviourNode
extends Node3D


enum update_modes {
	NEVER,
	ON_READY,
	PROCESS,
	PHYSICS_PROCESS,
}

## The behaviour this node holds.
@export var behaviour: CameraBehaviour
## The camera to put this behaviour on.
@export var camera: ModularCamera
## Press this button to make the current camera preview the behaviour.
@export var _preview_behaviour: bool = false:
		set = _set_preview_behaviour
## When to update the behaviour's target_override to this node's position, only relevant if the behaviour's override_target is true.
@export var target_update_mode: update_modes = update_modes.NEVER:
		set = _set_target_update_mode
## Press this button to instantly update the behaviour's target_override to this node's position, only relevant if the behaviour's override_target is true.
@export var _update_target: bool = false:
		set = _set_update_target
## Wether to update the behaviours reference frame along with the target.
@export var also_update_reference_frame: bool = false

## Adds the behaviour to the camera.
func add_behaviour():
	_get_camera().add_behaviour(behaviour)

## Removes the behaviour from the camera.
func remove_behaviour():
	_get_camera().remove_behaviour(behaviour)

## Updates the behaviour's target_override to this node's position
func update_target():
	if behaviour:
		behaviour.target_override = global_position
		if also_update_reference_frame:
			behaviour.reference_frame_override = global_transform.basis

## Makes the current camera preview the behaviour.
func preview_behaviour():
	var camera_now = _get_camera()
	if behaviour and camera_now:
		camera_now._preview_behaviour(behaviour)


func _ready():
	_update_target_update_mode()
	if target_update_mode == update_modes.ON_READY:
		update_target()


func _process(_delta: float):
	_actual_process(_delta)


func _physics_process(_delta: float):
	_actual_process(_delta)


func _actual_process(_delta: float):
	update_target()


func _get_camera() -> ModularCamera:
	if camera:
		return camera
	return ModularCamera.get_of(self)


func _update_target_update_mode():
	match target_update_mode:
		update_modes.NEVER:
			set_process(false)
			set_physics_process(false)
		update_modes.ON_READY:
			set_process(false)
			set_physics_process(false)
		update_modes.PROCESS:
			set_process(true)
			set_physics_process(false)
		update_modes.PHYSICS_PROCESS:
			set_process(false)
			set_physics_process(true)

func _set_target_update_mode(value: update_modes):
	target_update_mode = value
	_update_target_update_mode()


func _set_update_target(value: bool):
	if value:
		update_target()


func _set_preview_behaviour(value: bool):
	if not value:
		return
	var camera_now = _get_camera()
	if camera_now._previewed_behaviour == behaviour:
		camera_now._stop_previewing_behaviour()
	else:
		preview_behaviour()
