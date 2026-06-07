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
			fmt.tprintf("%s%s  help%s", cli.BOLD, cli.YELLOW, cli.RESET),
			"    Show tasks help.",
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
		lines := []string {
			"agent-task-manager scratchpads - manage scratchpads",
			"",
			fmt.tprintf("%s%sUsage%s", cli.BOLD, cli.CYAN, cli.RESET),
			"  agent-task-manager scratchpads <subcommand> [arguments] [options]",
			"",
			fmt.tprintf("%s%sSubcommands%s", cli.BOLD, cli.CYAN, cli.RESET),
			"",
			fmt.tprintf("%s%s  help%s", cli.BOLD, cli.YELLOW, cli.RESET),
			"    Show scratchpads help.",
			"",
			fmt.tprintf("%s%s  list [options]%s", cli.BOLD, cli.YELLOW, cli.RESET),
			"    List scratchpads.",
			"      --json              Output scratchpad list as JSON",
			"      --show-archived     Include archived scratchpads in list output",
			"",
			fmt.tprintf("%s%s  get <id> [options]%s", cli.BOLD, cli.YELLOW, cli.RESET),
			"    Get a scratchpad by ID.",
			"      --json              Output scratchpad as JSON",
			"",
			fmt.tprintf("%s%s  create <name> [options]%s", cli.BOLD, cli.YELLOW, cli.RESET),
			"    Create a new scratchpad.",
			"      --content <string>   Scratchpad content",
			"",
			fmt.tprintf("%s%s  update <id> [options]%s", cli.BOLD, cli.YELLOW, cli.RESET),
			"    Update fields on an existing scratchpad.",
			"      --name <string>      New scratchpad name",
			"      --content <string>   New scratchpad content",
		}
		return strings.join(lines[:], "\n")
	case .Base:
		lines := []string {
			"agent-task-manager - manage tasks and scratchpads",
			"",
			fmt.tprintf("%s%sUsage%s", cli.BOLD, cli.CYAN, cli.RESET),
			"  agent-task-manager <command> [subcommand] [arguments] [options]",
			"",
			fmt.tprintf("%s%sCommands%s", cli.BOLD, cli.CYAN, cli.RESET),
			"",
			fmt.tprintf("%s%s  tasks%s", cli.BOLD, cli.YELLOW, cli.RESET),
			"    Manage tasks.",
			"      help         Show tasks help.",
			"      list         List tasks filtered by status.",
			"      get          Get task by id.",
			"      create       Create a new task.",
			"      update       Update fields on an existing task.",
			"      set-status   Change a task's status.",
			"",
			fmt.tprintf("%s%s  scratchpads%s", cli.BOLD, cli.YELLOW, cli.RESET),
			"    Manage scratchpads.",
			"      help         Show scratchpads help.",
			"      list         List scratchpads.",
			"      get          Get a scratchpad by ID.",
			"      create       Create a new scratchpad.",
			"      update       Update fields on an existing scratchpad.",
		}
		return strings.join(lines[:], "\n")
	}
	return {}
}
