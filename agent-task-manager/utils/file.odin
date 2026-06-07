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
	id:          string,
	name:        string,
	description: string,
	status:      string,
	blocking:    []string,
}

Scratchpad :: struct {
	id:       string,
	name:     string,
	content:  string,
	archived: bool,
}

DataFile :: struct {
	tasks:       [dynamic]Task,
	scratchpads: [dynamic]Scratchpad,
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

putDataFile :: proc(filePath: string, data: ^DataFile) -> bool {
	jsonData, err := json.marshal(data^, {pretty = true, use_spaces = true, spaces = 4})

	if err != nil {
		fmt.eprintfln("Error marshalling json: %v", err)
		return false
	}

	writeErr := os.write_entire_file(filePath, jsonData)

	if writeErr != nil {
		fmt.eprintfln("Error writing updated json data file: %v", writeErr)
		return false
	}

	return true
}
