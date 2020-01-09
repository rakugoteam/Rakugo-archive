##################################################################################
#                            This file is part of                                #
#                                GodotExplorer                                   #
#                       https://github.com/GodotExplorer                         #
##################################################################################
# Copyright (c) 2017-2018 Geequlim                                               #
#                                                                                #
# Permission is hereby granted, free of charge, to any person obtaining a copy   #
# of this software and associated documentation files (the "Software"), to deal#
# in the Software without restriction, including without limitation the rights   #
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell      #
# copies of the Software, and to permit persons to whom the Software is          #
# furnished to do so, subject to the following conditions:                       #
#                                                                                #
# The above copyright notice and this permission notice shall be included in all #
# copies or substantial portions of the Software.                                #
#                                                                                #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR     #
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,       #
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE    #
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER         #
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  #
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  #
# SOFTWARE.                                                                      #
##################################################################################

tool
extends Label
export(String, "AntDesign", "Entypo", "EvilIcons", "Feather", "FontAwesome",\
	"FontAwesome5", "Fontisto", "Foundation", "Ionicons", "MaterialCommunityIcons",\
	"MaterialIcons", "Octicons", "SimpleLineIcons", "Zocial")\
	var icon_set = "Ionicons" setget _set_icon_set
export(int, 0, 1000, 1) var size = 16 setget _set_size
export var icon = "ios-analytics" setget _set_icon
export var filter = true setget _set_filter

var Cheatsheet = {}
var _font = DynamicFont.new()

func _set_size(p_size):
	size = p_size
	_font.set_size(p_size)

func _set_icon(p_icon):
	icon = p_icon
	var iconcode = ""
	if p_icon in Cheatsheet:
		iconcode = Cheatsheet[p_icon]
	set_text(iconcode)

func _set_filter(f):
	filter = f
	if is_inside_tree():
		_font.set_use_filter(f)

func _set_icon_set(name):
	icon_set = name
	var font = load(str('res://addons/vector-icons/fonts/', name, ".gd"))
	if font != null:
		self.Cheatsheet = font.Cheatsheet
		_font = DynamicFont.new()
		_font.set_font_data(font.FontData)
		set("custom_fonts/font", _font)
		update_content()

func _ready():
	self.icon_set = icon_set
	update_content()
	
func update_content():
	self.size = size
	self.icon = icon
	self.filter = filter