## An advanced camera that can follow behaviours, interpolate between them and have modifiers applied to it.
## It also has a built in ray cast to avoid going inside walls and other geometry.
@tool
@icon("res://addons/modular_camera/icons/modular_camera.svg")
class_name ModularCamera
extends Camera3D


# FP stands for Fake Private.
# This means that this variable is accessed from outside this script,
# but should be hidden from the end user.


const INT_MIN = -9223372036854775808


enum target_modes {
	NODE,
	POSITION,
}
enum reference_frame_modes {
	NODE,
	BASIS,
}


@export_category("Targeting")
## Determines wether the camera uses a target_node or target_position as its target.
@export var target_mode: target_modes = target_modes.NODE
## The node the camera will target, only used if target_mode is set to NODE.
@export var target_node: Node3D
## The position the camera will target, only used if target_mode is set to POSITION.
@export var target_position: Vector3
## Determines wether the camera uses a reference_frame_node or reference_frame_basis as its reference frame.
@export var reference_frame_mode: reference_frame_modes = reference_frame_modes.BASIS
## The node the camera will use as a reference frame, only used if reference_frame_mode is set to NODE.
@export var reference_frame_node: Node3D
## The reference frame of the camera, only used if reference_frame_mode is set to BASIS.
@export var reference_frame_basis := Basis.IDENTITY

@export_category("Behaviour")
## The behaviour the camera follows when the behaviours list is empty.
@export var default_behaviour: CameraBehaviour:
		set = _set_default_behaviour
## The list of modifiers which are applied to the camera, this should never be touched outsie the inspector.
@export var modifiers: Array[CameraModifier] = []:
		set = _set_modifers

@export_category("Misc")
## The base fov of the camera.
@export var base_fov: float = 75.0
## The interpolation that is used when interpolating between an behaviour that doesn't have an out_interpolation and one that doesn't have an in_interpolation.
@export var default_interpolation: CameraInterpolation
## The settings for the ray cast that is performed to prevent the camera from crashing into walls which are used when the current behaviour has override_raycast set to false.
@export var default_ray_cast: CameraRayCastProperties
## Press this button to stop previewing the currently previewed behaviour
@export var __stop_previewing_behaviour: bool = false: # Double underscore to not conflict with function name
		set = _set_stop_previewing_behaviour


var _behaviours: Array[CameraBehaviour] = [] # FP


var _current_behaviour: CameraBehaviour
var _interpolator: CameraBehaviourInterpolator = null
var _previewed_behaviour: CameraBehaviour = null
var _shape_cast: ShapeCast3D
var _ray_cast_properties: CameraRayCastProperties
var _prev_raycast_movement_needed: float
var _prev_modifiers: Array[CameraModifier] = modifiers


func _ready():
	_update_behaviour(true)


func _process(delta: float):
	if not _current_behaviour:
		return
	var properties: CameraProperties
	if _interpolator:
		_interpolator._base_base_process(delta)
		properties = _interpolator._output_properties
	elif _previewed_behaviour:
		_previewed_behaviour._base_base_process(delta)
		properties = _previewed_behaviour._output_properties
	else:
		_current_behaviour._base_base_process(delta)
		properties = _current_behaviour._output_properties
	var target: Vector3 = _get_target()
	var reference_frame: Basis = _get_reference_frame()
	_handle_modifiers(properties, delta)
	_update_properties(target, reference_frame, properties)
	_do_ray_cast(target, delta)

## Adds a behaviour to the behaviours list.
func add_behaviour(behaviour: CameraBehaviour):
	if not behaviour:
		ModularCameraUtils.print_detailed_err("Tried to add behaviour, but behaviour is null.")
		return
	if _behaviours.has(behaviour):
		ModularCameraUtils.print_detailed_err("Tried to add behaviour, but behaviour has alredy been added.")
		return
	_behaviours.append(behaviour)
	_update_behaviour()

## Removes a behaviour from the behaviours list.
func remove_behaviour(behaviour: CameraBehaviour):
	if not behaviour:
		ModularCameraUtils.print_detailed_err("Tried to remove behaviour, but behaviour is null.")
		return
	if not _behaviours.has(behaviour):
		ModularCameraUtils.print_detailed_err("Tried to remove behaviour, but behaviour is not in behaviours list.")
		return
	_behaviours.erase(behaviour)
	_update_behaviour()

## Adds a modifier to the modifiers list.
func add_modifier(modifier: CameraModifier):
	if not modifier:
		ModularCameraUtils.print_detailed_err("Tried to add modifier, but modifier is null.")
		return
	if modifiers.has(modifier):
		ModularCameraUtils.print_detailed_err("Tried to add modifier, but modifier has alredy been added.")
		return
	modifiers.append(modifier)
	modifier._base_start(self)

