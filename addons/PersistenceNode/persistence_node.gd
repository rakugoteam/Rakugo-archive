# MIT License
#
# Copyright (c) 2018 Matías Muñoz Espinoza
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

tool
extends Node

enum Mode {MODE_ENCRYPTED, MODE_TEXT}
export (Mode) var mode = MODE_ENCRYPTED setget set_mode, get_mode
export (String) var password = "" setget set_password, get_password
export (String) var folder_name = "PersistenceNode" setget set_folder_name, get_folder_name
export (Array) var no_valid_names = ["default", "example"] setget _private, get_no_valid_names
export (bool) var debug = false setget set_debug, get_debug

# 1.0.5
# Source: https://github.com/YeldhamDev/json-beautifier-for-godot
var beautifier setget _private, _private
export (bool) var beautifier_active = true setget set_beautifier_active, get_beautifier_active

export (int) var profile_name_min_size = 3 setget set_profile_name_min_size, get_profile_name_min_size
export (int) var profile_name_max_size = 15 setget set_profile_name_max_size, get_profile_name_max_size

# Data del profile actual, esta data se puede modificar y luego usar
# save_data()
var data = {} setget _private, get_data

signal saved
signal loaded

func _init():
	if beautifier_active:
		beautifier = load("res://addons/json_beautifier/json_beautifier.gd").new()

func _ready():
	connect("saved", self, "_on_saved")
	connect("loaded", self, "_on_loaded")

func _on_saved():
	# Muestra los datos en la salida una vez que se graba el archivo.
	if beautifier_active and mode == MODE_TEXT:
		debug("_on_saved()")
		print_json(to_json(data))

func _on_loaded():
	# Muestra los datos en la salida una vez que se graba el archivo.
	if beautifier_active and mode == MODE_TEXT:
		debug("_on_loaded()")
		print_json(to_json(data))

func _private(val = null):
	debug("Acceso de escritura/lectura es privado")

# Métodos públicos
#

func debug(message, something1 = "", something2 = ""):
	if debug:
		print("[PersistenceNode] ", message, " ", something1, " ", something2)

# Salva el juego con el profile indicado en el parámetro profile_name. 
# Si no hay profile crea un profile por defecto llamado default. 
func save_data(profile_name = null):
	var result
	
	# Crea la carpeta principal si esta no existe
	create_main_folder()
	
	# Crea el profile por defecto, en el caso de que no se quiera
	# utilizar profiles.
	if profile_name == null:
		if save_profile_default():
			emit_signal("saved")
			debug("save_profile_default() retorna true")
			return true
		else:
			debug("save_profile_default() retorna falso")
			return false
	
	if validate_profile(profile_name):
		match mode:
			MODE_ENCRYPTED:
				result = save_profile_encripted(profile_name)
			MODE_TEXT:
				result = save_profile_text(profile_name)
	else:
		debug("No ha pasado la validación")
		result = false
	
	if result:
		emit_signal("saved")
	
	return result

# Remueve el profile indicado como argumento. Tome en cuenta que para
# eliminar el encriptado o el texto, debe establecer primero el modo
# con set_mode().
func remove_profile(profile_name):
	var dir = Directory.new()
	var path
	
	match mode:
		MODE_ENCRYPTED:
			path = str("user://", folder_name, "/", profile_name, ".save")
		MODE_TEXT:
			path = str("user://", folder_name, "/", profile_name, ".txt")
	
	var err = dir.remove(path)
	
	if err != OK:
		debug("Error al remover el profile: ", err)
		return false
	else:
		data = {}
	
	return true

# Remueve toda la data dentro de la carpeta "folder_name" sin importar
# si esta encriptada o no. Devuelve true si la remueve y false si no
# existe data o hay un error.
func remove_all_data():
	var dir = Directory.new()
	var profiles = get_profiles(true)
	
	if profiles != null:
		var path = "user://" + folder_name + "/"
		var err
		
		for i in range(profiles.size()):
			err = dir.remove(str(path + profiles[i]))
			
			if err != OK:
				debug("Un error al elimnar el archivo: ", err)
				return false
		
		data = {}
		
		return true
	else:
		debug("No se a removido ningún archivo.")
		return false

# Setters/Getters
#

# MODE_TEXT : Guarda la data en texto en formato json
# MODE_ENCRYPTED : Guarda la data de forma encriptada
func set_mode(_mode):
	mode = _mode

func get_mode():
	return mode

# Se obtiene la data, esta data puede ser modificada para luego ser guardada
# con save_data(). Si esta usando profiles, no olvide indicarle el profile.
func get_data(profile_name = null):
	data = {}
	load_data(profile_name)
	return data

# Retorna los perfiles existentes, por defecto los devuelve sin
# extension.
func get_profiles(with_extension = false):
	var dir = Directory.new()
	var profiles = []
	
	if dir.open("user://" + folder_name) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while (file_name != ""):
			if file_name != "." and file_name != "..":
				if not with_extension:
					profiles.append(file_name.get_basename())
				else:
					profiles.append(file_name)
		
			file_name = dir.get_next()
	else:
		debug("Un error ha ocurrido al intentar entrar al path.")
	
	return profiles

# Retorna los nombres no validos
func get_no_valid_names():
	return no_valid_names

func set_password(_password):
	password = _password
	
func get_password():
	return password

func set_folder_name(_folder_name):
	folder_name = _folder_name
	
