#!/usr/bin/env fish

# set -x BASEDIR (dirname (status --current-filename))
# set -x LOG_FILE $BASEDIR/unison-sync.log 

# unison profile -batch &> $LOG_FILE
unison profile -batch 
# date '+%Y-%m-%d %H:%M:%S' >> $LOG_FILE
# cat $LOG_FILE
