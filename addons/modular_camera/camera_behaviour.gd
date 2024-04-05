@tool
class_name CameraBehaviour
extends CameraPropertySetter


# FP stands for Fake Private.
# This means that this variable is accessed from outside this script,
# but should be hidden from the end user.


@export var modifiers: Array[CameraModifier] = []
@export var priority: int = 0
@export var in_interpolation: CameraInterpolation
@export var out_interpolation: CameraInterpolation
@export var override_target: bool = false
@export var target_override: Vector3
@export var override_reference_frame: bool = false
@export var reference_frame_override: Basis
@export var override_raycast: bool = false
@export var raycast_override: CameraRayCastProperties


var _interpolation_count: int = 0.0 # FP


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
		modifier._base_process(delta)
		if modifier._pending_removal:
			modifiers.pop_at(i)
		else:
			_output_properties.add(modifier._output_properties)
			i += 1


func add_modifier(modifier: CameraModifier):
	if modifiers.has(modifier):
		printerr("(CameraBehaviour) Tried to add modifier, but modifier has alredy been added.")
		return
	modifiers.append(modifier)
	if _started:
		modifier._base_start()


func _on_start():
	pass


func _on_stop():
	pass
