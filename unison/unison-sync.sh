#!/bin/bash
# NOTE: Need to give /opt/homebrew/Cellar/unison/x.xx.x/bin/unison Full Disk Access
# in System Settings (under Privacy and Security) for script to work
# Add to launch agent by running:
# launchctl load -w ~/Library/LaunchAgents/com.unison.plist

BASEDIR=$(dirname "$0")
LOG_FILE=$BASEDIR/unison-sync.log 

:>$LOG_FILE

/opt/homebrew/bin/unison profile -batch &> $LOG_FILE
