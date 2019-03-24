extends RakugoVar
"""
Base object used to handling Rakugo's variables
"""
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
	
#Stringformat( Variant values, String placeholder={_} )
#Stringget_base_dir()
#Stringget_basename()
#Stringget_extension()
#Stringget_file()
#inthash()
#inthex_to_int()
#Stringinsert( int position, String what )
#boolis_abs_path()
#boolis_rel_path()
#boolis_subsequence_of( String text )
#boolis_subsequence_ofi( String text )
#boolis_valid_float()
#boolis_valid_hex_number( bool with_prefix=False )
#boolis_valid_html_color()
#boolis_valid_identifier()
#boolis_valid_integer()
#boolis_valid_ip_address()
#Stringjson_escape()
#Stringleft( int position )
#intlength()
#Stringlstrip( String chars )
#boolmatch( String expr )
#boolmatchn( String expr )
#PoolByteArraymd5_buffer()
#Stringmd5_text()
#intnocasecmp_to( String to )
#intord_at( int at )
#Stringpad_decimals( int digits )
#Stringpad_zeros( int digits )
#Stringpercent_decode()
#Stringpercent_encode()
#Stringplus_file( String file )
#Stringreplace( String what, String forwhat )
#Stringreplacen( String what, String forwhat )
#intrfind( String what, int from=-1 )
#intrfindn( String what, int from=-1 )
#Stringright( int position )
#PoolStringArrayrsplit( String divisor, bool allow_empty=True, int maxsplit=0 )
#Stringrstrip( String chars )
#PoolByteArraysha256_buffer()
#Stringsha256_text()
#floatsimilarity( String text )
#PoolStringArraysplit( String divisor, bool allow_empty=True, int maxsplit=0 )
#PoolRealArraysplit_floats( String divisor, bool allow_empty=True )
#Stringstrip_edges( bool left=True, bool right=True )
#Stringsubstr( int from, int len )
#PoolByteArrayto_ascii()
#floatto_float()
#intto_int()
#Stringto_lower()
#Stringto_upper()
#PoolByteArrayto_utf8()
#Stringtrim_prefix( String prefix )
#Stringtrim_suffix( String suffix )
#Stringxml_escape()
#Stringxml_unescape()







