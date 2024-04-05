class_name ModularCameraUtils
extends Object


static func repeat_str(input: String, count: int) -> String:
	var output: String = ""
	for i in range(count):
		output = output + input
	return output


static func get_stack_string(stack: Array[Dictionary]) -> String:
	var output: String = ""
	var longest_line_number_length: int = 0
	var longest_function_name_length: int = 0
	for call in stack:
		var line_number_length = str(call.line).length()
		if line_number_length > longest_line_number_length:
			longest_line_number_length = line_number_length
		var function_name_length = str(call.function).length()
		if function_name_length > longest_function_name_length:
			longest_function_name_length = function_name_length
	for call in stack:
		output = (
				output + 
				"	Line %s%s in %s%s in %s\n" %
				[
						call.line,
						repeat_str(" ", longest_line_number_length - str(call.line).length()),
						call.function,
						repeat_str(" ", longest_function_name_length - str(call.function).length()),
						call.source,
				]
		)
	return output


static func print_detailed_err(error: String):
	var stack: Array[Dictionary] = get_stack()
	stack.pop_front()
	printerr("(Modular Camera Addon) " + error)
	print(get_stack_string(stack))
