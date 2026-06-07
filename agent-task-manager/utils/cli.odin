package utils

Options :: struct {
	command:    string `args:"pos=0"`,
	subCommand: string `args:"pos=1"`,
	json:       bool,
}
