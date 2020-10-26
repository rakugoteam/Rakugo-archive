tool
extends OptionButton


signal markup_selected(markup)


func _on_item_selected(index):
	emit_signal('markup_selected', get_item_text(index))
