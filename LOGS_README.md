# Logging System

## Overview

The service includes a comprehensive logging system that automatically saves all logs to files for later analysis.

## Log Files Location

All logs are stored in the `logs/` directory:

```
logs/
├── amq2api_20251112.log          # Main log (all levels)
├── amq2api_error_20251112.log    # Error log (errors only)
├── amq2api_20251111.log          # Previous day's log
└── ...
```

## Log File Features

### Main Log File
- **Filename**: `amq2api_YYYYMMDD.log`
- **Content**: All log messages (INFO, WARNING, ERROR)
- **Rotation**: Automatically rotates when file reaches 10MB
- **Retention**: Keeps last 10 files
- **Format**: Detailed format with timestamp, module, level, file location, and message

### Error Log File
- **Filename**: `amq2api_error_YYYYMMDD.log`
- **Content**: Error messages only
- **Rotation**: Automatically rotates when file reaches 10MB
- **Retention**: Keeps last 5 files
- **Format**: Same detailed format as main log

## Log Format

```
2025-11-12 19:30:45 - main - INFO - [main.py:123] - Starting service on port 8080
│                     │      │       │             │
│                     │      │       │             └─ Log message
│                     │      │       └─ Source file and line number
│                     │      └─ Log level
│                     └─ Module name
└─ Timestamp
```

## Viewing Logs

### Method 1: Using Log Viewer (Recommended)

Double-click `view_logs.bat` to open the interactive log viewer:

```
1. Today's main log       - View complete main log
2. Today's error log      - View error log only
3. List all log files     - Show all available logs
4. Tail main log          - Show last 50 lines of main log
5. Tail error log         - Show last 50 lines of error log
6. Open logs folder       - Open logs directory in Explorer
```

### Method 2: Manual Access

Open the `logs/` folder and view files with any text editor.

### Method 3: Command Line

```bash
# View latest main log
type logs\amq2api_*.log

# View latest error log
type logs\amq2api_error_*.log

# Tail last 50 lines
powershell -Command "Get-Content logs\amq2api_*.log -Tail 50"
```

## Log Levels

- **INFO**: Normal operation messages
- **WARNING**: Warning messages (non-critical issues)
- **ERROR**: Error messages (critical issues)

## Troubleshooting

### Service Won't Start

1. Check error log: `logs\amq2api_error_YYYYMMDD.log`
2. Look for ERROR level messages
3. Common issues:
   - Port already in use
   - Invalid credentials
   - Missing dependencies

### Finding Specific Errors

1. Open error log file
2. Search for timestamp when issue occurred
3. Check surrounding context in main log

### Log Files Too Large

The system automatically rotates logs when they reach 10MB. Old logs are kept with `.1`, `.2`, etc. suffixes.

To manually clean up:
```bash
# Delete old logs (keep only today's)
del logs\*.log.* 
```

## Integration with Monitoring

You can integrate these logs with monitoring tools:

- **Splunk**: Configure to read from `logs/` directory
- **ELK Stack**: Use Filebeat to ship logs
- **Custom Scripts**: Parse log files for specific patterns

## Example Log Analysis

### Find all errors in last hour
```powershell
powershell -Command "Get-Content logs\amq2api_error_*.log | Select-String '2025-11-12 19:'"
```

### Count requests by hour
```powershell
powershell -Command "Get-Content logs\amq2api_*.log | Select-String 'Claude API' | Group-Object {$_.Line.Substring(0,13)}"
```

### Find slow requests
```powershell
powershell -Command "Get-Content logs\amq2api_*.log | Select-String 'timeout|slow'"
```
