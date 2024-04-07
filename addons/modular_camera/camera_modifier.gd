## Base class for all camera modifiers.
@tool
class_name CameraModifier
extends CameraPropertySetter


# FP stands for Fake Private.
# This means that this variable is accessed from outside this script,
# but should be hidden from the end user.


var _pending_removal := false # FP


func _start():
	_on_start()


func _stop():
	_on_stop()

## Removes this modifier from whatever camera or behaviour it's attatched to.
func remove():
	_pending_removal = true


func _base_process(delta: float):
	_process(delta)
	_output_properties = properties


func _on_start():
	pass


func _on_stop():
	pass
