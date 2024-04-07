## Custom Modifiers

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
