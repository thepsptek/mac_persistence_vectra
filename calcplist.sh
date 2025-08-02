#!/bin/bash
# create_daemon_calc.sh - Creates a LaunchDaemon to open Calculator

DAEMON_PATH="/Library/LaunchDaemons/com.notmalicious.calculator.plist"

sudo bash -c "cat > $DAEMON_PATH" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" 
"http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key><string>com.notmalicious.calculator</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/open</string>
        <string>-a</string>
        <string>Calculator</string>
    </array>
    <key>RunAtLoad</key><true/>
</dict>
</plist>
EOF

sudo launchctl bootstrap system $DAEMON_PATH
