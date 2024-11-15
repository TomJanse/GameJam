# Room System Documentation

## Overview

The `obj_room_system` in this project is responsible for generating roguelike-style floors using predefined rooms. The system connects these rooms in a procedural manner while maintaining rules for room connectivity, size, and gameplay functionality. Each room contains enemies, boundaries, doors, and other data required for gameplay interactions.

### Key Features
- Procedural floor generation with a customizable complexity level.
- Predefined room templates with variable door placements.
- Seamless transitions between rooms, handling enemy spawns, and door states.
- Player tracking and collision management.

---

## Rules for Creating Rooms

### Room Dimensions
- **Tile Size**: 8x8 pixels (defined as `global.tile_size`).
- **Room Size**: 30 tiles wide by 20 tiles high (`global.room_cell_width_in_tiles`, `global.room_cell_height_in_tiles`).

Ensure that room layouts and assets are designed to fit these dimensions exactly.

### Connections
Each room must define its connections using the following boolean array format:
```gml
  [RIGHT, UP, LEFT, DOWN]
```
- Example: [false, true, true, false] indicates a room with doors on the left and top walls.  

- A room must have its doors on the edge of the relevant side, not somewhere in the middle.
- Every door must be 2 tiles wide.
- A door must be in the middle of the relevant side, not somewhere up or down in a corner.

### Tile Indexes

- Spawn Point: `global.spawn_tile_index`
- Doors: `global.door_*_tile_index` for each direction (left, right, up, down).

Update these global variables as needed when modifying the tile map.
### Room Array

Rooms are defined in global.rooms as follows:
```gml
[<Room Object>, RIGHT, UP, LEFT, DOWN]
```
- `Room Object`: Reference to the room asset (e.g., `rm_basic`).
- Door booleans must match the connection array rules.

### Instances
Instances are not coppied over from predefined rooms. There is no use in adding them to your room. Only tiles are coppied. See chapter "Enemy spawing" for more info.

## Floor Generation Details

1. Blueprint Grid:
  - A 2D array (`ds_grid`) representing the floor layout.
  - Each cell contains a boolean array for room connections.

2. Generation Process:
  - Starts at the center of the grid.
  - Random paths are created by connecting adjacent rooms until the desired complexity or population limit is reached.
  - Rooms are placed using predefined templates that match the connection requirements.

3. Room Placement:
  - Rooms are drawn using `draw_room_tiles`, which places tiles, doors, and spawn points.
  - The `place_room` function returns data about door locations, bounds, and enemy spawn tiles.

## Room Transition and Gameplay
### Player Movement

- The player's current room is tracked using their position relative to room bounds.
- On transitioning to a new room:
  - Remaining entities in the previous room are destroyed.
  - The player is "pushed" into the new room to prevent door collisions.

### Door States

Doors automatically open or close based on room-cleared status:
- Open: No enemies remain.
- Closed: Enemies are present.
The `change_door_state` function handles this logic.

### Enemy Spawning
Enemies are not coppied from the predefined rooms due to a limitation in reading instances in rooms. Instead the tiles with the same index as `global.spawn_tile_index` are used to spawn
random groups of enemies that are predefined in `global.enemy_spawn_groups`.  

Enemies are spawned in the specified locations using the `spawn_enemies` function, which takes data from the room's `enemies` array.

## Best Practices

1. Room Design:
  - Use predefined sizes and ensure door placement aligns with connection rules.
  - Avoid overly complex layouts that could lead to disconnected paths.

2. Testing:
  - Verify that rooms render correctly and connections align during gameplay.
  - Ensure enemy spawns and door behaviors function as expected.

3. Global Variables:
  - Always update relevant global variables when adding or modifying assets (e.g., new room templates or tile indexes).

4. Debugging:
  - Use error messages thrown by functions like get_current_room to identify and fix misaligned assets or design issues.

## Data structures
### `_room_data` Structure

| **Property**   | **Type**           | **Description**                                                                                  |
|-----------------|--------------------|--------------------------------------------------------------------------------------------------|
| `enemies`       | `Array<Struct>`    | List of enemy data, each containing coordinates and the object type of the enemy to spawn.       |
| `bounds`        | `Array<Real>`      | Coordinates representing the rectangular bounds of the room: `[left, top, right, bottom]`.       |
| `door_tiles`    | `Array<Array>`     | List of door tile data arrays, each containing `[tile_x, tile_y, tile_index]`.                   |
| `cleared`       | `Bool`             | Whether the room has been cleared of enemies.                                                    |

### `enemies` Struct

| **Property** | **Type**           | **Description**                                                                 |
|--------------|--------------------|---------------------------------------------------------------------------------|
| `spawn_x`    | `Real`             | X-coordinate of the enemy's spawn position on the grid.                         |
| `spawn_y`    | `Real`             | Y-coordinate of the enemy's spawn position on the grid.                         |
| `enemy`      | `Asset.GMObject`   | Reference to the object type of the enemy to spawn (e.g., `obj_enemy_basic`, `obj_boss`). |
