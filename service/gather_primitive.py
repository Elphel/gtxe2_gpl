#!/usr/bin/python
import sys
import re
import datetime

path_to_channel = sys.argv[1];
wfile = open(path_to_channel + '/../GTXE2_CHANNEL.v', 'w')
now = datetime.datetime.now()
header = \
'''/*******************************************************************************
 * Module: GTXE2_CHANNEL
 * Date: ''' + '%d-%02d-%02d' % (now.year, now.month, now.day) + '''
 * Author: Alexey     
 * Description: emulates GTXE2_CHANNEL primitive behaviour. 
 *              The file is gathered from multiple files
 *
 * Copyright (c) 2015 Elphel, Inc.
 * GTXE2_CHANNEL.v is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * GTXE2_CHANNEL.v file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/> .
 *******************************************************************************/
'''
wfile.write(header)

def goToInclude(filename):
    filedesc = open(path_to_channel + filename, 'r')
    if re.search(r'_def.v$', filename):
        header = 0
    else:
        header = 1
    for line in filedesc:
        # clean a header
        if header:
            if re.search(r'\*\*\*\*\*\*\*\/', line):
                header = 0
        else:
            # go to included file
            matches = re.search(r'`include +\"(.*)\"', line)
            if matches:
                goToInclude(matches.group(1))
            else:
                wfile.write(line)
    wfile.write('\n')
    filedesc.close()

goToInclude('GTXE2_CHANNEL_GPL.v')
wfile.close()



