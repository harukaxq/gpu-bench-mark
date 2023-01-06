#!/bin/sh
COMMAND="whisper /samples/$1.m4a --model $2 --model_dir /model --device $3"
echo $COMMAND >> /app/result
{ time -f "real:%e" $COMMAND ; } 2>> /app/result