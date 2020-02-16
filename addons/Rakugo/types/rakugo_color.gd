extends RakugoVar
class_name RakugoColor

var r: float setget _set_r, _get_r
var g: float setget _set_g, _get_g
var b: float setget _set_b, _get_b
var a: float setget _set_a, _get_a
var h: float setget _set_h, _get_h
var s: float setget _set_s, _get_s
var v: float setget _set_v, _get_v
var r8: int setget _set_r8, _get_r8
var g8: int setget _set_g8, _get_g8
var b8: int setget _set_b8, _get_b8
var a8: int setget _set_a8, _get_a8

func _init(var_id: String, color := Color.white.to_html()
	).(var_id, Color(color), Rakugo.Type.COLOR):
	pass

func _set_value(v: Color) -> void:
	._set_value(v)

func _get_value() -> Color:
	return _value

func _set_r(_r: float) -> void:
	_value.r = _r

func _get_r() -> float:
	return _value.r

func _set_g(_g: float) -> void:
	_value.g = _g

func _get_g() -> float:
	return _value.g

func _set_b(_b: float) -> void:
	_value.b = _b

func _get_b() -> float:
	return _value.b

func _set_a(_a: float) -> void:
	_value.a = _a

func _get_a() -> float:
	return _value.a

func _set_h(_h: float) -> void:
	_value.h = _h

func _get_h() -> float:
	return _value.h

func _set_s(_s: float) -> void:
	_value.s = _s

func _get_s() -> float:
	return _value.s

func _set_v(_v: float) -> void:
	_value.v = _v

func _get_v() -> float:
	return _value.v

func _set_r8(_r8: int) -> void:
	_value.r8 = _r8

func _get_r8() -> int:
	return _value.r8

func _set_g8(_g8: int) -> void:
	_value.g8 = _g8

func _get_g8() -> int:
	return _value.g8

func _set_b8(_b8: int) -> void:
	_value.b8 = _b8

func _get_b8() -> int:
	return _value.b8

func _set_a8(_a8: int) -> void:
	_value.a8 = _a8

func _get_a8() -> int:
	return _value.a8

func form_String(f: String) -> void:
	_value = Color(f)

func form_int(f: int) -> void:
	_value = Color(f)

func from_rgba(r: float, g: float, b: float, a := 1.0) -> void:
	_value = Color(r, g, b, a)

func from_hsv(h: float, s: float, v: float, a := 1.0) -> void:
	_value.from_hsv(h, s, v, a)

func blend(over: String) -> void:
	_value.blend(Color(over))

func contrasted() -> void:
	_value = _value.contrasted()

func darkened(amount: float) -> void:
	_value = _value.darkened(amount)

func fgray() -> float:
	return _value.gray()

func inverted() -> void:
	_value = _value.inverted()

func lightened(amount: float) -> void:
	_value = _value.lightened(amount)

func linear_interpolate(b: String, t: float) -> void:
	_value = _value.linear_interpolate(Color(b), t)

func to_html( with_alpha := true ) -> String:
	return _value.to_html(with_alpha)

func to_string() -> String:
	return to_html(true)
