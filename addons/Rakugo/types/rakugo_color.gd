extends RakugoVar
class_name RakugoColor

var r : float setget _set_r, _get_r
var g : float setget _set_g, _get_g
var b : float setget _set_b, _get_b
var a : float setget _set_a, _get_a
var h : float setget _set_h, _get_h
var s : float setget _set_s, _get_s
var v : float setget _set_v, _get_v
var r8 : int setget _set_r8, _get_r8
var g8 : int setget _set_g8, _get_g8
var b8 : int setget _set_b8, _get_b8
var a8 : int setget _set_a8, _get_a8

func _init(var_id : String, color := Color.white.to_html()
	).(var_id, color, Rakugo.Type.COLOR):
	pass

func _set_value(v : Color) -> void:
	._set_value(v)

func _get_value() -> Color:
	return _value

func _set_r(_r : float) -> void:
	_value.r = _r

func _get_r() -> float:
	return _value.r

func _set_g(_g : float) -> void:
	_value.g = _g

func _get_g() -> float:
	return _value.g

func _set_b(_b : float) -> void:
	_value.b = _b

func _get_b() -> float:
	return _value.b

func _set_a(_a : float) -> void:
	_value.a = _a

func _get_a() -> float:
	return _value.a

func _set_h(_h : float) -> void:
	_value.h = _h

func _get_h() -> float:
	return _value.h

func _set_s(_s : float) -> void:
	_value.s = _s

func _get_s() -> float:
	return _value.s

func _set_v(_v : float) -> void:
	_value.v = _v

func _get_v() -> float:
	return _value.v

func _set_r8(_r8 : int) -> void:
	_value.r8 = _r8

func _get_r8() -> int:
	return _value.r8

func _set_g8(_g8 : int) -> void:
	_value.g8 = _g8

func _get_g8() -> int:
	return _value.g8

func _set_b8(_b8 : int) -> void:
	_value.b8 = _b8

func _get_b8() -> int:
	return _value.b8

func _set_a8(_a8 : int) -> void:
	_value.a8 = _a8

func _get_a8() -> int:
	return _value.a8

func gray() -> void:
	_value = Color.gray

func aliceblue() -> void:
	_value = Color.aliceblue

func antiquewhite() -> void:
	_value = Color.antiquewhite

func aqua() -> void:
	_value = Color.aqua

func aquamarine() -> void:
	_value = Color.aquamarine

func azure() -> void:
	_value = Color.azure

func beige() -> void:
	_value = Color.beige

func bisque() -> void:
	_value = Color.bisque

func black() -> void:
	_value = Color.black

func blanchedalmond() -> void:
	_value = Color.blanchedalmond

func blue() -> void:
	_value = Color.blue

func blueviolet() -> void:
	_value = Color.blueviolet

func brown() -> void:
	_value = Color.brown

func burlywood() -> void:
	_value = Color.burlywood

func cadetblue() -> void:
	_value = Color.cadetblue

func chartreuse() -> void:
	_value = Color.chartreuse

func chocolate() -> void:
	_value = Color.chocolate

func coral() -> void:
	_value = Color.coral

func cornflower() -> void:
	_value = Color.cornflower

func cornsilk() -> void:
	_value = Color.cornsilk

func crimson() -> void:
	_value = Color.crimson

func cyan() -> void:
	_value = Color.cyan

func darkblue() -> void:
	_value = Color.darkblue

func darkcyan() -> void:
	_value = Color.darkcyan

func darkgoldenrod() -> void:
	_value = Color.darkgoldenrod

func darkgray() -> void:
	_value = Color.darkgray

func darkgreen() -> void:
	_value = Color.darkgreen

func darkkhaki() -> void:
	_value = Color.darkkhaki

func darkmagenta() -> void:
	_value = Color.darkmagenta

func darkolivegreen() -> void:
	_value = Color.darkolivegreen

func darkorange() -> void:
	_value = Color.darkorange

