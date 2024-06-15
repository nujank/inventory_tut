class_name ItemDataConsumable
extends ItemData


# ItemDataConsumable is a data class that defines an item that can be consumed.
# Important to note consumables aren't just edible items but any items that have
# functionality that is triggered when using it.


# It should contain all STATIC data that is common to all consumable items.
# Since we are extending ItemData we also have all of it's properties too.


# Consumable items have a behavior that is triggered when using
@export var on_used_effect: ItemEffect = null


# When we use an item we must give it a Unit/Entity that is using the item.
# Change Object to whatever your base Unit/Entity class is.
func use(unit: Object) -> bool:
	# If we have an effect to trigger when used
	if on_used_effect != null:
		# We execute the effect, passing in this consumable item and the unit using the item
		on_used_effect.execute(self, unit)
	return true


# Not used.
func can_use(unit: Object) -> bool:
	return true
