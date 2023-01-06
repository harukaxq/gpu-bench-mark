#!/bin/sh

{ time sleep ffmpeg -i "/samples/$1.m4a" -vn -acodec copy "${1%.*}.m4a" ; } 2>> /app/result
