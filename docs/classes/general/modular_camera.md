# ModularCamera

Extends `Camera3D`

## Description

An advanced camera that can follow behaviours, interpolate between them and have modifiers applied to it.

It also has a built in ray cast to avoid going inside walls an other geometry.

##

### Properties

Type|Name|Default value
:-|:-|:-
`target_modes`|[target_mode](#target_modes-target_mode)|`target_modes.NODE`
`Node3D`|[target_node](#node3d-target_node)|`null`
`Vector3`|[target_position](#vector3-target_pos)|`Vector3.ZERO`
`reference_frame_modes`|[reference_frame_mode](#reference_frame_modes-reference_frame_mode)|`reference_frame_modes.BASIS`
`Node3D`|[reference_frame_node](#node3d-reference_frame_node)|`null`
`Basis`|[reference_frame_basis](#basis-reference_frame_basis)|`Basis.IDENTITY`
[`CameraBehaviour`](../behaviours/camera_behaviour.md)|[default_behaviour](#camerabehaviour-default_behaviour)|`null`
`Array[`[`CameraModifier`](../modifiers/camera_modifier.md)`]`|[modifiers](#arraycameramodifier-modifiers)|`[]`
`float`|[base_fov](#float-base_fov)|`75.0`
`CameraInterpolation`|[default_interpolation](#camerainterpolation-default_interpolation)|`null`
`CameraRayCastProperties`|[default_ray_cast](#cameraraycastproperties-default_ray_cast)|`null`

### Methods

Type|Name
:-|:-
`void`|[add_behaviour](#void-add_behaviour)
`void`|[remove_behaviour](#void-remove_behaviour)
`void`|[add_modifier](#void-add_modifier)
`void`|[remove_modifier](#void-remove_modifier)

## Property descriptions

###  `target_modes` target_mode

Determines wether the camera uses a `target_node` or `target_position` as its target.

### `Node3d` target_node

The node the camera will target, only used if `target_mode` is set to `NODE`

### `Vector3` target_pos

The position the camera will target, only used if `target_mode` is set to `POSITION`

###  `reference_frame_modes` reference_frame_mode

Determines wether the camera uses a `reference_frame_node` or `reference_frame_basis` as its reference frame.

### `Node3d` reference_frame_node

The node the camera will use as a reference frame, only used if `reference_frame_mode` is set to `NODE`

### `Basis` reference_frame_basis

The reference frame of the camera, only used if `reference_frame_mode` is set to `BASIS`

### `CameraBehaviour` default_behaviour

The behaviour the camera follows when the behaviours list is empty.

### `Array[CameraModifier]` modifiers

The list of modifiers which are applied to the camera.

You should **NEVER** touch this outside of the inspector.

### `float` base_fov

The base fov of the camera

### `CameraInterpolation` default_interpolation

The interpolation that is used when interpolating between an behaviour that doesn't have an `out_interpolation` and one that doesn't have an `in_interpolation`.

### `CameraRayCastProperties` default_ray_cast

The settings for the ray cast that is performed to prevent the camera from crashing into walls which are used when the current behaviour has `override_raycast` set to `false`.

## Method descriptions

### `void` add_behaviour

Adds a behaviour to the behaviours list

### `void` remove_behaviour

Removes a behaviour from the behaviours list

### `void` add_modifier

Adds a modifier to the modifiers list

### `void` remove_modifier

Removes a modifier from the modifiers list