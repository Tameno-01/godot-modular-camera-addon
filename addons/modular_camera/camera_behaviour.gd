## Base class for all camera behaviours.
@tool
class_name CameraBehaviour
extends CameraPropertySetter


# FP stands for Fake Private.
# This means that this variable is accessed from outside this script,
# but should be hidden from the end user.

## The list of modifiers of this behaviour, this should never be touched outside the inspector.
@export var modifiers: Array[CameraModifier] = []:
		set = _set_modifers
## The priority of this behviour, the camera pickes the behaviour with the highest priority.
@export var priority: int = 0
## The interpolation used when swicthing to this behaviour.
@export var in_interpolation: CameraInterpolation
## The interpolation used when swicthing from this behaviour.
@export var out_interpolation: CameraInterpolation
## Wether to use target_override.
@export var override_target: bool = false
## The target of the camera when this behaviour is active, only used if override_target is true.
@export var target_override: Vector3
## Wether to use reference_frame_override.
@export var override_reference_frame: bool = false
## The reference frame of the camera when this behaviour is active, only used if override_reference_frame is true.
@export var reference_frame_override: Basis
## Wether to use raycast_override.
@export var override_raycast: bool = false
## The ray cast the camera will use when this behaviour is active, only used if override_raycast is true.
@export var raycast_override: CameraRayCastProperties


var _usage_count: int = 0 # FP
var _prev_modifiers: Array[CameraModifier] = modifiers


func _start():
	_on_start()
	_output_properties.copy_from(properties)
	for modifier in modifiers:
		modifier._base_start()
		_output_properties.add(modifier._output_properties)


func _stop():
	_on_stop()
	for modifier in modifiers:
		modifier._base_stop()


func _base_process(delta: float):
	_process(delta)
	_output_properties.copy_from(properties)
	var i: int = 0
	while i < modifiers.size(): # This is not a for loop because the array may change size.
		var modifier: CameraModifier = modifiers[i]
		if not modifier:
			i += 1
			continue
		modifier._base_base_process(delta)
		if modifier._pending_removal:
			modifier._base_stop()
			modifiers.pop_at(i)
			modifier._pending_removal = false
		else:
			_output_properties.add(modifier._output_properties)
			i += 1

## Adds a modifier to the modifiers list.
func add_modifier(modifier: CameraModifier):
	if modifiers.has(modifier):
		ModularCameraUtils.print_detailed_err("Tried to add modifier, but modifier has alredy been added.")
		return
	modifiers.append(modifier)
	if _started:
		modifier._base_start()

## Removes a modifier from the modifiers list.
func remove_modifier(modifier: CameraBehaviour):
	if not modifiers.has(modifier):
		ModularCameraUtils.print_detailed_err("Tried to remove modifier, but modifier is not in modifiers list.")
		return
	modifiers.erase(modifier)
	if _started:
		modifier._base_stop()


func _set_modifers(value: Array[CameraModifier]):
	modifiers = value
	if not _started:
		_prev_modifiers = modifiers
		return
	for modifier in modifiers:
		if not modifier:
			continue
		if not _prev_modifiers.has(modifier):
			modifier._base_start()
	for modifier in _prev_modifiers:
		if not modifier:
			continue
		if not modifiers.has(modifier):
			modifier._base_stop()
	_prev_modifiers = modifiers


func _on_start():
	pass


func _on_stop():
	pass
