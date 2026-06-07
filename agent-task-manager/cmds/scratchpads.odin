package cmds

import "../../cli"
import "../utils"
import "core:encoding/json"
import "core:fmt"
import "core:os"
import "core:strings"

executeScratchpadSubcommand :: proc(
	cliOpts: utils.Options,
	data: ^utils.DataFile,
	dataFilePath: string,
) {
	switch cmdString := cliOpts.subCommand; cmdString {
	case "list":
		listScratchpads(data, cliOpts.json, cliOpts.full, cliOpts.status)
	case "create":
		createScratchpad(
			data,
			dataFilePath,
			cliOpts.subCommandInput,
			cliOpts.description,
			cliOpts.blocking,
		)
	case "update":
		updateScratchpad(
			data,
			dataFilePath,
			cliOpts.subCommandInput,
			cliOpts.name,
			cliOpts.description,
			cliOpts.blocking,
		)
	case:
		// TODO: Print help for tasks subcommand
		fmt.print("Command not supported")
	}
}

createScratchpad :: proc(
	data: ^utils.DataFile,
	dataFilePath: string,
	name: string,
	content: string,
) {
	scratchpadId := utils.generateId()

	newScratchpad := utils.Scratchpad {
		id      = scratchpadId,
		name    = name,
		content = content,
	}

	append(&data.scratchpads, newScratchpad)

	utils.putDataFile(dataFilePath, data)
}

updateScratchpad :: proc(
	data: ^utils.DataFile,
	dataFilePath: string,
	id: string,
	name: string,
	content: string,
) {
	for &scratchpad in data.scratchpads {
		if scratchpad.id != id {
			continue
		}
		if len(name) > 0 {
			scratchpad.name = name
		}

		if len(content) > 0 {
			scratchpad.content = content
		}
	}

	utils.putDataFile(dataFilePath, data)
}
