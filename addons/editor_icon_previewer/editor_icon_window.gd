tool
extends AcceptDialog

const SELECT_ICON_MSG = "Select any icon."
const ICON_SIZE_MSG = "Icon size: "
const NUMBER_ICONS_MSG = "Found: "
const SNIPPET_TEMPLATE = "get_icon('%s', 'EditorIcons')"

const MIN_ICON_SIZE = 16
const MAX_ICON_SIZE = 128

var icon_size = MIN_ICON_SIZE
var filter = ''

var _update_queued = false


func _ready():
	$body/split/info/icon/label.text = SELECT_ICON_MSG

	$body/split/info/icon/params/size/range.min_value = MIN_ICON_SIZE
	$body/split/info/icon/params/size/range.max_value = MAX_ICON_SIZE

	$body/split/info/icon/preview.rect_min_size = Vector2(MAX_ICON_SIZE, MAX_ICON_SIZE)

	get_ok().hide() # give more space for icons

	_queue_update()


func _queue_update():

	if not is_inside_tree():
		return

	if _update_queued:
		return

	_update_queued = true

	call_deferred("_update_icons")


func add_icon(p_icon, p_hint_tooltip = ''):
	var icon = TextureRect.new()
	icon.expand = true
	icon.texture = p_icon
	icon.rect_min_size = Vector2(icon_size, icon_size)
	icon.hint_tooltip = p_hint_tooltip
	icon.name = p_hint_tooltip

	icon.connect('gui_input', self, '_icon_gui_input', [icon])

	$body/split/scroll/container.add_child(icon)


func _icon_gui_input(event, icon):

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			# Copy raw icon's name into the clipboard
			OS.clipboard = icon.hint_tooltip
			$body/split/info/icon/copied.show()

		elif event.button_index == BUTTON_RIGHT:
			# Copy icon's name with embedded code into the clipboard
			var snippet = SNIPPET_TEMPLATE % [icon.hint_tooltip]
			OS.clipboard = snippet
			$body/split/info/icon/copied.show()

	elif event is InputEventMouseMotion:
		# Preview hovered icon on the side panel
		$body/split/info/icon/label.text = icon.hint_tooltip
		$body/split/info/icon/preview.texture = icon.texture
		$body/split/info/icon/size.text = ICON_SIZE_MSG + str(icon.texture.get_size())


func _input(event):
	if event is InputEventKey and event.is_pressed() and not event.echo:
		if event.alt and event.scancode == KEY_I:
			if not visible:
				display()
			else:
				hide()

func display():
	popup_centered_ratio(0.5)


func clear():
	for idx in $body/split/scroll/container.get_child_count():
		$body/split/scroll/container.get_child(idx).queue_free()


func _on_size_changed(pixels):
	icon_size = int(clamp(pixels, MIN_ICON_SIZE, MAX_ICON_SIZE))
	_queue_update()


func _update_icons():
	var number = 0

	for idx in $body/split/scroll/container.get_child_count():
		var icon = $body/split/scroll/container.get_child(idx)

		if not filter.is_subsequence_ofi(icon.hint_tooltip):
			icon.visible = false
		else:
			icon.visible = true
			number += 1

		icon.rect_min_size = Vector2(icon_size, icon_size)
		icon.rect_size = icon.rect_min_size

	var sep = $body/split/scroll/container.get_constant('hseparation')
	var cols = int($body/split/scroll.rect_size.x / (icon_size + sep))

	$body/split/scroll/container.columns = cols - 1
	$body/split/info/icon/params/size/pixels.text = str(icon_size) + " px"

	$body/search/found.text = NUMBER_ICONS_MSG + str(number)

	_update_queued = false


func _on_window_visibility_changed():
	if visible:
		_queue_update()


func _on_window_resized():
	_queue_update()


func _on_search_text_changed(text):
	filter = text
	_queue_update()


func _on_container_mouse_exited():
	$body/split/info/icon/label.text = SELECT_ICON_MSG
	$body/split/info/icon/size.text = ''
	$body/split/info/icon/copied.hide()
	$body/split/info/icon/preview.texture = null


func _on_window_about_to_show():
	# For some reason can't get proper rect size, so need to wait
	yield($body/split/scroll/container, 'sort_children')
	$body/search/box.grab_focus()
	_queue_update()


func _on_window_popup_hide():
	# Reset
	filter = ''
	icon_size = MIN_ICON_SIZE

	$body/search/box.text = filter
	$body/split/info/icon/params/size/range.value = icon_size
