#!/usr/bin/env python
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

import json, os

GLYPHMAPS_DIR = "/home/geequlim/Desktop/react-native-vector-icons-master/glyphmaps/"
OUTPUT_DIR = os.path.join( os.path.dirname(os.path.abspath(__file__)), "..", "fonts")

def process_glyphmaps(file):
    name = os.path.basename(file).replace(".json", "")
    glyphmap = json.load(open(file))
    for key in glyphmap:
        glyphmap[key] = "\\u%04X" % (glyphmap[key])
    
    content = '''
const FontData = preload("{0}.ttf")
const Cheatsheet = {1}
'''.format(name, json.dumps(glyphmap, sort_keys=True, indent="\t"))
    file = open(os.path.join(OUTPUT_DIR, name + ".gd"), 'w')
    file.write(content.replace("\\\\", "\\"))
    file.close()

def main():
    for f in os.listdir(GLYPHMAPS_DIR):
        process_glyphmaps(os.path.join(GLYPHMAPS_DIR, f))

if __name__ == '__main__':
    main()