extends RakugoVar
class_name RakugoVector3

var x : float setget _set_x, _get_x
var y : float setget _set_y, _get_y
var z : float setget _set_z, _get_z

func _init(var_id : String, var_value : Vector3
	).(var_id, var_value, Rakugo.Type.VECT3):
	pass

func _set_value(v : Vector3) -> void:
	._set_value(v)

func _get_value() -> Vector3:
	return _value

func _set_x(_x : float) -> void:
	_value.x = _x

func _get_x() -> float:
	return _value.x

func _set_y(_y : float) -> void:
	_value.y = _y

func _get_y() -> float:
	return _value.y

func _set_z(_z : float) -> void:
	_value.z = _z

func _get_z() -> float:
	return _value.z

func abs () -> Vector3:
	return _value.abs()

func angle () -> float:
	return _value.angle()

func angle_to ( to : Vector3 ) -> float:
	return _value.angle_to(to)

func angle_to_point ( to : Vector3 ) -> float:
	return _value.angle_to_point(to)

func aspect () -> float:
	return _value.aspect()

func bounce ( n : Vector3 ) -> Vector3:
	return _value.bounce(n)

func ceil () -> Vector3:
	return _value.ceil()

func clamped ( length : float ) -> Vector3:
	return _value.clamped(length)

func cross ( with : Vector3 ) -> float:
	return _value.cross(with)

func cubic_interpolate ( b : Vector3, pre_a : Vector3, post_b : Vector3, t : float ) -> Vector3:
	return _value.cubic_interpolate(b, pre_a, post_b, t)

func distance_squared_to ( to : Vector3 ) -> float:
	return _value.distance_squared_to(to)

func distance_to ( to : Vector3 ) -> float:
	return _value.distance_to(to)

func dot ( with : Vector3 ) -> float:
	return _value.dot(with)

func floor () -> Vector3:
	return _value.floor()

func is_normalized () -> bool:
	return _value.is_normalized

func length () -> float:
	return _value.length()

func length_squared () -> float:
	return _value.length_squared()

func linear_interpolate ( b : Vector3, t : float ) -> Vector3:
	return _value.linear_interpolate(b, t)

func normalized () -> Vector3:
	return _value.normalized()

func project ( b : Vector3 ) -> Vector3:
	return _value.project(b)

func reflect ( n : Vector3 ) -> Vector3:
	return _value.reflect(n)

func rotated ( phi : float ) -> Vector3:
	return _value.rotated(phi)

func round () -> Vector3:
	return _value.round()

func slerp ( b : Vector3, t : float ) -> Vector3:
	return _value.slerp(b, t)

func slide ( n : Vector3 ) -> Vector3:
	return _value.slide(n)

func snapped ( by : Vector3 ) -> Vector3:
	return _value.snapped(by)

func tangent () -> Vector3:
	return _value.tangent()
