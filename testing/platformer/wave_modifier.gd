@tool
class_name CameraModifierWave
extends CameraModifier


@export var speed: float = 10.0
@export var amplitude: float = 0.2


var _time = 0.0


func _process(delta: float):
	_time += speed * delta
	properties.local_pan.x = sin(_time) * amplitude
