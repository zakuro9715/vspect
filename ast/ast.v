module ast

import strings
import v.ast
import v.ast.walker
import v.parser
import v.pref
import v.table

// V 0.2.1 71d3d4c

pub struct InspectOpts {
	func string
}

pub fn inspect(paths []string, prefs &pref.Preferences, opts &InspectOpts) {
	global_scope := ast.Scope{
		parent: 0
	}
	for path in paths {
		table := table.new_table()
		f := parser.parse_file(path, table, .parse_comments, prefs, &global_scope)
		mut b := StringBuilder{table: table, target_fn: opts.func}
		if b.target_fn.len > 0 {
			walker.walk(b, f)
		} else {
			b.file(&f)
		}
		print(b.str())
	}
}

pub struct StringBuilder {
	target_fn string
mut:
	table    &table.Table
	buf      strings.Builder
	indent_n int
	newline  bool = true
}

pub fn (mut b StringBuilder) str() string {
	return b.buf.str()
}
