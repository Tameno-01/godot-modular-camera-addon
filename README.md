# ModularCamera

Making a good camera for a game is complicated and can get very convoluted, this addon provides a framework to help handle this complexity in a modular fashion, more precisely, it allows you to:

- Define multiple behaviours for the camera that can be changed at runtime.
- Automatically interpolate between these behaviours.
- Keep track of what behaviour the camera should follow via a priority system.
- Add extra effects like camera shake via modifiers, which work *kind of* like components in an ECS.

**DISCLAIMER:** This addon was **NOT** made with performance in mind.\
This shouldn't be a problem since there's usually only 1 camera in a game at all times.

## Documentation

- [Overview](docs/overview.md)
- [Writing custom behaviours](docs/custom_behaviours.md)
- [Writing custom modifiers](docs/custom_modifiers.md)

You can find class references in the editor via the "search help" button.
