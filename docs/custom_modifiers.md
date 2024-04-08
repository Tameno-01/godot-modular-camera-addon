## Custom Modifiers

To create a new modifier, make a script file anywhere that extends `CameraModifier`.

```gdscript
@tool
class_name NameOfYourModifier
extends CameraModifier


func _on_start():
	# Runs when the modifier starts being active
	pass


func _process(delta: float):
	# Runs every frame while the modifier is active
	pass


func _on_stop():
	# Runs when the modifier stops being active
	pass
```

Example modifier:

```gdscript
@tool
class_name CameraModifierWave
extends CameraModifier


@export var speed: float = 10.0
@export var amplitude: float = 0.2


var _time = 0.0


func _process(delta: float):
	_time += speed * delta
	properties.local_pan.x = sin(_time) * amplitude
```

This modifier will move the camera left and right in a sine wave.

##

You edit `properties` to control the output of the modifier.

You can also read `camera` to get the `ModularCamera` node this modifier is acting on. Here's an example of how we can us this to do our own ray casts:
```gdscript
@tool
class_name RayCastExample
extends CameraModifier


var _ray_cast: RayCast3D


func _on_start():
	_ray_cast = RayCast3D.new()
	# ... set up the ray cast
	camera.add_child(_ray_cast)


func _process(delta: float):
	# ...
	pass


func _on_stop():
	# We make sure to remove the ray cast node once we don't need it anymore.
	_ray_cast.queue_free()
```
