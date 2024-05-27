class_name InventoryItem
extends TextureRect

@export var data: ItemData

func _ready():
	if data:
		expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		texture = data.item_texture
		tooltip_text = "%s\n%s\n Stats: %s Damage, %s Defense, %s Healing" % \
		[data.item_name, data.desc, data.item_dmg, data.item_def, data.item_healing]
		if data.item_stackable:
			var label = Label.new()
			label.text = str(data.count)
			label.position = Vector2(24,16)
			add_child(label)
func init(d: ItemData):
	data = d

func _get_drag_data(at_pos):
	set_drag_preview(make_drag_preview(at_pos))
	return self
	
func make_drag_preview(at_pos):
	var t:= TextureRect.new()
	t.texture = self.texture
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.custom_minimum_size = self.size
	t.modulate.a = 0.5
	t.position = Vector2(-at_pos)
	var c:= Control.new()
	c.add_child(t)
	return c
