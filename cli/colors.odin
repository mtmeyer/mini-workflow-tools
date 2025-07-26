package cli

import "core:fmt"

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
