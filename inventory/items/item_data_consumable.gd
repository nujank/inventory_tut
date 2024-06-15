class_name ItemDataConsumable
extends ItemData


@export var on_used_effect: ItemEffect = null


func use(unit: Object) -> bool:
	if on_used_effect != null:
		on_used_effect.execute(self, unit)
	return true

func can_use(unit: Object) -> bool:
	return true