func darkorchid() -> void:
	_value = Color.darkorchid

func darkred() -> void:
	_value = Color.darkred

func darksalmon() -> void:
	_value = Color.darksalmon

func darkseagreen() -> void:
	_value = Color.darkseagreen

func darkslateblue() -> void:
	_value = Color.darkslateblue

func darkslategray() -> void:
	_value = Color.darkslategray

func darkturquoise() -> void:
	_value = Color.darkturquoise

func darkviolet() -> void:
	_value = Color.darkviolet

func deeppink() -> void:
	_value = Color.deeppink

func deepskyblue() -> void:
	_value = Color.deepskyblue

func dimgray() -> void:
	_value = Color.dimgray

func dodgerblue() -> void:
	_value = Color.dodgerblue

func firebrick() -> void:
	_value = Color.firebrick

func floralwhite() -> void:
	_value = Color.floralwhite

func forestgreen() -> void:
	_value = Color.forestgreen

func fuchsia() -> void:
	_value = Color.fuchsia

func gainsboro() -> void:
	_value = Color.gainsboro

func ghostwhite() -> void:
	_value = Color.ghostwhite

func gold() -> void:
	_value = Color.gold

func goldenrod() -> void:
	_value = Color.goldenrod

func green() -> void:
	_value = Color.green

func greenyellow() -> void:
	_value = Color.greenyellow

func honeydew() -> void:
	_value = Color.honeydew

func hotpink() -> void:
	_value = Color.hotpink

func indianred() -> void:
	_value = Color.indianred

func indigo() -> void:
	_value = Color.indigo

func ivory() -> void:
	_value = Color.ivory

func khaki() -> void:
	_value = Color.khaki

func lavender() -> void:
	_value = Color.lavender

func lavenderblush() -> void:
	_value = Color.lavenderblush

func lawngreen() -> void:
	_value = Color.lawngreen

func lemonchiffon() -> void:
	_value = Color.lemonchiffon

func lightblue() -> void:
	_value = Color.lightblue

func lightcoral() -> void:
	_value = Color.lightcoral

func lightcyan() -> void:
	_value = Color.lightcyan

func lightgoldenrod() -> void:
	_value = Color.lightgoldenrod

func lightgray() -> void:
	_value = Color.lightgray

func lightgreen() -> void:
	_value = Color.lightgreen

func lightpink() -> void:
	_value = Color.lightpink

func lightsalmon() -> void:
	_value = Color.lightsalmon

func lightseagreen() -> void:
	_value = Color.lightseagreen

func lightskyblue() -> void:
	_value = Color.lightskyblue

func lightslategray() -> void:
	_value = Color.lightslategray

func lightsteelblue() -> void:
	_value = Color.lightsteelblue

func lightyellow() -> void:
	_value = Color.lightyellow

func lime() -> void:
	_value = Color.lime

func limegreen() -> void:
	_value = Color.limegreen

func linen() -> void:
	_value = Color.linen

func magenta() -> void:
	_value = Color.magenta

func maroon() -> void:
	_value = Color.maroon

func mediumaquamarine() -> void:
	_value = Color.mediumaquamarine

func mediumblue() -> void:
	_value = Color.mediumblue

func mediumorchid() -> void:
	_value = Color.mediumorchid

func mediumpurple() -> void:
	_value = Color.mediumpurple

func mediumseagreen() -> void:
	_value = Color.mediumseagreen

func mediumslateblue() -> void:
	_value = Color.mediumslateblue

func mediumspringgreen() -> void:
	_value = Color.mediumspringgreen

func mediumturquoise() -> void:
	_value = Color.mediumturquoise

func mediumvioletred() -> void:
	_value = Color.mediumvioletred

func midnightblue() -> void:
	_value = Color.midnightblue

func mintcream() -> void:
	_value = Color.mintcream

func mistyrose() -> void:
	_value = Color.mistyrose

func moccasin() -> void:
	_value = Color.moccasin

