extends RakugoVar
class_name RakugoText

var bold : bool setget _set_bold, _get_bold
var italics : bool setget _set_italics, _get_italics
var underline : bool setget _set_underline, _get_underline
var strikethrough : bool setget _set_strikethrough, _get_strikethrough
var code : bool setget _set_code, _get_code
var monospace : bool setget _set_code, _get_code
var center : bool setget _set_center, _get_center
var right : bool setget _set_right, _get_right
var fill : bool setget _set_fill, _get_fill
var indent : bool setget _set_indent, _get_indent
var is_link : bool setget _set_self_url, _get_url
var is_image : bool setget _set_image, _get_image

var link : String setget _set_link, _get_link
var font : String setget _set_font, _get_font
var color : String setget _set_color, _get_color

var _prevfont : String
var _prevurl : String
var _prevcolor : String

func _init(var_id:String, var_value:String
	).(var_id, var_value, Rakugo.Type.TEXT):
	pass

func _set_value(var_value:String) -> void:
	._set_value(var_value)

func _get_value() -> String:
	return _value

func _set_tag(on : bool, open : String, close : String) -> void:
	_value = _value.trim_prefix(open)
	_value = _value.trim_suffix(close)

	if on:
		_value = open + _value + close

func _get_tag(open : String, close : String) -> bool:
	var o = _value.begins_with(open)
	var c = _value.ends_with(close)
	return o && c

func _set_bold(_bold : bool) -> void:
	_set_tag(_bold, "[b]", "[/b]")

func _get_bold() -> bool:
	return _get_tag("[b]", "[/b]")

func _set_italics(_italics : bool) -> void:
	_set_tag(_italics, "[i]", "[/i]")

func _get_italics() -> bool:
	return _get_tag("[i]", "[/i]")

func _set_underline(_underline : bool) -> void:
	_set_tag(_underline, "[u]", "[/u]")

func _get_underline() -> bool:
	return _get_tag("[u]", "[/u]")

func _set_strikethrough(_strikethrough : bool) -> void:
	_set_tag(_strikethrough, "[s]", "[/s]")

func _get_strikethrough() -> bool:
	return _get_tag("[s]", "[/s]")

func _set_code(_code : bool) -> void:
	_set_tag(_code, "[code]", "[/code]")

func _get_code() -> bool:
	return _get_tag("[code]", "[/code]")

func _set_center(_center : bool) -> void:
	_set_tag(_center, "[center]", "[/center]")

func _get_center() -> bool:
	return _get_tag("[center]", "[/center]")

func _set_right(_right : bool) -> void:
	_set_tag(_right, "[right]", "[/right]")

func _get_right() -> bool:
	return _get_tag("[right]", "[/right]")

func _set_fill(_fill : bool) -> void:
	_set_tag(_fill, "[fill]", "[/fill]")

func _get_fill() -> bool:
	return 	_get_tag("[fill]", "[/fill]")

func _set_indent(_indent : bool) -> void:
	_set_tag(_indent, "[indent]", "[/indent]")

func _get_indent() -> bool:
	return 	_get_tag("[indent]", "[/indent]")

func _set_self_url(_url : bool) -> void:
	var o = "[url=" + _prevurl + "]"
	_set_tag(false, o, "[/url]")
	_prevurl = ""

	if _url:
		_prevurl = _value

	_set_tag(_url, "[url]", "[/url]")

func _get_url() -> bool:
	return bool(_prevurl)

func _set_link(_link : String) -> void:
	var o = "[url=" + _prevurl + "]"
	_set_tag(false, o, "[/url]")
	_prevurl = ""

	if _link:
		_prevurl = _link
		o = "[url=" + _link + "]"
		_set_tag(true, o, "[/url]")

func _get_link() -> String:
	return _prevurl

func _set_image(_image : bool) -> void:
	_set_tag(_image, "[img]", "[/img]")

func _get_image() -> bool:
	return 	_get_tag("[img]", "[/img]")

func _set_font(_font : String) -> void:
	var o = "[font=" + _prevfont + "]"
	_set_tag(false, o, "[/font]")

	if _font:
		o = "[font=" + _font + "]"
		_set_tag(true, o, "[/font]")
		_prevfont = _font

func _get_font() -> String:
	return _prevfont

func _set_color(_color : String) -> void:
	var o = "[color=" + _prevcolor + "]"
	_set_tag(false, o, "[/color]")

	if _color:
		o = "[color=" + _color + "]"
		_set_tag(true, o, "[/color]")
		_prevcolor = _color

func _get_color() -> String:
	return _prevcolor

func begins_with(text:String) ->bool:
	return _value.begins_with(text)

func bigrams() -> PoolStringArray:
	return _value.bigrams()

func c_escape() -> String:
	return _value.c_escape()

func c_unescape() -> String:
	return _value.c_unescape()

func capitalize() -> String:
	return _value.capitalize()

func casecmp_to(to:String) -> int:
	return _value.casecmp_to(to)