## Removes a modifier from the modifiers list.
func remove_modifier(modifier: CameraModifier):
	if not modifier:
		ModularCameraUtils.print_detailed_err("Tried to remove modifier, but modifier is null.")
		return
	if not modifiers.has(modifier):
		ModularCameraUtils.print_detailed_err("Tried to remove modifier, but modifier is not in modifiers list.")
		return
	modifiers.erase(modifier)
	modifier._base_stop()


func _preview_behaviour(behaviour: CameraBehaviour): # FP
	if behaviour == _previewed_behaviour:
		return
	_previewed_behaviour = behaviour
	if not _previewed_behaviour == _current_behaviour:
		_previewed_behaviour._base_start(self)
		_current_behaviour._base_stop()


func _stop_previewing_behaviour(): # FP
	if not _previewed_behaviour:
		return
	if not _previewed_behaviour == _current_behaviour:
		_previewed_behaviour._base_stop()
		_current_behaviour._base_start(self)
	_previewed_behaviour = null


func _get_target() -> Vector3:
	if _interpolator:
		return _interpolator.target_override
	if _previewed_behaviour:
		if _previewed_behaviour.override_target:
			return _previewed_behaviour.target_override
		else:
			return _get_default_target()
	if _current_behaviour.override_target:
		return _current_behaviour.target_override
	else:
		return _get_default_target()


func _get_default_target() -> Vector3: # FP
	match target_mode:
		target_modes.NODE:
			if is_instance_valid(target_node):
				return target_node.global_position
			else:
				if not Engine.is_editor_hint():
					ModularCameraUtils.print_detailed_err("Target node instance not valid.")
				return Vector3.ZERO
		target_modes.POSITION:
			return target_position
	return Vector3.ZERO


func _get_reference_frame() -> Basis:
	if _interpolator:
		return _interpolator.reference_frame_override
	if _current_behaviour.override_reference_frame:
		return _current_behaviour.reference_frame_override
	else:
		return _get_default_reference_frame()


func _get_default_reference_frame() -> Basis: # FP
	match reference_frame_mode:
		reference_frame_modes.NODE:
			if is_instance_valid(reference_frame_node):
				return reference_frame_node.global_transform.basis
			else:
				if not Engine.is_editor_hint():
					ModularCameraUtils.print_detailed_err("Reference frame node instance not valid.")
				return Basis.IDENTITY
		reference_frame_modes.BASIS:
			return reference_frame_basis
	return Basis.IDENTITY


func _update_behaviour(force_ray_cast_update: bool = false):
	var new_behaviour: CameraBehaviour = _get_current_behaviour()
	if new_behaviour == _current_behaviour:
		if force_ray_cast_update:
			_update_ray_cast()
		return
	if _current_behaviour and new_behaviour:
		_interpolate_to(new_behaviour)
	else:
		if _current_behaviour:
			_current_behaviour._base_stop()
		if new_behaviour:
			new_behaviour._base_start(self)
	if _current_behaviour:
		_current_behaviour._usage_count -= 1
	if new_behaviour:
		new_behaviour._usage_count += 1
	_current_behaviour = new_behaviour
	_update_ray_cast()


func _get_current_raycast_properties() -> CameraRayCastProperties:
	if _previewed_behaviour:
		if _previewed_behaviour.override_raycast:
			return _previewed_behaviour.raycast_override
		else:
			return default_ray_cast
	elif _current_behaviour and _current_behaviour.override_raycast:
		return _current_behaviour.raycast_override
	else:
		return default_ray_cast


func _update_ray_cast():
	var prev_ray_cast_properties = _ray_cast_properties
	_ray_cast_properties = _get_current_raycast_properties()
	if prev_ray_cast_properties == _ray_cast_properties:
		return
	_prev_raycast_movement_needed = 0.0
	if _shape_cast:
		_shape_cast.queue_free()
		_shape_cast = null
	if _ray_cast_properties:
		_shape_cast = ShapeCast3D.new()
		_shape_cast.shape = SphereShape3D.new()
		_shape_cast.shape.radius = _ray_cast_properties.margin_radius
		_shape_cast.enabled = false
		_shape_cast.collision_mask = _ray_cast_properties.colision_mask
		add_child(_shape_cast)


func _get_current_behaviour():
	if _behaviours.size() == 0:
		return default_behaviour
	var max_priority: int = INT_MIN
	var output_behaviour: CameraBehaviour
	for i in _behaviours:
		if i.priority >= max_priority:
			output_behaviour = i
			max_priority = i.priority
	return output_behaviour


