@tool
class_name RayCastExample
extends CameraModifier


var _ray_cast: RayCast3D


func _on_start():
	_ray_cast = RayCast3D.new()
	# ... set up the ray cast
	get_camera().add_child(_ray_cast)


func _process(delta: float):
	# ...
	pass


func _on_stop():
	# We make sure to remove the ray cast node once we don't need it anymore.
	_ray_cast.queue_free()
