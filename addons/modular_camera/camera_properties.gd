## The properties with wich the position and roatation of the camera are defined within it's target.
@tool
class_name CameraProperties
extends Resource

## The distance to the target, this property is multiplicative.
@export var distance: float = 1.0
## You can think of this as the rotation around the target's Y axis.
@export var direction: float = 0.0
## You can think of this as the rotation around the target's X axis.
@export var height: float = 0.0
## You can think of this as the rotation around the target's Z axis.
@export var lean: float = 0.0
## You can think of this as the rotation around the camera's Z axis.
@export var roll: float = 0.0
## You can think of this as the rotation around the camera's X axis.
@export var pitch: float = 0.0
## You can think of this as the rotation around the camera's Y axis.
@export var yaw: float = 0.0
## How the camera should be panned, this is relative to distance.
@export var pan := Vector2.ZERO
## How the camera should be panned after all other paramentes are applied.
@export var local_pan := Vector2.ZERO
## How the camrea should be moved after all other settings are applied.
@export var offset := Vector3.ZERO
## What the focal length should be multiplied by, this property is multiplicative.
@export var focal_length_multiplier: float = 1.0

## Adds another set of properties to this set of properties.
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
	focal_length_multiplier *= properties.focal_length_multiplier

## Interpolates this set of properties to another set of properties.
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
	focal_length_multiplier = lerp(focal_length_multiplier, properties.focal_length_multiplier, t)

## Copies another set of properries to this set of properties 
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
	focal_length_multiplier = properties.focal_length_multiplier
