package cmds

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
		lines := []string{"Tasks command"}
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
