package cmds

import "../../cli"
import "../utils"
import "core:encoding/json"
import "core:fmt"
import "core:strings"

executeSubcommand :: proc(cliOpts: utils.Options, data: ^utils.DataFile) {
	switch cmdString := cliOpts.subCommand; cmdString {
	case "list":
		list(data, cliOpts.json)
	case "create":
		create(data)
	case "delete":
		delete(data)
	case:
		// TODO: Print help for tasks subcommand
		fmt.print("Command not supported")
	}
}

list :: proc(data: ^utils.DataFile, jsonFlag: bool = false) {
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

create :: proc(data: ^utils.DataFile) {
	fmt.print("CREATE")
}

delete :: proc(data: ^utils.DataFile) {
	fmt.print("DELETE")
}
