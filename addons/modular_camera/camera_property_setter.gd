## This class is NOT meant to be used by end users
@tool
class_name CameraPropertySetter
extends Resource


# FP stands for Fake Private.
# This means that this variable is accessed from outside this script,
# but should be hidden from the end user.


var properties := CameraProperties.new()


var _camera: ModularCamera
var _output_properties := CameraProperties.new() # FP
var active: bool = false # FP


func get_camera() -> ModularCamera:
	return _camera


func _base_start(starting_camera: ModularCamera): # FP
	if active:
		ModularCameraUtils.print_detailed_err("Trying to start behaviour/modifier, but it has aredy been started.")
		return
	active = true
	_camera = starting_camera
	_start()


func _base_stop(): # FP
	if not active:
		ModularCameraUtils.print_detailed_err("Trying to stop behaviour/modifier, but it is already stopped.")
		return
	active = false
	_stop()


func _base_base_process(delta: float): # FP
	if not active:
		ModularCameraUtils.print_detailed_err("Trying to process behaviour/modifier, but it is stopped. active will be set to true.")
		active = true
	_base_process(delta)


func _start():
	pass


func _stop():
	pass


func _base_process(delta: float):
	pass


func _process(delta: float):
	pass
