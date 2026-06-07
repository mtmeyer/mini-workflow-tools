package utils

Options :: struct {
	command:         string `args:"pos=0"`,
	subCommand:      string `args:"pos=1"`,
	subCommandInput: string `args:"pos=2"`,
	description:     string,
	content:         string,
	json:            bool,
	full:            bool,
	blocking:        string,
	status:          string,
	name:            string,
	showArchived:    bool `args:"name=show-archived"`,
}
