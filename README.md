# Godot 4 Multiplayer Game
An experiment in creating an FPS CTF game.

## Overview

## Authors
- https://github.com/DylWadkins
- https://github.com/arthur-schevey

## Technologies used
- Destruction Plugin - [GitHub](https://github.com/Jummit/godot-destruction-plugin) [MIT]
- First Person Controller - [GitHub](https://github.com/ColormaticStudios/quality-godot-first-person-2) [MIT]
- Resonate Audio Manager - [GitHub](https://github.com/hugemenace/resonate) [MIT] [Docs](https://github.com/hugemenace/resonate/blob/main/docs/getting-started.md)

## Topics Explored + Resources
- Multiplayer
- Environment Destruction
- Shaders
- Particles

## Editor Tips
- **F1** → Search help
- **Ctrl + Click** → Select a symbol to go to the documentation
- **Alt + Left/Right Arrow** → Navigate forward and backward your history in script editor
- **Ctrl + Shift + F** → Find symbol in all files, great for refactoring
- **F** → Focus on a scene object
- **PgDown** → Snap object to floor
- **Q** → Select mode
- **W** → Move mode
- **E** → Rotate mode
- **R** → Scale mode
- **Ctrl + Shift + O** → Quick open scene
- **Ctrl + Alt + O** → Quick open script
- **F5** → Play
- **F6** → Play current scene

## Mechanics

### Destruction
Uses a modified version of the destruction plugin that adds a custom *Destructible* node to Godot.

Add a child to the Destructible for whatever you would like it to be, such as a rigidbody crate model. Make sure the Destructible has a reference to this intact object. Next, give the Destructible a reference to a fractured version of the object.

Adjust the fade delay, shrink delay, and animation (lifetime) duration as desired. Set to -1 to disable. Particles on destroy can optionally be assigned.

To destroy the object, call `destroy(explosive_power)` on the Destructible, `explosive_power` is 1 by default.

#### Generating a Fractured Version
1. Install the **Cell Fracture** addon to blender. 
2. Select the object you'd like to fracture, press `F3`, and adjust settings as desired. 
3. `File > Export > glTF 2.0`
4. Ensure you have the fractured cells selected, not the original mesh (should be done by default) and select `Include > Selected Objects > Export glTF 2.0`.
5. Import .glb into Godot, and reference it in the Destructible.