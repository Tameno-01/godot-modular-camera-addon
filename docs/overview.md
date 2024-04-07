# Overview

## Quick start

1. Install the addon and enable it.
2. In a scene of choice, add a new `ModularCamera`.
3. Set its `Target` to whatever you want the camera to follow.
4. Set its `Default Behaviour` to a new `CameraBehaviourStatic`.
5. Set the behaviour's `Static Properties` to a new `CameraProperties`.
6. Mess around with the `CameraProperties`'s parameters.

## What did we just do?

What you are messing around with right now are the core values with which the position of a camera is defined. they are purposefully redundant, as it's meant to be easy to move the camera in exactly the way you want it.

The whole deal with the `CameraBehaviour` is because, well, we need to tell the camera how to behave, so we told it that it's behaviour should be to be being still (relative to its `target`), that's why we gave it a `CameraBehaviourStatic`. In a real game, you will want to make your own `CameraBehaviour`s, but we're getting ahead of ourselves.

The point of having the behaviour of the camera be encapsulated in a class is so we can change it at runtime. for example, you would want the camera to behave differently when you get in a vehicle vs when your walking, or change during a cutscene, or change to an over the shoulder view if you pick up a weapon, or change depending on what part of the level you're in in a 3d platformer, the examples go on and on.

## Changing the behaviour at runtime

Here's an example script for an `Area3D`
```gdscript
extends Area3D


@export var camera: ModularCamera
@export var player: CollisionObject3D
@export var behaviour: CameraBehaviour


func _on_body_entered(body):
	if body == player:
		camera.add_behaviour(behaviour)


func _on_body_exited(body):
	if body == player:
		camera.remove_behaviour(behaviour)
```
After supplying it a camera, a player and a behaviour in the inspector, this simple scrip will change the behaviour of the camera when the player enters the area.

### Wait wait wait, `add_behaviour` and `remove_behaviour`?

Yes, there's no `set_behaviour`. instead, there's a list of all behaviours the camera could have, which you add and remove items from, and then the camera will always pick the behaviour with the highest `priority`\*\*

\*Ties are solved by picking the behaviour that was added most recently

\*The `priority` of the `default_behaviour` is ignored, everything has a higher property than the `default_behaviour`.

### Why bother with the priority thing??

Imagine a game where you can pick up weapons and get in a vehicles, and you want different camera behaviour for when you're holding a ranged weapon (maybe an over the shoulder perspective for better aiming), and another different behaviour for when you're in a vehicle.

Now imagine you get out of a vehicle, you just switch the camera to the default behaviour, right? wrong. If you were holding a weapon, you'd need to have switched to the ranged weapon behaviour.

So now you need some sort of centralized system to keep track of what camera behaviour to switch to.

With a priority system, you simply assign a higher priority to the vehicle behaviour, have all the systems individually add and remove their behaviours from the behaviour list, and you're done. No centralized system needed, everything gets handled automatically.

This example might seem trivial, but in games with a lot of behaviours the camera can be in, you can end up having a very messy centralized system, so removing the need from it *is* useful (...hopefully).

## Modifiers

If you followed the quick start section, do the following:

1. In either the default behaviour or the camera itself, look for the `modifiers` list (the distinction between doing it on the camera or on the behaviour is important, but it doesn't matter for this example)
2. Add a new element to the list
3. Set the new element to a new `CameraModifierConstant`
4. Set the modifier's `Constant Properties` to a new `CameraProperties`
5. Mess around with the `CameraProperties`'s parameters.

As you can see, what you're messing around with *adds on* to what the behaviour is doing, this is the core principle of how modifiers work.

The biggest use case for modifiers is camera shake, in fact, try it! Add a `CameraModifierShake` to the `modifiers` list.

### Why does it matter if i do it on the camera or on the behaviour?

Any modifiers that are on behaviours will stop being applied once the camera switches to another behaviour, whereas if you do it on the camera, the modifier will always be applied.

## Interpolation

If you're been following along, try settings the `ModularCamera`'s `Default Interpolation` to a new `CameraInterpolation`.
Now, every time the camera switches behaviours, it will smoothly interpolate between them.

You can also assign interpolations to behaviours, so if you, for example, want a fast transition when zooming in and out with your weapon, but a slow transition when getting into a vehicle, you can do that by setting the `In Interpolation` and `Out Interpolation` of their respective behaviours.

Now, let's say you have behaviors A and B, and you interpolate between them, will you see behaviour A's `Out Interpolation` or behaviour B's `In Interpolation`? You can control this by setting the `CameraInterpolation`'s `Priority`. The interpolation with the **highest** priority will be chosen\*\*.

\*Ties are solved by picking the `In Interpolation`.

\*The `Priority` of the `ModularCamera`'s `Default Interpolation` is ignored. Everything has a higher priority than it.

## The ray cast

The ray cast is what prevents the camera from going into walls or other geometry.

## The reference frame

You only need to touch the reference frame if you're making a game with no defined up direction, unless you're making a game like super mario galaxy or a space game in general where up can be anywhere, don't bother reading this section.

The reference frame is essentially the rotation everything is relative to.

The camera's relative transform to the target gets multiplied by the reference frame matrix after all the behaviour and modifier calculations are done.

## Important notes

There are a few... let's say... rules you should always follow:

1. **Individual behaviours and modifiers should only be in one place at a time**. If you have to cameras, make sure they use different instances of behaviours, and make sure you never put the same instance of a modifier on two behaviours at once.
2. **Do not use `CameraBehaviourInterpolator`**, I would hide it if i could. It's an internal class used for handling interpolation.
3. **Anything that isn't documented should not be used.**
