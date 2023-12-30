# Getting started

## Quick start
1. Install the addon.
2. In a scene of choice, add a new `ModularCamera`.
3. Set its `Target` to whatever you want the camera to follow.
4. Set its `Default Behaviour` to a new `CameraBehaviourStatic`.
5. Set the behaviour's `Static Properties` to a new `CameraProperties`.
6. Mess around with the `CameraProperties`'s parameters.

## Why was that so convoluted?
What you are messing around with right now are the core values with which the position of a camera is defined. they are purposefully redundant, as it's meant to be easy to move the camera in exactly the way you want it.

The whole deal with the `CameraBehaviour` is becasue, well, we need to tell the camera how to behave, so we told it that it's behaviour should be to be being still (relative to its `target`), that's why we gave it a `CameraBehaviourStatic`. In a real game, you will want to make your own `CameraBehaviour`s, but we're getting ahead of ourselves.

The point of having the behaviour of the camera be encapsulated in a class is so we can change it at runtime. for example, you wold want the camera to behave differntly when you get in a vehicle vs when your walking, or change during a custcene, or change to an over the shoulder view if you pick up a weapon, or change depending on what part of the level you're in in a 3d platformer, the examples go on and on.