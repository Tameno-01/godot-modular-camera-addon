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

You can also read `camera` to get the `ModularCamera` node this modifier is acting on. Here's an example of how we can use this to do our own ray casts:

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

Additionally, you can call `remove()` to remove the modifier from whatever behaviour or camera it's added to, this is how `Auto Remove` works in `CameraModifierShake`, here is part of its code:

```gdscript
## Modifier that shakes the camera.
@tool
class_name CameraModifierShake
extends CameraModifier

# ...

## How fast the shake gets less intense, the duration of the shake is 1 / decay.
@export var decay: float = 0.0

# ...

## Whether to remove this modifier when the shake has lost all of it's intensity, only relevant if decay is not 0.
@export var auto_remove: bool = true

# ...

var _decay_left: float

#...

func _process(delta: float):

	# ...

	_decay_left -= decay * delta
	if _decay_left <= 0.0:
		if auto_remove and not Engine.is_editor_hint():
			remove()
		
		#...
	
	#...

# ...
```
