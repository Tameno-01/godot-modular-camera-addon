## Custom Behaviours

To create a new behaviour, make a script file anywhere that extends `CameraBehaviour`.

```gdscript
@tool
class_name NameOfYourBehaviour
extends CameraBehaviour


func _on_start():
	# Runs when the behaviour starts being active
	pass


func _process(delta: float):
	# Runs every frame while the behaviour is active
	pass


func _on_stop():
	# Runs when the behaviour stops being active
	pass
```

Example behaviour:

```gdscript
@tool
class_name CameraBehaviourSpin
extends CameraBehaviour


@export var speed: float = 1.0


func _process(delta: float):
	properties.direction += speed * delta
```

This example behaviour will make the camera rotate around the target.

##

You edit `properties` to control the output of the behaviour.

You can also read `camera` to get the `ModularCamera` node this behaviour is acting on. Here's an example of how we can us this to do our own ray casts:
```gdscript
@tool
class_name RayCastExample
extends CameraBehaviour


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
