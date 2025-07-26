package main

import "base:runtime"
import "core:c/libc"
import "core:fmt"
import os "core:os/os2"
import "core:strconv"
import "core:strings"
import "core:sys/posix"
import "core:time"

main :: proc() {
	args := os.args

	if len(args) == 1 {
		print_help()
		return
	}

	if len(args) > 2 {
		styled_print("\n%s%sInvalid usage:%s too many args passed in\n", BOLD, RED, RESET)
		print_help()
		return
	}

	if args[1] == "-h" || args[1] == "--help" {
		print_help()
		return
	}

	if strconv.atoi(args[1]) == 0 {
		styled_print(
			"\n%s%sIncorrect port arg:%s Only integer values greater than 1 are accepted",
			BOLD,
			RED,
			RESET,
		)
		return
	}

	lsof_command: []string = {"lsof", "-i", fmt.aprintf("tcp:%s", args[1])}

	_, stdout, _, err := os.process_exec(
		os.Process_Desc{command = lsof_command[:]},
		context.allocator,
	)

	if err != nil {
		fmt.panicf("Error executing command")
	}

	if len(stdout) == 0 {
		styled_print("\nNo process with port %s%s%s found", YELLOW, args[1], RESET)
		return
	}

	lines := strings.split_lines(string(stdout))

	target: string

	for line in lines {
		if strings.contains(line, "LISTEN") {
			target = line
		}
	}

	if len(target) == 0 {
		styled_print("\nNo active process with port %s%s%s found", YELLOW, args[1], RESET)
		return
	}

	splitStr := strings.split_after(target, " ")

	processInfo: [dynamic]string

	for item in splitStr {
		if item != " " {
			append(&processInfo, item)
		}
	}

	kill_command: []string = {"kill", "-9", strings.trim(processInfo[1], " ")}

	_, stdout2, _, err2 := os.process_exec(
		os.Process_Desc{command = kill_command[:]},
		context.allocator,
	)

	if err2 != nil {
		fmt.panicf("Error executing command")
	}

	styled_print(
		"\n%s%sSuccessfully%s killed process on port %s%s",
		GREEN,
		BOLD,
		RESET,
		YELLOW,
		args[1],
	)
}

print_help :: proc() {
	styled_print("%skill-port - Kill a process running on specified port", BOLD)
	fmt.println()

	styled_print("%sUSAGE:", BOLD)
	styled_print("    kill-port %s<PORT>", CYAN)
	fmt.println()

	styled_print("%sARGUMENTS:", BOLD)
	styled_print("    %s<PORT>    Port number to check and kill process on (1-65535)", CYAN)
	fmt.println()

	styled_print("%sOPTIONS:", BOLD)
	styled_print("    %s-h, --help     Show this help message", YELLOW)
	// styled_print("    %s-v, --verbose  Show detailed output", YELLOW)
	// styled_print("    %s-f, --force    Force kill without confirmation", YELLOW)
	// styled_print("    %s-q, --quiet    Suppress all output except errors", YELLOW)
	// fmt.println()

	styled_print("%sEXAMPLES:", BOLD)
	styled_print("    kill-port 3000              %s# Kill process on port 3000", DIM)
	// styled_print("    kill-port 8080 --verbose    %s# Kill port 8080 with detailed output", DIM)
	// styled_print("    kill-port 5432 --force      %s# Force kill without confirmation", DIM)
	fmt.println()

	styled_print("%sNOTES:", BOLD)
	fmt.println("    • If no process is found on the specified port, no action is taken")
}

// Color constants
BLACK :: "\033[30m"
RED :: "\033[31m"
GREEN :: "\033[32m"
YELLOW :: "\033[33m"
BLUE :: "\033[34m"
MAGENTA :: "\033[35m"
CYAN :: "\033[36m"
WHITE :: "\033[37m"

// Formatting
BOLD :: "\033[1m"
UNDERLINE :: "\033[4m"
ITALIC :: "\033[3m"
DIM :: "\033[2m"

// Background colors
BG_RED :: "\033[41m"
BG_GREEN :: "\033[42m"
BG_YELLOW :: "\033[43m"
BG_BLUE :: "\033[44m"
BG_MAGENTA :: "\033[45m"
BG_CYAN :: "\033[46m"
BG_WHITE :: "\033[47m"

// Reset
RESET :: "\033[0m"

styled_print :: proc(text: string, args: ..any) {
	with_reset := fmt.aprintf("%s%s\n", text, RESET)
	fmt.printf(with_reset, ..args)
}
