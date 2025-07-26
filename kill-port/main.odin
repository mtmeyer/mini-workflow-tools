package main

import "../cli"
import "base:runtime"
import "core:c/libc"
import "core:flags"
import "core:fmt"
import os "core:os/os2"
import "core:strconv"
import "core:strings"
import "core:sys/posix"
import "core:time"

Method :: enum {
	tcp,
	udp,
}

main :: proc() {
	Options :: struct {
		port:   string `args:"pos=0,required"usage:"Port to kill"`,
		method: Method `usage:"Is the process' port running on 'udp' or 'tcp'"`,
	}

	opt: Options
	style: flags.Parsing_Style = .Unix
	flags.parse_or_exit(&opt, os.args, style)

	if strconv.atoi(opt.port) == 0 {
		cli.styled_print(
			"\n%s%sIncorrect port arg:%s Only integer values greater than 1 are accepted",
			cli.BOLD,
			cli.RED,
			cli.RESET,
		)
		return
	}

	lsof_command: []string = {"lsof", "-i", fmt.aprintf("%s:%s", opt.method, opt.port)}

	_, stdout, _, err := os.process_exec(
		os.Process_Desc{command = lsof_command[:]},
		context.allocator,
	)

	if err != nil {
		fmt.panicf("Error executing command")
	}

	if len(stdout) == 0 {
		cli.styled_print(
			"\nNo process with %s%s%s port %s%s%s found",
			cli.BLUE,
			opt.method,
			cli.RESET,
			cli.YELLOW,
			opt.port,
			cli.RESET,
		)
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
		cli.styled_print(
			"\nNo active process with port %s%s%s found",
			cli.YELLOW,
			opt.port,
			cli.RESET,
		)
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

	cli.styled_print(
		"\n%s%sSuccessfully%s killed process on port %s%s",
		cli.GREEN,
		cli.BOLD,
		cli.RESET,
		cli.YELLOW,
		opt.port,
	)
}
