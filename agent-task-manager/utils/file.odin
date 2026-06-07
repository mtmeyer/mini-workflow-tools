package utils

import "core:encoding/json"
import "core:fmt"
import "core:os"

taskStatus :: enum {
	Todo,
	Done,
	Cancelled,
}

Task :: struct {
	id:       string,
	name:     string,
	body:     string,
	status:   string,
	blocking: []string,
}

Scratchpad :: struct {
	name:    string,
	content: string,
}

DataFile :: struct {
	tasks:       []Task,
	scratchpads: []Scratchpad,
}

parseDataFile :: proc(filePath: string) -> (^DataFile, bool) {
	rawData, readErr := os.read_entire_file(filePath, context.allocator)

	if readErr != nil {
		fmt.eprintfln("Failed to load the file: %v", readErr)
		return nil, false
	}
	defer delete(rawData)

	dataFile := new(DataFile)

	jsonErr := json.unmarshal(rawData, dataFile)

	if jsonErr != nil {
		fmt.eprintfln("Failed to unmarshal the file: %v", jsonErr)
		return nil, false
	}

	return dataFile, true
}
