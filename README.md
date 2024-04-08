# ModularCamera

Making a good camera for a game is complicated and can get very convoluted, this addon provides a framework to help handle this complexity in a modular fashion, more precisely, it allows you to:

- Define multiple behaviours for the camera that can be changed at runtime.
- Automatically interpolate between these behaviours.
- Keep track of what behaviour the camera should follow via a priority system.
- Add extra effects like camera shake via modifiers, which work *kind of* like components in an ECS.

**DISCLAIMER:** This addon was **NOT** made with performance in mind.\
This shouldn't be a problem since there's usually only 1 camera in a game at all times.

## What about Phantom Camera?

In all honesty, i didn't know about the existence of Phantom Camera when i started work on this addon. But there are differences that might make this addon better in certain cases.

- Phantom camera offers a sizeable set of out of the box features that are easy and fast to use, but it has limitations and you can't add on to those features yourself without modifying the source code.

- Modular Camera is a robust foundation for you to build your own camera systems, but it's harder and takes more time to use than Phantom Camera.

## Documentation

- [Overview](docs/overview.md)
- [Writing custom behaviours](docs/custom_behaviours.md)
- [Writing custom modifiers](docs/custom_modifiers.md)

You can find class references in the editor via the "search help" button.
