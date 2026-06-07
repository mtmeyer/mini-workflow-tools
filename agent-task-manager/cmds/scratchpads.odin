package cmds

import "../../cli"
import "../utils"
import "core:encoding/json"
import "core:fmt"
import "core:os"
import "core:strings"
import "core:text/scanner"

executeScratchpadSubcommand :: proc(
	cliOpts: utils.Options,
	data: ^utils.DataFile,
	dataFilePath: string,
) {
	switch cmdString := cliOpts.subCommand; cmdString {
	case "list":
		listScratchpads(data, cliOpts.json, cliOpts.showArchived)
	case "get":
		getScratchpadById(data, cliOpts.subCommandInput, cliOpts.json)
	case "create":
		createScratchpad(data, dataFilePath, cliOpts.subCommandInput, cliOpts.content)
	case "update":
		updateScratchpad(
			data,
			dataFilePath,
			cliOpts.subCommandInput,
			cliOpts.name,
			cliOpts.content,
		)
	case:
		// TODO: Print help for tasks subcommand
		fmt.print("Command not supported")
	}
}

listScratchpads :: proc(data: ^utils.DataFile, jsonFlag: bool = false, showArchived: bool) {
	scratchpads := data.scratchpads

	if jsonFlag {
		pretty, err := json.marshal(
			scratchpads,
			json.Marshal_Options{pretty = true, use_spaces = true, spaces = 4},
		)

		if err != nil {
			fmt.eprintln(err)
			return
		}
		fmt.println(string(pretty))
		return
	}

	if len(scratchpads) == 0 {
		fmt.println("No scratchpads created yet...")
		return
	}

	linesToRender: [dynamic]string

	for scratchpad in scratchpads {
		if !showArchived && scratchpad.archived {
			continue
		}

		append(
			&linesToRender,
			fmt.tprintf(
				"%s%s%s:%s %s",
				cli.BOLD,
				cli.CYAN,
				scratchpad.id,
				cli.RESET,
				utils.truncate(scratchpad.name, 80),
			),
		)
	}

	fmt.println(strings.join(linesToRender[:], "\n"))
}

getScratchpadById :: proc(data: ^utils.DataFile, id: string, jsonFlag: bool) {
	for scratchpad in data.scratchpads {
		if scratchpad.id != id {
			continue
		}

		if jsonFlag {
			pretty, err := json.marshal(
				scratchpad,
				json.Marshal_Options{pretty = true, use_spaces = true, spaces = 4},
			)

			if err != nil {
				fmt.eprintln(err)
				return
			}
			fmt.println(string(pretty))
			return
		}

		linesToRender: [dynamic]string

		append(
			&linesToRender,
			fmt.tprintf(
				"%s%s%s:%s %s",
				cli.BOLD,
				cli.CYAN,
				scratchpad.id,
				cli.RESET,
				utils.truncate(scratchpad.name, 80),
			),
		)

		append(
			&linesToRender,
			fmt.tprintf("%s%sContent:%s %s", cli.BOLD, cli.CYAN, cli.RESET, scratchpad.content),
		)

		append(
			&linesToRender,
			fmt.tprintf(
				"%s%sisArchived:%s %s",
				cli.BOLD,
				cli.CYAN,
				cli.RESET,
				fmt.tprintf("%v\n", scratchpad.archived),
			),
		)

		fmt.println(strings.join(linesToRender[:], "\n"))
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

	fmt.printfln("%s%s Scratchpad created:%s %s", cli.BOLD, cli.GREEN, cli.RESET, scratchpadId)
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