func dedent() -> String:
	return _value.dedent()

func empty() -> bool:
	return _value.empty()

func ends_with(text:String) -> bool:
	return _value.ends_with(text)

func erase(position:int, chars:int) -> void:
	_value.erase(position, chars)

func find(what:String, from:=0) -> int:
	return _value.find(what, from)

func find_last(what:String) -> int:
	return _value.find_last(what)

func findn(what:String, from:=0) -> int:
	return _value.findn(what, from)

func format(values, placeholder:="_") -> String:
	return _value.format(values, placeholder)

func get_base_dir() -> String:
	return _value.get_base_dir()

func get_basename() -> String:
	return _value.get_basename()

func get_extension() -> String:
	return _value.get_extension()

func get_file()-> String:
	return _value.get_file()

func hash() -> int:
	return _value.hash()

func hex_to_int() ->int:
	return _value.hex_to_int()

func insert(position:int, what:String) -> String:
	return _value.insert(position, what)

func is_abs_path() -> bool:
	return _value.is_abs_path()

func is_rel_path() -> bool:
	return _value.is_rel_path()

func is_subsequence_of(text) -> bool:
	return _value.is_subsequence_of(text)

func is_subsequence_ofi(text) -> bool:
	return _value.is_subsequence_ofi(text)

func is_valid_float() -> bool:
	return _value.is_valid_float()

func is_valid_hex_number(with_prefix:=false) -> bool:
	return _value.s_valid_hex_number(with_prefix)

func is_valid_html_color() -> bool:
	return _value.is_valid_html_color()

func is_valid_identifier() -> bool:
	return _value.is_valid_identifier()

func is_valid_integer() -> bool:
	return _value.is_valid_integer()

func is_valid_ip_address() -> bool:
	return _value.is_valid_ip_address()

func json_escape() -> String:
	return _value.json_escape()

func left(position:int) -> String:
	return _value.left(position)

func length() -> int:
	return _value.length()

func lstrip(chars:String) -> String:
	return _value.lstrip(chars)

func match(expr:String) -> bool:
	return _value.match(expr)

func matchn(expr:String) -> bool:
	return _value.matchn(expr)

func md5_buffer() -> PoolByteArray:
	return _value.md5_buffer()

func md5_text() -> String:
	return _value.md5_text()

func nocasecmp_to(to:String) -> int:
	return _value.nocasecmp_to(to)

func ord_at(at:int) -> int:
	return _value.ord_at(at)

func pad_decimals(digits:int) -> String:
	return _value.pad_decimals(digits)

func pad_zeros(digits:int) -> String:
	return _value.pad_zeros(digits)

func percent_detext() -> String:
	return _value.percent_detext()

func percent_entext() -> String:
	return _value.percent_entext()

func plus_file(file:String) -> String:
	return _value.plus_file(file)

func replace(what:String, forwhat:String) -> String:
	return _value.replace(what, forwhat)

func replacen(what:String, forwhat:String) -> String:
	return _value.replacen(what, forwhat)

func rfind(what:String, from:=-1 ) -> int:
	return _value.rfind(what, from)

func rfindn(what:String, from:=-1 ) -> int:
	return _value.rfindn(what, from)

func right_at(position:int) -> String:
	return _value.right(position)

func rstrip(chars:String) -> String:
	return _value.rstrip(chars)

func sha256_buffer() -> PoolByteArray:
	return _value.sha256_buffer()

func sha256_text() -> String:
	return _value.sha256_text()

func similarity(text:String) -> float:
	return _value.similarity(text)

func split(divisor:String, allow_empty:=true, maxsplit:=0) -> PoolStringArray:
	return _value.split(divisor, allow_empty, maxsplit)

func split_floats(divisor:String, allow_empty:=true) -> PoolRealArray:
	return _value.split_floats(divisor, allow_empty)

func strip_edges(left:=true, right:=true) -> String:
	return _value.strip_edges(left, right)

func substr(from:int, lenght:int) -> String:
	return _value.substr(from, lenght)

func to_ascii() -> PoolByteArray:
	return _value.to_ascii()

func to_float() -> float:
	return _value.to_float()

func to_int() ->int:
	return _value.to_int()

func to_lower() -> String:
	return _value.to_lower()

func to_upper() -> String:
	return _value.to_upper()

func to_utf8() -> PoolByteArray:
	return _value.to_utf8()

func trim_prefix(prefix) -> String:
	return _value.trim_prefix(prefix)

func trim_suffix(suffix) -> String:
	return _value.trim_suffix(suffix)

func xml_escape() -> String:
	return _value.xml_escape()

func xml_unescape() -> String:
	return _value.xml_unescape()

func to_string() -> String:
	return _value

func parse_text(text:String, open:String, close:String) -> String:
	text = .parse_text(text, open, close)

	for i in range(_value.length() ):
		var sa = open + _id + "[" + str(i) + "]" + close

		if text.find(sa) == -1:
			continue # no variable in this string

		text = text.replace(sa, _value[i])

	return text
