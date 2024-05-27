class_name InventorySlot
extends PanelContainer

@export var type: ItemData.Type

func init(t: ItemData.Type, cms:Vector2):
	type = t
	custom_minimum_size = cms

func _can_drop_data(at_position, data):
	if data is InventoryItem:
		if type == ItemData.Type.MAIN:
			if get_child_count() == 0:
				return true
			elif type == data.get_parent().type:
				return true
			else:
				return get_child(0).data.type == data.data.type
		else:
			return data.data.type == type
	else:
		return false

func _drop_data(at_position, data):
	if get_child_count() > 0:
		var item:= get_child(0)
		if item == data:
			return
		item.reparent(data.reparent())
	data.reparent(self)

func _physics_process(delta):
	pass

func _gui_input(event):
	pass
