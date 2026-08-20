## Interactive routing
`Shift+W` while routing to choose track width
`Shift+V` while routing to choose via size

To switch to the next available signal layer and insert a via:
Press the `*` key on the numeric keypad, or
Use the `Ctrl+Shift+Wheel Scroll` shortcut combination.
Press `/` (numeric keyboard) to insert a via and release that connection (good for fanouts).

Press `6` to insert a via and not switch layers (continue routing on the same layer).

Press `L` if you click to start routing from a thru hole pad or a via and realize you are on the wrong layer, to step through the available signal layers, without adding a via.

## Component placement
`R` to cycle thru modes during placement

## Selection
`Shift+Tab` to cycle thru overlapping objects

Can disable rooms being added in ECO preferences

`X` or `Y` while dragging to mirror


### Creating a list of custom via sizes:
Create a PadVia library via FIle->New->Install it via PAD Pad Via templates work panel

Go to Rules->Routing->Routing Via Style

In Constraints, select "template preferred". The list of the available sizes from the installed library should appear, but needs to enabled!

## Misc
`F5` to toggle net color override active - allows to see custom colors assigned to nets (net copper basically)

Polygons won't pour if they are outside the board edge
Polygons are a pain with multi-channel (multi-room) design - their nets don't get assigned correctly. 
Copper fills, vias and tracks all seem to propagate across much easier

## Scripts
Scripts are not able to write or read to file system. Knowledge must stay within sch or PCB objects (could be additional parameters etc)

Altium has built-in fast iterator to fetch objects within a rectangular box's reach from a given point - no need to iterate over _all_
objects which would be O(N^2) operation

It is possible to create atomic `Undo` steps for script's various operations
