module ast

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
	indent_n int
	newline  bool = true
}

pub fn new_printer() Printer {
	return Printer{}
}

fn (mut p Printer) print(text string) {
	if p.newline {
		p.print_indent()
	}
	if text.len > 0 {
		print(text)
		p.newline = text[text.len - 1] == `\n`
	}
}

fn (p &Printer) print_indent() {
	print('  '.repeat(p.indent_n))
}

fn (mut p Printer) println(text string) {
	for s in text.split_into_lines() {
		if p.newline {
			p.print_indent()
		}
		println(s)
		p.newline = true
	}
}

fn (mut p Printer) indent() {
	p.indent_n++
}

fn (mut p Printer) unindent() {
	p.indent_n--
}

fn (mut p Printer) print_stmts(stmts []ast.Stmt) {
	p.println('[')
	p.indent()
	for stmt in stmts {
		p.print_stmt(stmt)
	}
	p.unindent()
	p.println(']')
}

fn (mut p Printer) print_stmt(stmt ast.Stmt) {
	p.println(stmt.str())
}

fn (mut p Printer) print_expr(expr ast.Expr) {
	p.println(expr.str())
}

pub fn (mut p Printer) print_file(file ast.File) {
	p.println('File{')
	p.indent()
	p.print('stmts: ')
	p.print_stmts(file.stmts)
	p.unindent()
	p.println('}')
}
