package main

import "../cli"
import "core:encoding/ini"
import "core:fmt"
import os "core:os/os2"
import "core:path/filepath"
import "core:sys/wasm/wasi"
import "core:thread"

config: map[string]Config_Item

Thread_Data :: struct {
	command: []string,
	dir:     string,
	stdout:  []byte,
}

thread_proc :: proc(t: ^thread.Thread) {
	fmt.println("Thread starting")
	d := (^Thread_Data)(t.data)
	_, stdout, _, err := os.process_exec(
		os.Process_Desc{command = d.command[:]},
		context.allocator,
	)

	fmt.print(string(stdout))

	d.stdout = stdout
	fmt.println("Thread finishing")
}


main :: proc() {
	defer delete(config)
	parse_config()

	args := os.args
	task := args[1]

	if task not_in config {
		cli.styled_print("\n%sNo task found%s with name %s%s", cli.RED, cli.RESET, cli.CYAN, task)
		return
	}

	fmt.printfln("Command: %s \nDirectory: %s", config[task].command, config[task].dir)

	// d := Thread_Data {
	// 	command = {"npx", "http-server", "./", "-p", "1234"},
	// 	dir     = "./",
	// }
	//
	// t := thread.create(thread_proc)
	// assert(t != nil)
	// t.data = &d
	//
	// // Exactly when `thread_proc` starts running isn't certain. The operating
	// // system will schedule it to start soon.
	// thread.start(t)
	//
	// // thread.join waits for thread to finish. It will block until it is done.
	// thread.join(t)
	// thread.destroy(t)
	//
	// fmt.print(string(d.stdout))
}

Config_Item :: struct {
	command: string,
	dir:     string,
}

parse_config :: proc() {
	cwd, err := os.get_working_directory(context.temp_allocator)

	if err != nil {
		fmt.print(err)
		os.exit(1)
	}

	config_location := filepath.join({cwd, "Runfile"})

	fmt.println(config_location)

	if !os.is_file(config_location) {
		cli.styled_print(
			"\n%sConfig file not found%s - Make sure to run this command from the same directory as the config file",
			cli.RED,
			cli.RESET,
		)

		os.exit(1)
	}

	raw_config, config_err, _ := ini.load_map_from_path(config_location, context.allocator)

	if config_err != nil {
		fmt.print(config_err)
		os.exit(1)
	}

	for key, item in raw_config {
		config_item := Config_Item {
			command = item["cmd"],
			dir     = item["dir"],
		}
		config[key] = config_item
	}
}
