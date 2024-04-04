@tool
class_name CameraProperties
extends Resource

@export var distance: float = 1.0
@export var direction: float = 0.0
@export var height: float = 0.0
@export var lean: float = 0.0
@export var roll: float = 0.0
@export var pitch: float = 0.0
@export var yaw: float = 0.0
@export var pan := Vector2.ZERO
@export var local_pan := Vector2.ZERO
@export var offset := Vector3.ZERO
@export var fov_multiplier: float = 1.0


func add(properties: CameraProperties):
	distance *= properties.distance
	direction += properties.direction
	height += properties.height
	lean += properties.lean
	roll += properties.roll
	pitch += properties.pitch
	yaw += properties.yaw
	pan += properties.pan
	local_pan += properties.local_pan
	offset += properties.offset
	fov_multiplier *= properties.fov_multiplier


func interpolate_to(properties: CameraProperties, t: float):
	distance = lerp(distance, properties.distance, t)
	direction = lerp_angle(direction, properties.direction, t)
	height = lerp(height, properties.height, t)
	lean = lerp(lean, properties.lean, t)
	roll = lerp(roll, properties.roll, t)
	pitch = lerp(pitch, properties.pitch, t)
	yaw = lerp(yaw, properties.yaw, t)
	pan = lerp(pan, properties.pan, t)
	local_pan = lerp(local_pan, properties.local_pan, t)
	offset = lerp(offset, properties.offset, t)
	fov_multiplier = lerp(fov_multiplier, properties.fov_multiplier, t)


func copy_from(properties: CameraProperties):
	distance = properties.distance
	direction = properties.direction
	height = properties.height
	lean = properties.lean
	roll = properties.roll
	pitch = properties.pitch
	yaw = properties.yaw
	pan = properties.pan
	local_pan = properties.local_pan
	offset = properties.offset
	fov_multiplier = properties.fov_multiplier
