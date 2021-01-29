module ast

import strings
import v.ast { Scope }
import v.ast.walker
import v.parser
import v.pref
import v.checker { new_checker }
import v.table

// V 0.2.1 71d3d4c
pub struct InspectOpts {
	func        string
	use_checker bool
	short_ident bool
	short_expr  bool
	short_stmt  bool
	short_fn    bool
}

pub fn inspect(paths []string, prefs &pref.Preferences, opts &InspectOpts) {
	global_scope := Scope{
		parent: 0
	}
	for path in paths {
		table := table.new_table()
		mut f := parser.parse_file(path, table, .parse_comments, prefs, &global_scope)
		if opts.use_checker {
			mut checker := new_checker(table, prefs)
			checker.check(f)
		}
		mut b := Inspector{
			table: table
			target_fn: opts.func
			short_ident: opts.short_ident
			short_expr: opts.short_expr
			short_stmt: opts.short_stmt || opts.short_fn
			short_fn: opts.short_fn
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
	target_fn   string
	short_ident bool
	short_expr  bool
	short_fn    bool
	short_stmt  bool
mut:
	pos             Pos
	array_begin_pos []Pos
	table           &table.Table
	buf             strings.Builder
	indent_n        int
}

pub fn (mut b Inspector) str() string {
	return b.buf.str()
}
