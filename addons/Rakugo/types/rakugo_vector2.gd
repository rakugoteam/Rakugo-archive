extends RakugoVar
class_name RakugoVector2

var x: float setget _set_x, _get_x
var y: float setget _set_y, _get_y

func _init(var_id: String, var_value: Vector2
		).(var_id, var_value, Rakugo.Type.VECT2):
	pass

func _set_value(v: Vector2) -> void:
	._set_value(v)

func _get_value() -> Vector2:
	return _value

func _set_x(_x: float) -> void:
	_value.x = _x

func _get_x() -> float:
	return _value.x

func _set_y(_y: float) -> void:
	_value.y = _y

func _get_y() -> float:
	return _value.y

func abs () -> Vector2:
	return _value.abs()

func angle () -> float:
	return _value.angle()

func angle_to (to: Vector2) -> float:
	return _value.angle_to(to)

func angle_to_point (to: Vector2) -> float:
	return _value.angle_to_point(to)

func aspect () -> float:
	return _value.aspect()

func bounce ( n: Vector2 ) -> Vector2:
	return _value.bounce(n)

func ceil () -> Vector2:
	return _value.ceil()

func clamped (length: float) -> Vector2:
	return _value.clamped(length)

func cross (with: Vector2) -> float:
	return _value.cross(with)

func cubic_interpolate (b: Vector2, pre_a: Vector2, post_b: Vector2, t: float) -> Vector2:
	return _value.cubic_interpolate(b, pre_a, post_b, t)

func distance_squared_to (to: Vector2) -> float:
	return _value.distance_squared_to(to)

func distance_to (to: Vector2) -> float:
	return _value.distance_to(to)

func dot (with: Vector2) -> float:
	return _value.dot(with)

func floor () -> Vector2:
	return _value.floor()

func is_normalized () -> bool:
	return _value.is_normalized

func length () -> float:
	return _value.length()

func length_squared () -> float:
	return _value.length_squared()

func linear_interpolate (b: Vector2, t: float) -> Vector2:
	return _value.linear_interpolate(b, t)

func normalized () -> Vector2:
	return _value.normalized()

func project (b: Vector2) -> Vector2:
	return _value.project(b)

func reflect (n: Vector2) -> Vector2:
	return _value.reflect(n)

func rotated (phi: float) -> Vector2:
	return _value.rotated(phi)

func round () -> Vector2:
	return _value.round()

func slerp (b: Vector2, t: float) -> Vector2:
	return _value.slerp(b, t)

func slide (n: Vector2) -> Vector2:
	return _value.slide(n)

func snapped (by: Vector2) -> Vector2:
	return _value.snapped(by)

func tangent () -> Vector2:
	return _value.tangent()
