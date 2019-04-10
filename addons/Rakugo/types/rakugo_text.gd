extends RakugoVar
class_name RakugoText

func _init(var_id:String, var_value:String
	).(var_id, var_value, Rakugo.Type.TEXT):
	pass

func _set_value(var_value:String) -> void:
	._set_value(var_value)

func _get_value() -> String:
	return _value

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

func percent_decode() -> String:
	return _value.percent_decode()

func percent_encode() -> String:
	return _value.percent_encode()

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

func right(position:int) -> String:
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








