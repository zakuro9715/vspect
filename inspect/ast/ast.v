module ast

import strings
import v.ast
import v.parser
import v.pref
import v.table

// V 0.2.1 71d3d4c
pub fn inspect_files(paths []string, prefs &pref.Preferences) {
	global_scope := ast.Scope{
		parent: 0
	}
	for path in paths {
		f := parser.parse_file(path, table.new_table(), .parse_comments, prefs, &global_scope)
		mut p := new_printer()
		p.print_file(f)
	}
}

pub struct Printer {
mut:
	out          strings.Builder
	indent_level int
}

pub fn new_printer() Printer {
	return Printer {
		out: strings.new_builder(1000),
	}
}

pub fn (mut p Printer) print_file(file ast.File) {
	println(file)
}
