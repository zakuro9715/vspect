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
	buf strings.Builder
	indent_n int
	newline  bool = true
}

pub fn new_printer() Printer {
	return Printer{}
}

fn (mut p Printer) write(text string) {
	if p.newline {
		p.write_indent()
	}
	if text.len > 0 {
		p.buf.write(text)
		p.newline = text[text.len - 1] == `\n`
	}
}

fn (mut p Printer) write_indent() {
	p.buf.write('  '.repeat(p.indent_n))
}

fn (mut p Printer) writeln(text string) {
	for s in text.split_into_lines() {
		if p.newline {
			p.write_indent()
		}
		p.buf.writeln(s)
		p.newline = true
	}
}

fn (mut p Printer) indent() {
	p.indent_n++
}

fn (mut p Printer) unindent() {
	p.indent_n--
}

pub fn (mut p Printer) write_stmts(stmts []ast.Stmt) {
	p.writeln('[')
	p.indent()
	for stmt in stmts {
		p.write_stmt(stmt)
	}
	p.unindent()
	p.writeln(']')
}

pub fn (mut p Printer) write_stmt(stmt ast.Stmt) {
	p.writeln(stmt.str())
}

pub fn (mut p Printer) write_expr(expr ast.Expr) {
	p.writeln(expr.str())
}

pub fn (mut p Printer) write_file(file ast.File) {
	p.writeln('File{')
	p.indent()
	p.write('stmts: ')
	p.write_stmts(file.stmts)
	p.unindent()
	p.writeln('}')
}

pub fn (mut p Printer) print_file(file ast.File) {
	p.write_file(file)
	println(p.buf.str().trim_space())
}
