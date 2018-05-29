###############################################################################
# JSON Beautifier                                                             #
# Copyright (c) 2018 Michael Alexsander Silva Dias                            #
#-----------------------------------------------------------------------------#
# This Source Code Form is subject to the terms of the Mozilla Public         #
# License, v. 2.0. If a copy of the MPL was not distributed with this         #
# file, You can obtain one at http://mozilla.org/MPL/2.0/.                    #
###############################################################################

extends Node

# Takes valid JSON (if invalid, it will return a error according with Godot's
# 'validade_json' method) and a number of spaces for indentation (default is
# '0', in which it will use tabs instead).
static func beautify_json(json, spaces = 0):
	var error_message = validate_json(json)
	if not error_message.empty():
		return error_message
	
	var indentation = ""
	if spaces > 0:
		for i in spaces:
			indentation += " "
	else:
		indentation = "\t"
	
	var char_position = 0
	var quotation_start = -1
	for i in json:
		if i == "\"":
			if quotation_start == -1:
				quotation_start = char_position
			elif json[char_position - 1] != "\\":
				quotation_start = -1
			
			char_position += 1
			
			continue
		elif quotation_start != -1:
			char_position += 1
			
			continue
		
		match i:
			# Remove pre-existing formating.
			" ", "\n", "\t":
				json[char_position] = ""
				char_position -= 1
			
			"{", "[", ",":
				if json[char_position + 1] != "}" and\
						json[char_position + 1] != "]":
					json = json.insert(char_position + 1, "\n")
					char_position += 1
			"}", "]":
				if json[char_position - 1] != "{" and\
						json[char_position - 1] != "[":
					json = json.insert(char_position, "\n")
					char_position += 1
			":":
				json = json.insert(char_position + 1, " ")
				char_position += 1
		
		char_position += 1
	
	var bracket_start
	var bracket_end
	var bracket_count
	for i in [["{", "}"], ["[", "]"]]:
		bracket_start = json.find(i[0])
		while bracket_start != -1:
			bracket_end = json.find("\n", bracket_start)
			bracket_count = 0
			while bracket_end != - 1:
				if json[bracket_end - 1] == i[0]:
					bracket_count += 1
				elif json[bracket_end + 1] == i[1]:
					bracket_count -= 1
				
				# Move through the indentation to see if there is a match.
				while json[bracket_end + 1] == indentation:
					bracket_end += 1
					
					if json[bracket_end + 1] == i[1]:
						bracket_count -= 1
				
				if bracket_count <= 0:
					break
				
				bracket_end = json.find("\n", bracket_end + 1)
			
			# Skip one newline so the end bracket doesn't get indented.
			bracket_end = json.rfind("\n", json.rfind("\n", bracket_end) - 1)
			while bracket_end > bracket_start:
				json = json.insert(bracket_end + 1, indentation)
				bracket_end = json.rfind("\n", bracket_end - 1)
			
			bracket_start = json.find(i[0], bracket_start + 1)
	
	return json

