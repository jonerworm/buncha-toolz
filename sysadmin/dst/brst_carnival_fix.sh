#!/bin/bash
# Copyright (C) 2008 by Joner Cyrre Worm.
#
# This script generate zoneinfo exception rules for Brazil DST.
# Read more at http://www.worm.sh/
#
# Licensing:
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#    Usage: brst_carnival_fix.sh [ -q | --quiet ] YEAR...
#
#
#
# ATTENTION: this script is valid for Brazilian DST
#            only after decree 6.558, of Sep, 8th of 2008
#   ATENCAO: este script eh valido para Horario Brazileiro de Verao
#            a partir do decreto 6.558 de 08/Set/2008.
#
# Decree/decreto:
# https://www.planalto.gov.br/ccivil_03/_ato2007-2010/2008/decreto/d6558.htm
#
# Note on 32 bits operating systems:
# =================================
# Due to date libraries design, this script may behave erratic for
# dates past 2037.
# Check for "y2k38 bug", "y2038 bug" "year 2038 bug" on the www.
#

DATEFMT='%a, %d %b %Y'

if [ "$1" == '' ]; then
    echo "Missing parameter" >&2
    echo "Usage: $0 {YEAR}..." >&2
    exit -1
fi

# Prepare 3rd file descriptor to STDERR

if [ "$1" == "-q" -o "$1" == "--quiet" ]; then
    shift
    ERR=/dev/null
else
	ERR=/dev/stderr
fi

while [ "$1" ]
do
	# Calculate Easter Day
	# Reference: Meeus/Jones/Butcher Gregorian algorithm from http://en.wikipedia.org/wiki/Computus#Meeus.2FJones.2FButcher_Gregorian_algorithm
	#
	Y=$1
	shift
	let 'a = Y % 19'
	let 'b = Y / 100'
	let 'c = Y % 100'
	let 'd = b / 4'
	let 'e = b % 4'
	let 'f = (b+8) / 25'
	let 'g = (b - f + 1) / 3'
	let 'h = (19 * a + b - d - g + 15) % 30'
	let 'i = c / 4'
	let 'k = c % 4'
	let 'L = (32 + 2 * e + 2 * i - h - k) % 7'
	let 'm = (a + 11 * h + 22 * L) / 451'
	let 'month = (h + L - 7 * m + 114) / 31'
	let 'day   = ((h + L - 7 * m + 114) % 31) + 1'
	
	# 2 digit days and months
	if [ $day -lt 10 ]; then
	    day="0$day"
	fi
	month="0$month"
	
	# ISO Date format
	EASTER="${Y}-${month}-${day}"
	
	# Show Easter Day
	echo -e "Easter:\t\t\t\c" >&2 # "
	date --date="${EASTER} 12:00:00 utc" "+$DATEFMT" >&2
	
	# Calculate Carnival Sunday
	dayc=`date --date="${EASTER} 12:00:00 utc -49 days" +"%d"`
	monthc=`date --date="${EASTER} 12:00:00 utc -49 days" +"%m"`
	
	# ISO date format
	CARNIVAL="${Y}-${monthc}-${dayc}"
	
	# Show Carnival Sunday Date
	echo -e "Carnival Sunday:\t\c" >&2 # "
	date --date="${CARNIVAL} 12:00:00 utc" "+$DATEFMT" >&2
	
	# Check if it's third sunday
	if [ $monthc == "02" ]; then
	    if [ $dayc -gt 14 -a $dayc -lt 22 ]; then
	        
	        # Carnival Sunday = DST ending day, postpone to next sunday
	        let 'dayd = dayc +7'
	        
	        # ISO Data format
	        DSTDAY="${Y}-${monthc}-${dayd}"
	        
	        # Show DST End Day
	        echo -e "New DST End Day:\t\c" >&2 # "
	        date --date="${DSTDAY} 12:00:00 utc" "+$DATEFMT" >&2
	        echo "New Zoneinfo rule:" >&2
	        echo "Rule  Brazil  ${Y}  only  -    Feb  ${dayd}  0:00  0  -"
	    fi
	fi
done 2>"$ERR"
