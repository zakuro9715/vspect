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

fn (mut b Inspector) write<T>(v T) {
	if b.pos.is_line_head {
		b.write_indent()
	}
	text := v.str()
	if text.len > 0 {
		b.buf.write(text)
		if text[text.len - 1] == `\n` {
			b.pos.inc_line()
		} else {
			b.pos.is_line_head = false
		}
	}
	b.pos.i = b.buf.len
}

fn (mut b Inspector) write_indent() {
	b.buf.write(' '.repeat(b.indent_n * 4))
	b.pos.is_line_head = false
	b.pos.i = b.buf.len
}

fn (mut b Inspector) writeln<T>(v T) {
	for i, line in v.str().split_into_lines() {
		if b.pos.is_line_head {
			b.write_indent()
		}
		// Hack to remove v.ast from struct type name. v.ast.File -> File
		s := if i == 0 && line.contains('v.ast.') && line.contains('{') { line.replace('v.ast.',
				'') } else { line }
		b.buf.writeln(s)
		b.pos.inc_line()
	}
	b.pos.i = b.buf.len
}

fn (mut b Inspector) indent() {
	b.indent_n++
}

fn (mut b Inspector) unindent() {
	b.indent_n--
}

fn (mut b Inspector) begin_struct(name string) {
	b.writeln('$name' + '{')
	b.indent()
}

fn (mut b Inspector) end_struct() {
	b.unindent()
	b.writeln('}')
}

fn (mut b Inspector) begin_array() {
	b.array_begin_pos << b.pos
	b.writeln('[')
	b.indent()
}

fn (mut b Inspector) end_array() {
	begin_pos := b.array_begin_pos.pop()
	b.unindent()
	b.writeln(']')
	if b.pos.line - begin_pos.line <= 2 { // [\n]\n
		b.buf.go_back_to(begin_pos.i)
		b.buf.writeln('[]')
	}
}

fn (mut b Inspector) array_comma() {
	if b.pos.is_line_head {
		b.buf.go_back(1)
		b.pos.is_line_head = false
	}
	b.writeln(',')
}

fn (mut b Inspector) write_label(name string) {
	b.write('$name: ')
}

fn (mut b Inspector) write_field<T>(name string, v T) {
	mut val := v.str()
	$if T is string {
		val = "'$v'"
	}
	b.writeln('$name: $val')
}
