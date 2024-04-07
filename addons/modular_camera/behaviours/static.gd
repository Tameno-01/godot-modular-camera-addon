## The simplest behaviour, it keeps the camera still at a place (unless modifiers make it move).
@tool
class_name CameraBehaviourStatic
extends CameraBehaviour

## The properties that determine where the camera should be.
@export var constant_properties: CameraProperties : set = _set_properties


func _on_start():
	_set_properties(constant_properties)


func _set_properties(new_properties: CameraProperties):
	if new_properties:
		constant_properties = new_properties
		properties = constant_properties
