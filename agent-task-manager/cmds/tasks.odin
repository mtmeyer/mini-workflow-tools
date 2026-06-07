package cmds

import "../../cli"
import "../utils"
import "core:encoding/json"
import "core:fmt"
import "core:os"
import "core:strings"

executeTaskSubcommand :: proc(
	cliOpts: utils.Options,
	data: ^utils.DataFile,
	dataFilePath: string,
) {
	switch cmdString := cliOpts.subCommand; cmdString {
	case "list":
		listTasks(data, cliOpts.json, cliOpts.full, cliOpts.status)
	case "create":
		createTask(
			data,
			dataFilePath,
			cliOpts.subCommandInput,
			cliOpts.description,
			cliOpts.blocking,
		)
	case "update":
		updateTask(
			data,
			dataFilePath,
			cliOpts.subCommandInput,
			cliOpts.name,
			cliOpts.description,
			cliOpts.blocking,
		)
	case "set-status":
		setStatusForTask(data, dataFilePath, cliOpts.subCommandInput, cliOpts.status)
	case:
		// TODO: Print help for tasks subcommand
		fmt.print("Command not supported")
	}
}

listTasks :: proc(
	data: ^utils.DataFile,
	jsonFlag: bool = false,
	fullFlag: bool = false,
	status: string,
) {
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

	if len(tasks) == 0 {
		fmt.println("No tasks created yet...")
		return
	}

	linesToRender: [dynamic]string

	resolvedStatus := status
	if len(status) == 0 {
		resolvedStatus = "todo"
	}

	for task in tasks {
		if resolvedStatus != "all" && resolvedStatus != task.status {
			continue
		}

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

createTask :: proc(
	data: ^utils.DataFile,
	dataFilePath: string,
	name: string,
	description: string,
	blocking: string,
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

	fmt.printfln("%s%s Task created:%s %s", cli.BOLD, cli.GREEN, cli.RESET, todoId)
}

updateTask :: proc(
	data: ^utils.DataFile,
	dataFilePath: string,
	id: string,
	name: string,
	description: string,
	blocking: string,
) {
	for &task in data.tasks {
		if task.id != id {
			continue
		}
		if len(name) > 0 {
			task.name = name
		}

		if len(description) > 0 {
			task.description = description
		}

		if len(blocking) > 0 {
			blockedTasks := strings.split(blocking, ",")
			task.blocking = blockedTasks
		}
	}

	utils.putDataFile(dataFilePath, data)
}

setStatusForTask :: proc(data: ^utils.DataFile, dataFilePath: string, id: string, status: string) {
	statusOk := utils.validateStatusString(status)

	if !statusOk {
		fmt.eprintfln(
			"Status '%s' is invalid. Must be either 'todo', 'done' or 'cancelled'",
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
