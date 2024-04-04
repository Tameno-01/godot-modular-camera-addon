@tool
class_name CameraBehaviourInterpolator
extends CameraBehaviour


# This class is NOT meant to be used by end users


const ANGULAR_PROPERTIES: Array[StringName] = [
	&"direction",
	&"height",
	&"lean",
	&"roll",
	&"pitch",
	&"yaw",
]


var behaviourA: CameraBehaviour
var behaviourB: CameraBehaviour
var interpolation: CameraInterpolation
var camera: ModularCamera
var is_recursed: bool = false


var _time: float
var _turn_dir: float
var _interpolation_managers: Dictionary = {}


signal finished


func _init():
	override_target = true
	override_reference_frame = true


func _on_start():
	_time = 0.0
	behaviourA._interpolation_count += 1
	behaviourB._interpolation_count += 1
	if behaviourA is CameraBehaviourInterpolator:
		behaviourA.behaviourB._interpolation_count += 1
	for property in ANGULAR_PROPERTIES:
		var interpolation_manager: AngleInterpolationManager = AngleInterpolationManager.new()
		interpolation_manager.start(
				behaviourA._output_properties.get(property),
				behaviourB._output_properties.get(property),
		)
		_interpolation_managers[property] = interpolation_manager


func _process(delta: float):
	_time += delta
	var t: float = interpolation.get_t(_time)
	var props := CameraProperties.new()
	behaviourA._base_process(delta)
	behaviourB._base_process(delta)
	props.copy_from(behaviourA._output_properties)
	props.interpolate_to(behaviourB._output_properties, t)
	for property in ANGULAR_PROPERTIES:
		props.set(
				property,
				_interpolation_managers[property].process(
						behaviourA._output_properties.get(property),
						behaviourB._output_properties.get(property),
						t,
				),
		)
	properties = props
	t = interpolation.get_t(_time, true)
	var targetA: Vector3
	if behaviourA.override_target:
		targetA = behaviourA.target_override
	else:
		targetA = camera._get_default_target()
	var targetB: Vector3
	if behaviourB.override_target:
		targetB = behaviourB.target_override
	else:
		targetB = camera._get_default_target()
	target_override = lerp(targetA, targetB, t)
	var reference_frameA: Basis
	if behaviourA.override_reference_frame:
		reference_frameA = behaviourA.reference_frame_override
	else:
		reference_frameA = camera._get_default_reference_frame()
	var reference_frameB: Basis
	if behaviourB.override_reference_frame:
		reference_frameB = behaviourB.reference_frame_override
	else:
		reference_frameB = camera._get_default_reference_frame()
	var quatA: Quaternion = reference_frameA.get_rotation_quaternion()
	var quatB: Quaternion = reference_frameB.get_rotation_quaternion()
	var quat: Quaternion = lerp(quatA, quatB, t)
	reference_frame_override = Basis(quat)
	if _time >= interpolation.duration:
		finished.emit()


func _on_interpolator_a_finished():
	behaviourA.end()
	behaviourA = behaviourA.behaviourB


func end():
	if behaviourA is CameraBehaviourInterpolator:
		behaviourA.end()
		behaviourA.behaviourB._interpolation_count -= 1
	behaviourA._interpolation_count -= 1
	if behaviourA._interpolation_count == 0:
		behaviourA._base_stop()
	behaviourB._interpolation_count -= 1
	if behaviourB._interpolation_count == 0 and is_recursed:
		behaviourB._base_stop()


class AngleInterpolationManager:
	
	const _JUMP_DETECTION_THERSHOLD: float = TAU / 2
	
	var _turn_dir: float
	var _prev_dir_diff: float
	var _dir_diff_offset: float
	
	func start(angleA: float, angleB: float):
		var angle_diff_plus: float = _angle_difference(angleA, angleB, 1.0)
		var angle_diff_minus: float = _angle_difference(angleA, angleB, -1.0)
		if angle_diff_plus < -angle_diff_minus:
			_turn_dir = 1.0
			_prev_dir_diff = angle_diff_plus
		else:
			_turn_dir = -1.0
			_prev_dir_diff = angle_diff_minus
	
	func process(angleA: float, angleB: float, t: float) -> float:
		var dir_diff: float = _angle_difference(angleA, angleB, _turn_dir)
		var dir_diff_delta = dir_diff - _prev_dir_diff
		if dir_diff_delta > _JUMP_DETECTION_THERSHOLD:
			_dir_diff_offset -= TAU
		elif dir_diff_delta < -_JUMP_DETECTION_THERSHOLD:
			_dir_diff_offset += TAU
		_prev_dir_diff = dir_diff
		dir_diff += _dir_diff_offset
		return angleB + dir_diff * (1.0 - t)
	
	static func _angle_difference(angle_a: float, angle_b: float, sign: float) -> float:
		assert(abs(sign) == 1.0)
		angle_a = fposmod(angle_a, TAU)
		angle_b = fposmod(angle_b, TAU)
		if angle_a == angle_b:
			return 0.0
		var output = angle_a - angle_b
		if signf(output) == sign:
			return output
		else:
			output += TAU * sign
			return output
