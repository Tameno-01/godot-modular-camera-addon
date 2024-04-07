## Modifier that shakes thet camera.
@tool
class_name CameraModifierShake
extends CameraModifier


const FLIP_OFFSET = TAU / 2


@export var _reset := false : set=_set_reset # _ Because users aren't meant to access this value through code
## How intentse the shake is
@export var intensity: float = 0.1
## How fast the shake is
@export var speed: float = 40.0
## How fast the shake gets less instense.
@export var decay: float = 0.0
## Wether to remove this modifier when the shake has lost all of it's intensity, only relevnt if decay is not 0.
@export var auto_remove: bool = true
## How much tha camera should shake horizontally.
@export var horizontal_intensity: float = 1.0
## How much the camera should shake veritically.
@export var vertical_intenisty: float = 1.0
## How fast the horizontal shake should be
@export var horizontal_speed: float = 1.0
## How much to randomize the speed of the horizontal shake.
@export var horizontal_speed_random: float = 0.5
## How fast the vertical shake should be
@export var vertical_speed: float = 1.0
## How much to randomize the speed of the vertical shake.
@export var vertical_speed_random: float = 0.5


var _horizontal_progress: float
var _vertical_progress: float
var _decay_left: float
var _actual_horizontal_speed: float
var _actual_vertical_speed: float


func _on_start():
	reset()


func _process(delta: float):
	_horizontal_progress += speed * _actual_horizontal_speed * delta
	_vertical_progress += speed * _actual_vertical_speed * delta
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
	_actual_horizontal_speed = horizontal_speed * (1.0 - randf() * horizontal_speed_random)
	_actual_vertical_speed = vertical_speed * (1.0 - randf() * vertical_speed_random)


func _set_reset(value: bool):
	if value:
		reset()
