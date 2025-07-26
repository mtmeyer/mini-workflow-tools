package cli

import "base:runtime"
import "core:fmt"
import "core:os/os2"
import "core:sys/posix"
import "core:time"

// WIP
render_spinner :: proc() {
	spinner_characters: []string = {
		"⠋",
		"⠙",
		"⠹",
		"⠸",
		"⠼",
		"⠴",
		"⠦",
		"⠧",
		"⠇",
		"⠏",
	}

	// Escape sequence to hide the cursor while the spinner is running
	fmt.printf("\x1B[?25l")
	// Show the cursor when scope is exited

	i := 0
	for true {
		if i == len(spinner_characters) {
			i = 0
		}

		fmt.printf("%s\r", spinner_characters[i])
		time.sleep(60 * time.Millisecond)

		i = i + 1
	}
}

reset_cursor :: proc "c" (_: posix.Signal) {
	context = runtime.default_context()
	fmt.println("Running cleanup")
	fmt.printf("\x1B[?25h")
	os2.exit(0)
}
