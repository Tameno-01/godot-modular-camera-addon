@tool
class_name CameraInterpolation
extends Resource


enum INTERPOLATION_TYPES {
	LINEAR,
	EASE_IN,
	EASE_OUT,
	EASE_IN_OUT,
	INSTANT,
	CURVE,
}


@export var duration: float = 1.0
@export var type: INTERPOLATION_TYPES = INTERPOLATION_TYPES.EASE_IN_OUT
@export var curve: Curve
@export var use_different_curve_for_target: bool = false
@export var target_type: INTERPOLATION_TYPES = INTERPOLATION_TYPES.EASE_IN_OUT
@export var target_curve: Curve
@export var priority: int = 0


func get_t(time, target: bool = false) -> float:
	if time >= duration:
		return 1.0
	if time < 0.0:
		return 0.0
	target = target and use_different_curve_for_target
	var type_now = target_type if target else type
	var curve_now = target_curve if target else curve
	var t = time / duration
	match type_now:
		INTERPOLATION_TYPES.LINEAR:
			return t
		INTERPOLATION_TYPES.EASE_IN:
			return t * t
		INTERPOLATION_TYPES.EASE_OUT:
			t = 1.0 - t
			t *= t
			t = 1.0 - t
			return t
		INTERPOLATION_TYPES.EASE_IN_OUT:
			var flip: bool = t > 0.5
			if flip:
				t = 1.0 - t
			t = t * t * 4.0 / 2.0
			if flip:
				t = 1.0 - t
			return t
		INTERPOLATION_TYPES.INSTANT:
			return 1.0
		INTERPOLATION_TYPES.CURVE:
			if not curve_now:
				return 0.0
			return curve_now.sample(t)
	return 0.0
