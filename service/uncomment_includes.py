#!/usr/bin/python
import sys
import os
import re

list_of_dirs = ['tb', 'gtxe2_channel']

for directory in list_of_dirs:
    path_to_dir = sys.argv[1] + '/' + directory 
    for filename in os.listdir(path_to_dir):
        if re.search(r'\.v$', filename) and os.path.isfile(path_to_dir + '/' + filename):
            rfile = open(path_to_dir + '/' + filename, 'r')
            lines = []
            for line in rfile:
                lines.append(re.sub(r'//`include ', r'`include ', line))
            rfile.close()
            wfile = open(path_to_dir + '/' + filename, 'w')
            for line in lines:
                wfile.write(line)
            wfile.close()