func get_folder_name():
	return folder_name

func set_debug(_debug):
	debug = _debug
	
func get_debug():
	return debug

func set_beautifier_active(_beautifier_active):
	beautifier_active = _beautifier_active
	
func get_beautifier_active():
	return beautifier_active
	
func set_profile_name_min_size(_profile_name_min_size):
	profile_name_min_size = _profile_name_min_size
	
func get_profile_name_min_size():
	return profile_name_min_size
	
func set_profile_name_max_size(_profile_name_max_size):
	profile_name_max_size = _profile_name_max_size
	
func get_profile_name_max_size():
	return profile_name_max_size

# Métodos "privados" (No usar)
#

# Valida:
# 1) No puede tener nombres no validos según no_valid_names[]
# 2) El nombre no puede ser "default"
# 3) El nombre debe estar dentro del rango del tamaño de nombre mínimo o
# máximo.
func validate_profile(profile_name):
	var profiles = get_profiles()
	
	# 1)
	if no_valid_names != null and no_valid_names.has(profile_name):
		debug("Nombre invalido: ", profile_name)
		return false
	
	# 2)
	if profile_name == "default":
		debug("No se puede usar el nombre default")
		return false
	
	# 3)
	if profile_name.length() < profile_name_min_size or profile_name.length() > profile_name_max_size:
		debug("El profile_name no esta dentro del rango")
		return false
	
	return true
	
func save_profile_default():
	match mode:
		MODE_ENCRYPTED:
			return save_profile_encripted("default")
		MODE_TEXT:
			return save_profile_text("default")

func load_profile_default():
	match mode:
		MODE_ENCRYPTED:
			return load_profile_encripted("default")
		MODE_TEXT:
			return load_profile_text("default")
			
func save_profile_encripted(profile_name):
	var file_path
	file_path = str("user://" + folder_name + "/" + profile_name + ".save")
	
	erase_profile_encripted(profile_name, file_path)
	
	var file = File.new()
	var err = file.open_encrypted_with_pass(file_path, File.WRITE, password)
	
	if err == OK:
		file.store_var(data)
		file.close()
		
		return true
	else:
		debug("Error al crear/guardar el archivo: ", err)
		debug("Path: ", file_path)
		return false
	
func save_profile_text(profile_name):
	var file_path
	file_path = str("user://" + folder_name + "/" + profile_name + ".txt")
	
	var file = File.new()
	var err = file.open(file_path, File.WRITE_READ)
	
	if err == OK:
		file.get_line() # Borrar la data anterior
		file.store_string(to_json(data))
		file.close()
		
		return true
	else:
		debug("Error al crear/leer el archivo: ", err)
		return false

func load_profile_encripted(profile_name):
	var file_path
	file_path = str("user://" + folder_name + "/" + profile_name + ".save")
	
	var file = File.new()
	
	if not file.file_exists(file_path):
		debug("El archivo no existe: " + file_path)
		return false
	
	var err = file.open_encrypted_with_pass(file_path, File.READ, password)
	
	if err == OK:
		data = file.get_var()
		file.close()
		# Se guarda la data después de cargarla ya que, al cargar la data
		# se borran los datos en disco.
		save_profile_encripted(profile_name)
		
		debug("Se a cargado el archivo con éxito: ")
		return true
	else:
		debug("Error al leer el archivo: ", err)
		return false
	
func load_profile_text(profile_name):
	var file_path = str("user://" + folder_name + "/" + profile_name + ".txt")
	var file = File.new()
	
	if not file.file_exists(file_path):
		debug("El archivo no existe: " + file_path)
		return false
	
	var err = file.open(file_path, File.READ)
	
	if err == OK:
		data = parse_json(file.get_line())
		file.close()
		# Se guarda la data después de cargarla ya que, al cargar la data
		# se borran los datos en disco.
		save_profile_text(profile_name)

		return true
	else:
		debug("Error al leer el archivo: ", err)
		return false

func erase_profile_encripted(profile_name, file_path):
	var file = File.new()
	var err = file.open_encrypted_with_pass(file_path, File.READ, password)
	
	if err == OK:
		file.get_var()
		file.close()
	else:
		debug("No se a podido limpiar el profile: ", err)

# Crea la carpeta principal, sólo la crea si esta no existe
func create_main_folder():
	var dir = Directory.new()
	
	if not dir.dir_exists(str("user://" + folder_name)):
		dir.make_dir(str("user://" + folder_name))
		debug("Se a creado la carpeta ", folder_name)

# Carga la data, si no se le pasa ningún argumento entonces carga la data
# por defecto, si se le pasa argumento entonces carga la data indicada en el.
# Devuelve true si se carga exitosamente y false si no lo hace.
func load_data(profile_name = null):
	var result
	
	if profile_name == null:
		if load_profile_default():
			emit_signal("loaded")
			return true
		else:
			debug("load_profile_default retorna false.")
			return false
	
	if validate_profile(profile_name): 
		match mode:
			MODE_ENCRYPTED:
				result = load_profile_encripted(profile_name)
			MODE_TEXT:
				result = load_profile_text(profile_name)
	else:
		debug("No ha pasado la validación")
		result = false
	
	if result:
		emit_signal("loaded")
	
	return result

func print_json(json):
	if beautifier != null:
		print("______________- JSON -______________")
		print(beautifier.beautify_json(json))
		print("____________________________________")
	