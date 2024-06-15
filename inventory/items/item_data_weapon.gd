class_name ItemDataWeapon
extends ItemData


# ItemDataWeapon is a data class that defines a weapon.

# It should contain all STATIC data that is common between all weapons.
# Since we are extending ItemData we also have all of it's properties too.


# You'll probably want to give weapons a model scene for visuals.
# You might even have stuff like particle effects or something here.
@export var model: PackedScene
@export var damage: int = 0
