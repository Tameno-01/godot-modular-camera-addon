# ModularCamera

Making good camera for a game is complicated and can get very convoluted, this addon provides a framework to help handle this complexity in a modular fashion, more precisely, it allows you to:

1. Define multiple behaviours for the camera that can be changed at runtime.
2. Automatically interpolate between these behaviours.
3. Keep track of what behaviour the camera should follow via a priority system.
4. Add extra effects like camera shake via "modifiers", which work *kind of* like components in an ECS.

**DISCLAIMER:** This addon was **NOT** made with performance in mind.\
This shouldn't be a problem since there's usually only 1 camera in a game at all times.

## Documentation
[Getting Started](docs/getting_started.md)

