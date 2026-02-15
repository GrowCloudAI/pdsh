# Help Output Preview

This document shows what the enhanced `pdsh --help` output will look like.

## PDSH --help

```
╔═══════════════════════════════════════════════════════════════════════════╗
║  🚀 PDSH - Parallel Distributed Shell                                     ║
║  Execute commands on multiple hosts in parallel                          ║
╚═══════════════════════════════════════════════════════════════════════════╝

📋 USAGE:
   pdsh [-options] command ...

🎯 COMMAND EXECUTION:
   -S                Return largest of remote command return values
   -k                Fail fast on connect failure or non-zero return code

ℹ️  INFORMATION:
   -h                Output usage menu and quit
   -V                Output version information and quit
   -q                List the option settings and quit
   -L                List info on all loaded modules and exit

🔧 GENERAL OPTIONS:
   -l user           Execute remote commands as user
   -b                Disable ^C status feature (batch mode)
   -d                Enable extra debug information from ^C status
   -N                Disable hostname: labels on output lines

⏱️  TIMEOUTS:
   -t seconds        Set connect timeout (default is 10 sec)
   -u seconds        Set command timeout (no default)

🌐 HOST SELECTION:
   -w host,host,...  Set target node list on command line
   -x host,host,...  Set node exclusion list on command line
   -f n              Use fanout of n nodes

🔌 MODULES:
   -R name           Set rcmd module to name
   -M name,...       Select one or more misc modules to initialize first

🔧 AVAILABLE MODULES:
   rcmd modules: ssh, exec

💡 EXAMPLES:
   # Execute command on multiple hosts:
   pdsh -w host[1-10] uptime

   # Use SSH with specific user:
   pdsh -R ssh -l root -w node[01-20] 'df -h'

   # Exclude specific hosts:
   pdsh -w host[1-100] -x host[5,10,15] hostname

╔═══════════════════════════════════════════════════════════════════════════╗
║  📚 For more information, see the man pages: man pdsh, man pdcp          ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

## PDCP --help

```
╔═══════════════════════════════════════════════════════════════════════════╗
║  📦 PDCP - Parallel Distributed Copy                                      ║
║  Copy files to multiple hosts in parallel                                ║
╚═══════════════════════════════════════════════════════════════════════════╝

📋 USAGE:
   pdcp [-options] src [src2...] dest

📁 FILE OPERATIONS:
   -r                Recursively copy files
   -p                Preserve modification time and modes
   -e PATH           Specify the path to pdcp on the remote machine

ℹ️  INFORMATION:
   -h                Output usage menu and quit
   -V                Output version information and quit
   -q                List the option settings and quit
   -L                List info on all loaded modules and exit

🔧 GENERAL OPTIONS:
   -l user           Execute remote commands as user
   -b                Disable ^C status feature (batch mode)
   -d                Enable extra debug information from ^C status
   -N                Disable hostname: labels on output lines

⏱️  TIMEOUTS:
   -t seconds        Set connect timeout (default is 10 sec)
   -u seconds        Set command timeout (no default)

🌐 HOST SELECTION:
   -w host,host,...  Set target node list on command line
   -x host,host,...  Set node exclusion list on command line
   -f n              Use fanout of n nodes

🔌 MODULES:
   -R name           Set rcmd module to name
   -M name,...       Select one or more misc modules to initialize first

🔧 AVAILABLE MODULES:
   rcmd modules: ssh, exec

💡 EXAMPLES:
   # Copy file to multiple hosts:
   pdcp -w host[1-10] /etc/hosts /tmp/

   # Recursively copy directory:
   pdcp -r -w node[01-20] /local/dir /remote/path/

╔═══════════════════════════════════════════════════════════════════════════╗
║  📚 For more information, see the man pages: man pdsh, man pdcp          ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

## RPDCP --help

```
╔═══════════════════════════════════════════════════════════════════════════╗
║  📥 RPDCP - Reverse Parallel Distributed Copy                             ║
║  Copy files from multiple hosts in parallel                              ║
╚═══════════════════════════════════════════════════════════════════════════╝

📋 USAGE:
   rpdcp [-options] src [src2...] dir

📁 FILE OPERATIONS:
   -r                Recursively copy files
   -p                Preserve modification time and modes

ℹ️  INFORMATION:
   -h                Output usage menu and quit
   -V                Output version information and quit
   -q                List the option settings and quit
   -L                List info on all loaded modules and exit

🔧 GENERAL OPTIONS:
   -l user           Execute remote commands as user
   -b                Disable ^C status feature (batch mode)
   -d                Enable extra debug information from ^C status
   -N                Disable hostname: labels on output lines

⏱️  TIMEOUTS:
   -t seconds        Set connect timeout (default is 10 sec)
   -u seconds        Set command timeout (no default)

🌐 HOST SELECTION:
   -w host,host,...  Set target node list on command line
   -x host,host,...  Set node exclusion list on command line
   -f n              Use fanout of n nodes

🔌 MODULES:
   -R name           Set rcmd module to name
   -M name,...       Select one or more misc modules to initialize first

🔧 AVAILABLE MODULES:
   rcmd modules: ssh, exec

💡 EXAMPLES:
   # Copy files from multiple hosts:
   rpdcp -w host[1-10] /remote/file.txt /local/dir/

╔═══════════════════════════════════════════════════════════════════════════╗
║  📚 For more information, see the man pages: man pdsh, man pdcp          ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

## Visual Improvements

### Before (Old Format)
```
Usage: pdsh [-options] command ...
-S                return largest of remote command return values
-k                fail fast on connect failure or non-zero return code
-h                output usage menu and quit
-V                output version information and quit
...
available rcmd modules: ssh, exec
```

### After (New Format)
```
╔═══════════════════════════════════════════════════════════════════════════╗
║  🚀 PDSH - Parallel Distributed Shell                                     ║
║  Execute commands on multiple hosts in parallel                          ║
╚═══════════════════════════════════════════════════════════════════════════╝

📋 USAGE:
   pdsh [-options] command ...

🎯 COMMAND EXECUTION:
   -S                Return largest of remote command return values
   -k                Fail fast on connect failure or non-zero return code
```

## Key Enhancements

✅ **Visual Hierarchy**
- Clear header with box drawing characters
- Section icons (emoji) for quick scanning
- Grouped related options together

✅ **Better Readability**
- Capitalized descriptions (proper sentence case)
- Organized into logical sections
- Added spacing and indentation

✅ **Practical Examples**
- Real-world usage examples
- Shows common patterns
- Helps users get started quickly

✅ **Modern Appearance**
- Emojis make it more engaging
- Box drawing for professional look
- Footer with additional resources
