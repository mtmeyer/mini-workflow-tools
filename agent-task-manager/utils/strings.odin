package utils

import "core:fmt"
import "core:math/rand"
import "core:strings"

truncate :: proc(s: string, maxLen: int) -> string {
	if len(s) <= maxLen {
		return s
	}
	return fmt.tprintf("%s...", s[:maxLen])
}

AVAILABLE_CHARS: string : "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
ID_LEN :: 8

generateId :: proc() -> string {
	bytes := make([]byte, ID_LEN)

	availableBytes := transmute([]u8)AVAILABLE_CHARS

	for &byte in bytes {
		val := rand.int_max(len(AVAILABLE_CHARS))

		byte = availableBytes[val]
	}

	return string(bytes)
}

validateStatusString :: proc(status: string) -> (ok: bool) {
	switch status {
	case "todo":
		ok = true
	case "completed":
		ok = true
	case "cancelled":
		ok = true
	case:
		ok = false
	}

	return
}
