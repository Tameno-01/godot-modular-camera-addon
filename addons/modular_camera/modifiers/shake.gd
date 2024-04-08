## Modifier that shakes the camera.
@tool
class_name CameraModifierShake
extends CameraModifier


const FLIP_OFFSET = TAU / 2

## Press this to reset the shake in the inspector.
@export var _reset := false: # _ Because users aren't meant to access this value through code
		set = _set_reset
## How intentse the shake is
@export var intensity: float = 0.1
## How fast the shake is
@export var speed: float = 40.0
## How fast the shake gets less instense, the duration of the shake is 1 / decay.
@export var decay: float = 0.0
## How much tha camera should shake horizontally.
@export var horizontal_intensity: float = 1.0
## How much the camera should shake veritically.
@export var vertical_intenisty: float = 1.0
## How much to randomize the speed of the horizontal and vertial shakes.
@export_range(0.0, 0.99) var speed_random: float = 0.3
## Whether to remove this modifier when the shake has lost all of it's intensity, only relevant if decay is not 0.
@export var auto_remove: bool = true

var _horizontal_progress: float
var _vertical_progress: float
var _decay_left: float
var _actual_horizontal_speed: float
var _actual_vertical_speed: float


func _on_start():
	reset()


func _process(delta: float):
	_horizontal_progress +=_actual_horizontal_speed * delta
	_vertical_progress += _actual_vertical_speed * delta
	if _horizontal_progress > TAU:
		_horizontal_progress -= TAU
		_actual_horizontal_speed = speed * (1.0 - randf() * speed_random)
	if _vertical_progress > TAU:
		_vertical_progress -= TAU
		_actual_vertical_speed = speed * (1.0 - randf() * speed_random)
	_decay_left -= decay * delta
	if _decay_left <= 0.0:
		if auto_remove and not Engine.is_editor_hint():
			remove()
		else:
			_decay_left = 0.0
	var actual_intensity = intensity * pow(_decay_left, 2.0)
	properties.local_pan = Vector2(
		sin(_horizontal_progress) * actual_intensity * horizontal_intensity,
		sin(_vertical_progress) * actual_intensity * vertical_intenisty,
	)

## Resets the shake.
func reset():
	_horizontal_progress = 0 if randf() < 0.5 else FLIP_OFFSET
	_vertical_progress = 0 if randf() < 0.5 else FLIP_OFFSET
	_decay_left = 1.0
	_actual_horizontal_speed = speed * (1.0 - randf() * speed_random)
	_actual_vertical_speed = speed * (1.0 - randf() * speed_random)


func _set_reset(value: bool):
	if value:
		reset()
