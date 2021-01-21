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
		b.write_file(&f)
		print(b.str())
	}
}

pub struct StringBuilder {
mut:
	buf strings.Builder
	indent_n int
	newline  bool = true
}

fn (mut b StringBuilder) write<T>(v T) {
	if b.newline {
		b.write_indent()
	}
	text := v.str()
	if text.len > 0 {
		b.buf.write(text)
		b.newline = text[text.len - 1] == `\n`
	}
}

fn (mut b StringBuilder) write_indent() {
	b.buf.write('  '.repeat(b.indent_n))
}

fn (mut b StringBuilder) writeln(text string) {
	for s in text.split_into_lines() {
		if b.newline {
			b.write_indent()
		}
		b.buf.writeln(s)
		b.newline = true
	}
}

fn (mut b StringBuilder) indent() {
	b.indent_n++
}

fn (mut b StringBuilder) unindent() {
	b.indent_n--
}

pub fn (mut b StringBuilder) write_stmts(stmts []ast.Stmt) {
	b.writeln('[')
	b.indent()
	for stmt in stmts {
		b.write_stmt(stmt)
	}
	b.unindent()
	b.writeln(']')
}

pub fn (mut b StringBuilder) write_stmt(stmt ast.Stmt) {
	match stmt {
		else { b.writeln(stmt.str()) }
	}
}

pub fn (mut b StringBuilder) write_expr(expr ast.Expr) {
	match expr {
		else { b.writeln(expr.str()) }
	}
}

pub fn (mut b StringBuilder) write_file(file &ast.File) {
	b.writeln('File{')
	b.indent()
	b.write('stmts: ')
	b.write_stmts(file.stmts)
	b.unindent()
	b.writeln('}')
}

pub fn (mut b StringBuilder) str() string {
	return b.buf.str()
}