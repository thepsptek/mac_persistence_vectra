#!/bin/bash
# create_agent_exfil.sh - Creates a LaunchAgent for fake exfil message

AGENT_PATH="$HOME/Library/LaunchAgents/com.apple.exfil.plist"
SCRIPT_PATH="$HOME/.hidden_exfil.sh"

# Hidden script
cat << 'EOF' > $SCRIPT_PATH
#!/bin/bash
while true; do
    echo "[Agent] Pretending to exfiltrate data..."
    sleep 30
done
EOF
chmod +x $SCRIPT_PATH

# LaunchAgent plist
cat <<EOF > $AGENT_PATH
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" 
"http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key><string>com.fake.exfil</string>
    <key>ProgramArguments</key>
    <array>
        <string>$SCRIPT_PATH</string>
    </array>
    <key>RunAtLoad</key><true/>
</dict>
</plist>
EOF

# Load the agent
launchctl bootstrap gui/$(id -u) $AGENT_PATH
