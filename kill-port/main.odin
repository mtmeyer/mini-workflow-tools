package main

import "core:fmt"
import os "core:os/os2"
import "core:strconv"
import "core:strings"

main :: proc() {
	args := os.args

	if len(args) == 1 {
		fmt.println("Usage: kill-port <port number>")
		return
	}

	if len(args) > 2 {
		fmt.println("Too many arguments")
		fmt.println("Usage: kill-port <port number>")
		return
	}

	if strconv.atoi(args[1]) == 0 {
		fmt.println("Incorrect port argument \n Only pass in an integer value greater than 1")
	}

	command: []string = {"lsof", "-i", fmt.aprintf("tcp:%s", args[1])}

	fmt.println(command)

	_, stdout, _, err := os.process_exec(os.Process_Desc{command = command[:]}, context.allocator)

	if err != nil {
		fmt.panicf("Error executing command")
	}

	lines := strings.split_lines(string(stdout))

	target: string

	for line in lines {
		if strings.contains(line, "LISTEN") {
			target = line
		}
	}

	splitStr := strings.split_after(target, " ")

	processInfo: [dynamic]string

	for item in splitStr {
		if item != " " {
			append(&processInfo, item)
		}
	}

	command2: []string = {"kill", "-9", strings.trim(processInfo[1], " ")}

	fmt.println(command2)

	_, stdout2, _, err2 := os.process_exec(
		os.Process_Desc{command = command2[:]},
		context.allocator,
	)

	if err2 != nil {
		fmt.panicf("Error executing command")
	}

	fmt.println(string(stdout2))
}
