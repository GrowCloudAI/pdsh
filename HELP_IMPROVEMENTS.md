# PDSH Help Output Improvements

## Summary of Changes

Enhanced the `pdsh --help` output with improved formatting and visual appeal using emojis and Unicode box-drawing characters.

## Files Modified

- `src/pdsh/opt.c` - Updated help text macros and usage function

## Changes Made

### 1. Added Visual Header
- Added decorative box header with emoji for each command (pdsh, pdcp, rpdcp)
- Clear identification of the tool being used

### 2. Organized Options with Emojis
Each option now has a relevant emoji for quick visual identification:
- 🚀 - Parallel execution
- ⚡ - Fast fail options
- 🔀 - I/O separation
- 📦 - Copy operations
- 🔄 - Recursive operations
- 🔒 - Preservation options
- ❓ - Help
- 📌 - Version
- 📊 - Status/info
- 🔇 - Quiet/batch mode
- 🐛 - Debug
- 👤 - User options
- ⏱️/⏰ - Timeout options
- 🌐 - Fanout/network
- 🎯 - Target selection
- ⛔ - Exclusions
- 🔧 - Configuration
- 🧩 - Modules
- 🏷️ - Labels
- 📚 - Documentation

### 3. Better Section Organization
- Clear section headers (🎯 DSH-Specific Options, ℹ️ General Options, etc.)
- Consistent indentation and spacing
- Separated concerns visually

### 4. Enhanced Footer
- Added separator lines using Unicode box-drawing characters
- Highlighted available rcmd modules
- Added helpful links (man page, bug reports)

## Example Output

```
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
  ...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔌 Available rcmd modules: ssh (default: ssh)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 For more details, see: man pdsh
🐛 Report bugs at: https://github.com/chaos/pdsh
```

## Benefits

1. **Improved Readability**: Visual hierarchy makes it easier to scan and find options
2. **Better User Experience**: Emojis provide visual cues that help users quickly identify option categories
3. **Professional Look**: Box-drawing characters give a polished, modern appearance
4. **Accessibility**: Maintains all original functionality while adding visual enhancements
5. **Consistency**: All three personalities (pdsh, pdcp, rpdcp) follow the same format

## Testing

To see a preview of the output without building:
```bash
./test_help_output.sh
```

To build and test the actual changes:
```bash
./bootstrap
./configure --with-ssh
make
./src/pdsh/pdsh --help
```

## Compatibility

- Uses UTF-8 emojis and Unicode box-drawing characters
- Will display correctly on modern terminals with UTF-8 support
- Fallback gracefully on terminals without emoji support (shows squares/question marks but remains functional)
