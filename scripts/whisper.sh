#!/bin/sh
COMMAND="/usr/bin/python3 /app/app.py $1 $2 $3"
echo $COMMAND >> /app/result
{ time -f "real:%e" $COMMAND ; } 2>> /app/result