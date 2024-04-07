## Custom Behaviours

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
