package cmds

import "../../cli"
import "core:fmt"
import "core:strings"

HelpMenus :: enum {
	Base,
	Tasks,
	Scratchpads,
}

renderHelp :: proc(helpMenu: HelpMenus) {
	linesToRender := getHelpString(helpMenu)
	fmt.println(linesToRender)
}

getHelpString :: proc(helpMenu: HelpMenus) -> string {
	switch helpMenu {
	case .Tasks:
		lines := []string {
			"agent-task-manager tasks - manage tasks",
			"",
			fmt.tprintf("%s%sUsage%s", cli.BOLD, cli.CYAN, cli.RESET),
			"  agent-task-manager tasks <subcommand> [arguments] [options]",
			"",
			fmt.tprintf("%s%sSubcommands%s", cli.BOLD, cli.CYAN, cli.RESET),
			"",
			fmt.tprintf("%s%s  list [options]%s", cli.BOLD, cli.YELLOW, cli.RESET),
			"    List tasks filtered by status.",
			"      --status <string>   Filter by status: todo, done, cancelled, or all (default: todo)",
			"      --json              Output task list as JSON",
			"      --full              Show description and blocking dependencies",
			"",
			fmt.tprintf("%s%s  get <id> [options]%s", cli.BOLD, cli.YELLOW, cli.RESET),
			"    Get task by id.",
			"      --json              Output task as JSON",
			"",
			fmt.tprintf("%s%s  create <name> [options]%s", cli.BOLD, cli.YELLOW, cli.RESET),
			"    Create a new task.",
			"      --description <string>   Task description",
			"      --blocking <string>      Comma-separated task IDs this task is blocked by",
			"",
			fmt.tprintf("%s%s  update <id> [options]%s", cli.BOLD, cli.YELLOW, cli.RESET),
			"    Update fields on an existing task.",
			"      --name <string>          New task name",
			"      --description <string>   New task description",
			"      --blocking <string>      Comma-separated task IDs this task is blocked by",
			"",
			fmt.tprintf("%s%s  set-status <id> [options]%s", cli.BOLD, cli.YELLOW, cli.RESET),
			"    Change a task's status.",
			"      --status <string>   New status: todo, done, or cancelled",
		}
		return strings.join(lines[:], "\n")
	case .Scratchpads:
		lines := []string{"Scratchpads command"}
		return strings.join(lines[:], "\n")
	case .Base:
		lines := []string{"Base help", "Do the thing"}
		return strings.join(lines[:], "\n")
	}
	return {}
}
