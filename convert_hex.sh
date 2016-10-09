#!/usr/local/bin/bash
x="$1"
val=`python2 -c "print int('$x', 16)"`
echo $val
~
