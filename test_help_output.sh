#!/bin/bash
# Test script to demonstrate the new help output format

cat << 'EOF'

╔═══════════════════════════════════════════════════════════════════════════╗
║  🚀 PDSH - Parallel Distributed Shell                                    ║
║  Execute commands on multiple remote hosts in parallel                   ║
╚═══════════════════════════════════════════════════════════════════════════╝

📋 Usage: pdsh [-options] command ...

🎯 DSH-Specific Options:
  -S              ⬆️  Return largest of remote command return values
  -k              ⚡ Fail fast on connect failure or non-zero return code

ℹ️  General Options:
  -h              ❓ Output usage menu and quit
  -V              📌 Output version information and quit
  -q              📊 List the option settings and quit
  -b              🔇 Disable ^C status feature (batch mode)
  -d              🐛 Enable extra debug information from ^C status
  -l user         👤 Execute remote commands as user
  -t seconds      ⏱️  Set connect timeout (default is 10 sec)
  -u seconds      ⏰ Set command timeout (no default)
  -f n            🌐 Use fanout of n nodes
  -w host,host... 🎯 Set target node list on command line
  -x host,host... ⛔ Set node exclusion list on command line
  -R name         🔧 Set rcmd module to name
  -M name,...     🧩 Select one or more misc modules to initialize first
  -N              🏷️  Disable hostname: labels on output lines
  -L              📚 List info on all loaded modules and exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔌 Available rcmd modules: ssh (default: ssh)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 For more details, see: man pdsh
🐛 Report bugs at: https://github.com/chaos/pdsh

EOF
