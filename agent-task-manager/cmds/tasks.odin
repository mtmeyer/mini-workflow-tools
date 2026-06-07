package cmds

import "../../cli"
import "../utils"
import "core:encoding/json"
import "core:fmt"
import "core:os"
import "core:strings"

executeSubcommand :: proc(cliOpts: utils.Options, data: ^utils.DataFile, dataFilePath: string) {
	switch cmdString := cliOpts.subCommand; cmdString {
	case "list":
		list(data, cliOpts.json, cliOpts.full)
	case "create":
		create(data, dataFilePath, cliOpts.subCommandInput, cliOpts.description, cliOpts.blocking)
	case "update-status":
		updateStatus(data, dataFilePath, cliOpts.subCommandInput, cliOpts.status)
	case:
		// TODO: Print help for tasks subcommand
		fmt.print("Command not supported")
	}
}

list :: proc(data: ^utils.DataFile, jsonFlag: bool = false, fullFlag: bool = false) {
	tasks := data.tasks

	if jsonFlag {
		pretty, err := json.marshal(
			tasks,
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

	for task in tasks {
		append(
			&linesToRender,
			fmt.tprintf(
				"%s %s%s%s:%s %s",
				getOutputTaskStatus(task.status),
				cli.BOLD,
				cli.CYAN,
				task.id,
				cli.RESET,
				utils.truncate(task.name, 80),
			),
		)

		if fullFlag {
			blocking := strings.join(task.blocking, ", ")
			append(
				&linesToRender,
				fmt.tprintf(
					"    %s%Description:%s %s\n    %s%sBlocking:%s [%s]\n",
					cli.BOLD,
					cli.CYAN,
					cli.RESET,
					task.description,
					cli.BOLD,
					cli.YELLOW,
					cli.RESET,
					blocking,
				),
			)
		}
	}


	fmt.println(strings.join(linesToRender[:], "\n"))
}

getOutputTaskStatus :: proc(status: string) -> string {
	switch status {
	case "todo":
		return "[ ]"
	case "done":
		return fmt.tprintf("%s[✓]%s", cli.GREEN, cli.RESET)
	case "cancelled":
		return fmt.tprintf("%s[×]%s", cli.RED, cli.RESET)
	}
	return ""
}

create :: proc(
	data: ^utils.DataFile,
	dataFilePath: string,
	name: string,
	description: string,
	blocking: string = "",
) {
	todoId := utils.generateId()

	newTodo := utils.Task {
		id          = todoId,
		name        = name,
		description = description,
		status      = "todo",
	}

	if len(blocking) > 0 {
		blockedTasks := strings.split(blocking, ",")
		newTodo.blocking = blockedTasks
	}

	append(&data.tasks, newTodo)

	utils.putDataFile(dataFilePath, data)
}

updateStatus :: proc(data: ^utils.DataFile, dataFilePath: string, id: string, status: string) {
	statusOk := utils.validateStatusString(status)

	if !statusOk {
		fmt.eprintfln(
			"Status '%s' is invalid. Must be either 'todo', 'completed' or 'cancelled'",
			status,
		)

		os.exit(1)
	}

	for &task in data.tasks {
		if task.id != id {
			continue
		}

		task.status = status
	}

	utils.putDataFile(dataFilePath, data)
}
