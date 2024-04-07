## The properties of the ray cast that prevents this camera form going through walls or other geometry.
## Behind the secenes, this is a shape cast and not a ray cast.
@tool
class_name CameraRayCastProperties
extends Resource


# FP stands for Fake Private.
# This means that this variable is accessed from outside this script,
# but should be hidden from the end user.


enum recovery_types {
	INSTANT,
	LINEAR,
	SMOOTH,
}

## What this raycast can collide with.
@export_flags_3d_physics var colision_mask: int = 0
## The thickness of the ray cast, this is usefull to prvent geometry from crashing into the near clipping plain.
@export var margin_radius: float = 0.05
## How the camera should recover to it's normal position once the obstruction that was triggering the ray cast is no longer present.
@export var recovery_type: recovery_types = recovery_types.SMOOTH
## The speed (if recovery_type is set to LINEAR) or the stiffness (if recovery_type is set to SMOOTH) of the camera's recovery.
@export var recovery_speed_stiffness: float = 4.0


func _get_movement_needed(previous_movement_needed: float, target_movement_needed: float, delta: float) -> float: #FP
	match recovery_type:
		recovery_types.INSTANT:
			return target_movement_needed
		recovery_types.LINEAR:
			var output: float = previous_movement_needed - recovery_speed_stiffness * delta
			output = max(target_movement_needed, output)
			return output
		recovery_types.SMOOTH:
			var output: float = previous_movement_needed / (1.0 + recovery_speed_stiffness * delta)
			output = max(target_movement_needed, output)
			return output
	return 0.0
