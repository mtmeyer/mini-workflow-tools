package main

import "../cli"
import "cmds"
import "core:encoding/json"
import "core:flags"
import "core:fmt"
import "core:io"
import "core:os"
import "core:path/filepath"
import "utils"

main :: proc() {
	// Find the config file, create if it doesn't exist
	// Read config file
	// Parse command to work out what to do
	// Run dedicated command

	opt: utils.Options
	style: flags.Parsing_Style = .Unix
	flags.parse_or_exit(&opt, os.args, style)

	filePath, ok := findDataFile()
	if !ok {
		fmt.eprintln("Error getting data file path")
		os.exit(1)
	}

	data, parseOk := utils.parseDataFile(filePath)

	if !parseOk {
		fmt.eprintln("Error parsing data file")
		os.exit(1)
	}

	switch command := opt.command; command {
	case "tasks":
		cmds.executeSubcommand(opt, data, filePath)
	case "scratchpad":
		fmt.print("SCRATCHPAD")
	case:
		cmds.renderHelp(.Base)
	}
}

findDataFile :: proc() -> (string, bool) {
	path, err := filepath.abs("./.agent-task-manager/config.json")
	if err != nil {
		// Handle recursively looking up the tree to find a path
		fmt.printf("Error getting filepath: %s", err)
		return "", false
	}

	return path, true
}
