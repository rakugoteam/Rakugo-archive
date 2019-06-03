extends RakugoVar
# class_name RakugoVector2

var x : float
var y : float

func _init ( float x, float y ) -> void:


func abs () -> Vector2:


func angle () -> float:


func angle_to ( Vector2 to ) -> float:


func angle_to_point ( Vector2 to ) -> float:


func aspect () -> float:


func bounce ( Vector2 n ) -> Vector2:


func ceil () -> Vector2:


func clamped ( float length ) -> Vector2:

func cross ( Vector2 with ) -> float:


func cubic_interpolate ( Vector2 b, Vector2 pre_a, Vector2 post_b, float t ) -> Vector2:
func distance_squared_to ( Vector2 to ) -> float:
func distance_to ( Vector2 to ) -> float:
func dot ( Vector2 with ) -> float:
func floor () -> Vector2:
func is_normalized () -> bool:
func length () -> float:
func length_squared () -> float:
func linear_interpolate ( Vector2 b, float t ) -> Vector2:
func normalized () -> Vector2:
func project ( Vector2 b ) -> Vector2:
func reflect ( Vector2 n ) -> Vector2:
func rotated ( float phi ) -> Vector2:
func round () -> Vector2:
func slerp ( Vector2 b, float t ) -> Vector2:
func slide ( Vector2 n ) -> Vector2:
func snapped ( Vector2 by ) -> Vector2:
func tangent () -> Vector2:
