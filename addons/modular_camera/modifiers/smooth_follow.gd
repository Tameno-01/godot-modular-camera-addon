## Modifier that makes the camera smoothly follow the target
@tool
class_name CameraModifierSmoothFollow
extends CameraModifier



@export var stiffness: float = 2.0


var _current_position: Vector3


func _on_start():
	_current_position = camera.get_target()


func _process(delta: float):
	var target_position: Vector3 = camera.get_target()
	if not Engine.is_editor_hint():
		print(target_position)
	var movement: Vector3 = target_position - _current_position
	movement *= stiffness * delta
	_current_position += movement
	properties.offset = camera.get_reference_frame().inverse() * (_current_position - target_position)
