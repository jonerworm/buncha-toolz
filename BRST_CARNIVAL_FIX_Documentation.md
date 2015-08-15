# BASH Script to Generate Exception Rules for DST of Brazil #
## Description ##
This BASH script produces  as output code to be appended to zoneinfo configuration files of Brazil/East and America/Sao\_Paulo. Read this before using it.

The source for Easter Day determination was taken from The [Computus](http://en.wikipedia.org/wiki/Computus) Wikipedia article.


## Usage ##

It expects at least one year (with century) to produce exception rules (if any).

Use '-q' or '--quite' as the first argument to produce only exception rules on STDOUT, otherwise, extra output will be sent to STDERR.

See 'Notes'   Section below.


## The Basic Code ##

### Determining Easter Day ###

```
Y=$1    # Year as a parameter (with century)
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
let 'day = ((h + L - 7 * m + 114) % 31) + 1'
```

### Determining the Sunday of Carnival: ###

```
dayc=`date --date="$Y-$month-$day 12:00:00 utc -42 days" +"%d"`
monthc=`date --date="$Y-$month-$day 12:00:00 utc -42 days" +"%m"`
```

Read the [date(1) manpage](http://www.linuxmanpages.com/man1/date.1.php).

Determining if Carnival Sunday matches the last day of DST and generating appropriate exception rule if it happens so.

```
if [ $monthc == "02" ]; then # Only February matters
  if [ $dayc -gt 14 -a $dayc -lt 22 ]; then # earliest and last dates for 3rd Sunday
   
    # Carnival Sunday = DST ending day, postpone to next sunday
    let 'dayd = dayc +7'
    # Generate rule to STDOUT 
    echo "Rule  Brazil  $Y  only -    Feb  $dayd  0:00  0  -"
  fi
fi

```

## Download: ##
Get a [full sample](http://buncha-toolz.googlecode.com/svn/trunk/sysadmin/dst/brst_carnival_fix.sh) implementation of the script.


Or  if you are some kind of lazy / uninterested fellow, just paste the following lines and you're safe until [2038 Bug](http://en.wikipedia.org/wiki/Year_2038_problem):

```
Rule  Brazil  2012  only  -    Feb  26  0:00  0  -
Rule  Brazil  2015  only  -    Feb  22  0:00  0  -
Rule  Brazil  2023  only  -    Feb  26  0:00  0  -
Rule  Brazil  2026  only  -    Feb  22  0:00  0  -
Rule  Brazil  2034  only  -    Feb  26  0:00  0  -
Rule  Brazil  2037  only  -    Feb  22  0:00  0  -
```
Read  the [zic(8) manpage](http://www.linuxmanpages.com/man8/zic.8.php).


## Notes ##

  * This script was designed to comply with [decree #6.558](http://www.planalto.gov.br/ccivil_03/_ato2007-2010/2008/decreto/d6558.htm) issued on 8th of September of 2008, and it regulates Brazilian Dayligh Saving Time.
  * This script may produte unexpected results in 32 bits operating systems, when dealing with years beyond 2037. This is a design limitation on date libraries. Check for "[year 2038 bug](http://tinyurl.com/njs2v4)" on the Internet.


## License ##

THIS PROGRAM IS FREE SOFTWARE: YOU CAN REDISTRIBUTE IT AND/OR MODIFY IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY THE FREE SOFTWARE FOUNDATION, EITHER VERSION 3 OF THE LICENSE, OR (AT YOUR OPTION) ANY LATER VERSION.

THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  SEE THE GNU GENERAL PUBLIC LICENSE FOR MORE DETAILS. SEE <[http://www.gnu.org/licenses/](http://www.gnu.org/licenses/)>.