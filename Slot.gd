extends TextureRect
class_name Slot

@export var current_item: ItemData

func _ready() -> void:
	set_item_slot()
	
func set_item_slot() -> void:
	if not current_item:
		return
	%ItemTexture.texture = current_item.item_texture
	%ItemAmount.text = str(current_item.item_amount)
	 
