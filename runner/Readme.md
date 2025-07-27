# Task Runner

A simple command-line tool written in Odin to run predefined tasks from a `Runfile`.

## Usage

To run a task, simply execute the program with the task name as the argument:

```bash
runner <task_name>
```

For example, to run the `server` task from the example below:

```bash
runner server
```

## Configuration

The task runner uses a `Runfile` in the root of the project to define the available tasks. The file should be in a format that mostly follows the INI standard (`cmd` is the only exception).

Each task is defined as a section `[task_name]` with the following keys:

- **`cmd`**: A JSON array of strings representing the command and its arguments to be executed.
- **`dir`** (optional): The directory to run the command in.

### Example `Runfile`

```ini
# Example config file

[blah]
cmd = ["echo", "'some command'"]

[server]
cmd = ["npx", "http-server", "./", "-p", "1234"]
# dir is relative to the working directory of the process
dir = "./server"
```
