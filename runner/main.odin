package main

import "../cli"
import "base:runtime"
import "core:encoding/ini"
import "core:encoding/json"
import "core:fmt"
import os "core:os/os2"
import "core:path/filepath"
import "core:sys/posix"

config: map[string]Config_Item

Thread_Data :: struct {
	command: []string,
	dir:     string,
	stdout:  []byte,
}

main :: proc() {
	// Clean up when user ctrl + c
	posix.signal(posix.Signal.SIGINT, clean_up)

	parse_config()
	defer delete(config)

	args := os.args
	task := args[1]

	if task not_in config {
		cli.styled_print("\n%sNo task found%s with name %s%s", cli.RED, cli.RESET, cli.CYAN, task)
		return
	}

	dir := get_dir(config[task].dir)

	if !os.is_dir(dir) {
		cli.styled_print("\n%sDirectory provided for task doesn't exist", cli.RED)
		os.exit(1)
	}

	p, err := os.process_start(
		{
			command = config[task].command,
			stdout = os.stderr,
			stderr = os.stderr,
			working_dir = dir,
		},
	)
	assert(err == nil)

	state, werr := os.process_wait(p)
	assert(werr == nil)
	assert(state.success)
}

Config_Item :: struct {
	command: []string,
	dir:     string,
}

parse_config :: proc() {
	cwd, err := os.get_working_directory(context.temp_allocator)

	if err != nil {
		fmt.print(err)
		os.exit(1)
	}

	config_location := filepath.join({cwd, "Runfile"})

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
		cmd: []string

		json_err := json.unmarshal(transmute([]u8)item["cmd"], &cmd)

		if json_err != nil {
			cli.styled_print("%sInvalid `cmd` value for task", cli.RED)
			fmt.print(json_err)
		}

		config_item := Config_Item {
			command = cmd,
			dir     = item["dir"],
		}
		config[key] = config_item
	}
}

get_dir :: proc(dir: string) -> string {
	working_dir, err := os.get_working_directory(context.temp_allocator)

	assert(err == nil)

	if len(dir) == 0 {
		return working_dir
	}

	path, join_err := filepath.join({working_dir, dir}, context.temp_allocator)

	assert(join_err == nil)

	return path
}

clean_up :: proc "c" (_: posix.Signal) {
	context = runtime.default_context()
	delete(config)
	os.exit(0)
}
