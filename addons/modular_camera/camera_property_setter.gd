@tool
class_name CameraPropertySetter
extends Resource


# FP stands for Fake Private.
# This means that this variable is accessed from outside this script,
# but should be hidden from the end user.


var properties := CameraProperties.new()


var _output_properties := CameraProperties.new() # FP
var _started: bool = false # FP


func _start(): # FP
	if _started:
		printerr("(CameraProperySetter) Trying to start behaviour/modifier, but it has aredy been started")
		return
	_started = true
	if has_method(&"_on_start"):
		call(&"_on_start")


func _stop(): # FP
	if not _started:
		printerr("(CameraProperySetter) Trying to stop behaviour/modifier, but it is already stopped")
		return
	_started = false
	if has_method(&"_on_stop"):
		call(&"_on_stop")


func _base_process(delta: float):
	pass


func _process(delta: float):
	pass