func _handle_modifiers(properties: CameraProperties, delta: float):
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
			properties.add(modifier._output_properties)
			i += 1


func _interpolate_to(new_behaviour: CameraBehaviour):
	var new_interpolator := CameraBehaviourInterpolator.new()
	if _interpolator:
		new_interpolator.behaviourA = _interpolator
	else:
		new_interpolator.behaviourA = _current_behaviour
	new_interpolator.behaviourB = new_behaviour
	new_interpolator.out_interpolation = new_behaviour.out_interpolation
	new_interpolator.interpolation = _get_interpolation(new_interpolator.behaviourA, new_interpolator.behaviourB)
	new_interpolator._base_start(self)
	new_interpolator.connect(
				&"finished",
				_on_interpolator_finished,
				CONNECT_DEFERRED + CONNECT_ONE_SHOT,
		)
	if _interpolator:
		_interpolator.disconnect(
				&"finished",
				_on_interpolator_finished,
		)
		new_interpolator.behaviourA.connect(
				&"finished",
				Callable(new_interpolator, &"_on_interpolator_a_finished"),
				CONNECT_DEFERRED + CONNECT_ONE_SHOT,
		)
	_interpolator = new_interpolator


func _on_interpolator_finished():
	_current_behaviour = _interpolator.behaviourB
	_interpolator.end()
	_interpolator = null


func _get_interpolation(behaviourA: CameraBehaviour, behaviourB: CameraBehaviour) -> CameraInterpolation:
	if behaviourA.out_interpolation == null and behaviourB.in_interpolation == null:
		if default_interpolation:
			return default_interpolation
		else:
			var new_interpolation: CameraInterpolation = CameraInterpolation.new()
			new_interpolation.duration = 0.0
			new_interpolation.type = CameraInterpolation.INTERPOLATION_TYPES.INSTANT
			return new_interpolation
	elif behaviourA.out_interpolation == null:
		return behaviourB.in_interpolation
	elif behaviourB.in_interpolation == null:
		return behaviourA.out_interpolation
	elif behaviourA.out_interpolation.priority > behaviourB.in_interpolation.priority:
		return behaviourA.out_interpolation
	else:
		return behaviourB.in_interpolation


func _do_ray_cast(target: Vector3, delta: float):
	if not _ray_cast_properties:
		return
	_shape_cast.global_position = target
	_shape_cast.target_position = -_shape_cast.position
	_shape_cast.force_shapecast_update()
	var movement_needed: float
	if not _shape_cast.is_colliding():
		movement_needed = 0.0
	else:
		movement_needed = 1.0 - _shape_cast.get_closest_collision_safe_fraction()
	if movement_needed == 0.0 and _prev_raycast_movement_needed == 0.0:
		return
	movement_needed = _ray_cast_properties._get_movement_needed(_prev_raycast_movement_needed, movement_needed, delta)
	global_position += global_transform.basis * _shape_cast.position * movement_needed
	_prev_raycast_movement_needed = movement_needed


func _update_properties(target: Vector3, reference_frame: Basis, current_properties: CameraProperties):
	var trans = Transform3D.IDENTITY
	trans = trans.translated(Vector3(current_properties.local_pan.x, current_properties.local_pan.y, 0.0))
	trans = trans.rotated(Vector3.BACK, current_properties.roll)
	trans = trans.rotated(Vector3.RIGHT, current_properties.pitch)
	trans = trans.rotated(Vector3.UP, current_properties.yaw)
	trans = trans.translated(Vector3(current_properties.pan.x, current_properties.pan.y, 1.0) * current_properties.distance)
	trans = trans.rotated(Vector3.LEFT, current_properties.height)
	trans = trans.rotated(Vector3.BACK, current_properties.lean)
	trans = trans.rotated(Vector3.UP, current_properties.direction)
	trans = trans.translated(current_properties.offset)
	trans = Transform3D(reference_frame, Vector3.ZERO) * trans
	trans = trans.translated(target)
	transform = trans
	fov = clampf(base_fov * current_properties.fov_multiplier, 1.0, 179.0)


func _set_default_behaviour(value: CameraBehaviour):
	default_behaviour = value
	_update_behaviour()


func _set_modifers(value: Array[CameraModifier]):
	modifiers = value
	for modifier in modifiers:
		if not modifier:
			continue
		if not _prev_modifiers.has(modifier):
			modifier._base_start(self)
	for modifier in _prev_modifiers:
		if not modifier:
			continue
		if not modifiers.has(modifier):
			modifier._base_stop()
	_prev_modifiers = modifiers


func _set_stop_previewing_behaviour(value: bool):
	if value:
		_stop_previewing_behaviour()