func navajowhite() -> void:
	_value = Color.navajowhite

func navyblue() -> void:
	_value = Color.navyblue

func oldlace() -> void:
	_value = Color.oldlace

func olive() -> void:
	_value = Color.olive

func olivedrab() -> void:
	_value = Color.olivedrab

func orange() -> void:
	_value = Color.orange

func orangered() -> void:
	_value = Color.orangered

func orchid() -> void:
	_value = Color.orchid

func palegoldenrod() -> void:
	_value = Color.palegoldenrod

func palegreen() -> void:
	_value = Color.palegreen

func paleturquoise() -> void:
	_value = Color.paleturquoise

func palevioletred() -> void:
	_value = Color.palevioletred

func papayawhip() -> void:
	_value = Color.papayawhip

func peachpuff() -> void:
	_value = Color.peachpuff

func peru() -> void:
	_value = Color.peru

func pink() -> void:
	_value = Color.pink

func plum() -> void:
	_value = Color.plum

func powderblue() -> void:
	_value = Color.powderblue

func purple() -> void:
	_value = Color.purple

func rebeccapurple() -> void:
	_value = Color.rebeccapurple

func red() -> void:
	_value = Color.red

func rosybrown() -> void:
	_value = Color.rosybrown

func royalblue() -> void:
	_value = Color.royalblue

func saddlebrown() -> void:
	_value = Color.saddlebrown

func salmon() -> void:
	_value = Color.salmon

func sandybrown() -> void:
	_value = Color.sandybrown

func seagreen() -> void:
	_value = Color.seagreen

func seashell() -> void:
	_value = Color.seashell

func sienna() -> void:
	_value = Color.sienna

func silver() -> void:
	_value = Color.silver

func skyblue() -> void:
	_value = Color.skyblue

func slateblue() -> void:
	_value = Color.slateblue

func slategray() -> void:
	_value = Color.slategray

func snow() -> void:
	_value = Color.snow

func springgreen() -> void:
	_value = Color.springgreen

func steelblue() -> void:
	_value = Color.steelblue

func tan() -> void:
	_value = Color.tan

func teal() -> void:
	_value = Color.teal

func thistle() -> void:
	_value = Color.thistle

func tomato() -> void:
	_value = Color.tomato

func turquoise() -> void:
	_value = Color.turquoise

func violet() -> void:
	_value = Color.violet

func webgray() -> void:
	_value = Color.webgray

func webgreen() -> void:
	_value = Color.webgreen

func webmaroon() -> void:
	_value = Color.webmaroon

func webpurple() -> void:
	_value = Color.webpurple

func wheat() -> void:
	_value = Color.wheat

func white() -> void:
	_value = Color.white

func whitesmoke() -> void:
	_value = Color.whitesmoke

func yellow() -> void:
	_value = Color.yellow

func yellowgreen() -> void:
	_value = Color.yellowgreen

func form_String( f : String ) -> void:
	_value = Color(f)

func form_int( f : int ) -> void:
	_value = Color(f)

func from_rgba( r : float, g : float, b : float, a := 1.0 ) -> void:
	_value = Color(r, g, b, a)

func from_hsv( h : float, s : float, v : float, a := 1.0 ) -> void:
	_value.from_hsv(h, s, v, a)

func blend( over: String ) -> void:
	_value.blend(Color(over))

func contrasted() -> void:
	_value = _value.contrasted()

func darkened( amount : float ) -> void:
	_value = _value.darkened(amount)

func fgray() -> float:
	return _value.gray()

func inverted() -> void:
	_value = _value.inverted()

func lightened( amount : float ) -> void:
	_value = _value.lightened(amount)

func linear_interpolate( b : String, t : float ) -> void:
	_value = _value.linear_interpolate(Color(b), t)

func to_html( with_alpha := true ) -> String:
	return _value.to_html(with_alpha)

func to_string() -> String:
	return to_html(true)
