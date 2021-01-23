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
		mut b := Inspector{
			table: table
			target_fn: opts.func
		}
		if b.target_fn.len > 0 {
			walker.walk(b, f)
		} else {
			b.file(&f)
		}
		print(b.str())
	}
}

struct Pos {
pub mut:
	i            int
	line         int
	is_line_head bool = true
}

pub fn (mut p Pos) inc_line() {
	p.line++
	p.is_line_head = true
}

pub struct Inspector {
	target_fn string
mut:
	pos      Pos
	table    &table.Table
	buf      strings.Builder
	indent_n int
}

pub fn (mut b Inspector) str() string {
	return b.buf.str()
}
