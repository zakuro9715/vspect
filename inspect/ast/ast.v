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
		mut b := StringBuilder{}
		b.file(&f)
		print(b.str())
	}
}

pub struct StringBuilder {
mut:
	buf      strings.Builder
	indent_n int
	newline  bool = true
}

pub fn (mut b StringBuilder) str() string {
	return b.buf.str()
}
