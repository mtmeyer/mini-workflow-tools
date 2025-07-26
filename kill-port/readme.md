# kill-port

A simple command-line tool to kill processes running on specified tcp ports.

## Features

- Kill processes by tcp port number
- (Mostly) Cross-platform support (Linux, macOS)

## Installation

### From Source

```bash
git clone https://github.com/mtmeyer/mini-workflow-tools.git
cd kill-port
odin build ./main.odin -file
```

### Pre-built Binaries

Download the latest release from the [releases page](https://github.com/mtmeyer/mini-workflow-tools/releases).

## Usage

```bash
kill-port <PORT> [OPTIONS]
```

### Arguments

- `<PORT>` - Port number to check and kill process on (1-65535)

### Options

- `-h, --help` - Show help message

### Examples

```bash
# Kill process on port 3000
kill-port 3000

# Show usage help
kill-port -help
```

## Development

### Running Locally

**Either use odin run**

1. Run the project:
   ```bash
   odin run ./main.odin -file 
   ```

2. If you need to pass in args to the tool:
   ```bash
   odin run ./main.odin -file -- <arg 1> <arg 2>
   ```


**Or build the binary and run**

1. Build the project:
   ```bash
   odin build ./main.odin -file 
   ```

2. Run the executable:
   ```bash
   ./main --help
   ```
