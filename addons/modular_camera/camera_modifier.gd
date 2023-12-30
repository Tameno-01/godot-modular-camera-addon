@tool
class_name CameraModifier
extends CameraPropertySetter


# FP stands for Fake Private.
# This means that this variable is accessed from outside this script,
# but should be hidden from the end user.


var _pending_removal := false # FP


func remove():
	_pending_removal = true


func _base_process(delta: float):
	_process(delta)
	_output_properties = properties
