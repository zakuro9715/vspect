module ast

import v.ast

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
	b.buf.write(' '.repeat(b.indent_n * 4))
}

fn (mut b StringBuilder) writeln<T>(v T) {
	for i, s in v.str().split_into_lines() {
		if b.newline {
			b.write_indent()
		}
		// Hack to remove v.ast from struct type name. v.ast.File -> File
		if i == 0 && s.starts_with('v.ast.') && s.ends_with('{') {
			b.buf.writeln(s.trim_prefix('v.ast.'))
		} else {
			b.buf.writeln(s)
		}
		b.newline = true
	}
}

fn (mut b StringBuilder) indent() {
	b.indent_n++
}

fn (mut b StringBuilder) unindent() {
	b.indent_n--
}

fn (mut b StringBuilder) begin_struct(name string) {
	b.writeln('$name' + '{')
	b.indent()
}

fn (mut b StringBuilder) end_struct() {
	b.unindent()
	b.writeln('}')
}

fn (mut b StringBuilder) begin_array() {
	b.writeln('[')
	b.indent()
}

fn (mut b StringBuilder) end_array() {
	b.unindent()
	b.writeln(']')
}

fn (mut b StringBuilder) write_label(name string) {
	b.write('$name: ')
}

fn (mut b StringBuilder) write_field<T>(name string, v T) {
	mut val := v.str()
	$if T is string {
		val = "'$v'"
	}
	b.writeln('$name: $val')
}

fn (mut b StringBuilder) write_node_field(name string, v ast.Node) {
	b.write('$name: ')
	b.node(v)
}

fn (mut b StringBuilder) write_nodes_field(name string, nodes ...ast.Node) {
	b.write('$name: ')
	b.nodes(...nodes)
}

fn (mut b StringBuilder) write_stmt_field(name string, stmt ast.Stmt) {
	b.write_node_field(name, stmt)
}

fn (mut b StringBuilder) write_stmts_field(name string, stmts ...ast.Stmt) {
	b.write_nodes_field(name, ...stmts)
}

fn (mut b StringBuilder) write_expr_field(name string, expr ast.Expr) {
	b.write_node_field(name, expr)
}

fn (mut b StringBuilder) write_exprs_field(name string, exprs ...ast.Expr) {
	b.write_nodes_field(name, ...exprs)
}

fn (mut b StringBuilder) insert_array_comma() {
	if b.newline {
		b.buf.go_back(1)
		b.newline = false
	}
	b.writeln(',')
}
