package utils

import "core:fmt"

truncate :: proc(s: string, maxLen: int) -> string {
	if len(s) <= maxLen {
		return s
	}
	return fmt.tprintf("%s...", s[:maxLen])
}
