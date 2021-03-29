module ast

import v.ast as v
import v.token
import v.table

fn (mut b Inspector) write(v string) {
	if b.pos.is_line_head {
		b.write_indent()
	}
	text := v.str()
	if text.len > 0 {
		b.buf.write_string(text)
		if text[text.len - 1] == `\n` {
			b.pos.inc_line()
		} else {
			b.pos.is_line_head = false
		}
	}
	b.pos.i = b.buf.len
}

fn (mut b Inspector) write_indent() {
	b.buf.write_string(' '.repeat(b.indent_n * 4))
	b.pos.is_line_head = false
	b.pos.i = b.buf.len
}

fn (mut b Inspector) writeln(v string) {
	for i, line in v.str().split_into_lines() {
		if b.pos.is_line_head {
			b.write_indent()
		}
		// Hack to remove v.ast from struct type name. v.v.File -> File
		s := if i == 0 && line.contains('v.v.') && line.contains('{') {
			line.replace('v.v.', '')
		} else {
			line
		}
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
		b.pos = begin_pos
		b.writeln('[]')
	}
}

fn (mut b Inspector) array_comma() {
	if b.pos.is_line_head {
		b.buf.go_back(1)
		b.pos.is_line_head = false
	}
	b.writeln(',')
}

fn (mut b Inspector) write_label(name string, default ...string) {
	if default.len > 1 {
		panic('too many default values')
	}
	b.write(if name.len == 0 && default.len > 0 { default[0] } else { name } + ': ')
}

fn (mut b Inspector) write_any_field<T>(name string, v T) {
	b.write_label(name)
	$if T is string {
		b.writeln("'$v'")
	} $else {
		b.writeln(v.str())
	}
}

fn (mut b Inspector) write_pos_field(name string, p token.Position) {
	b.write_label(name, 'pos')
	b.writeln(p.str())
}

fn (mut b Inspector) write_stmt_field(name string, v v.Stmt) {
	b.write_label(name, 'stmt')
	b.stmt(v)
}

fn (mut b Inspector) write_stmts_field(name string, v ...v.Stmt) {
	b.write_label(name, 'stmts')
	b.stmts(...v)
}

fn (mut b Inspector) write_expr_field(name string, v v.Expr) {
	b.write_label(name, 'expr')
	b.expr(v)
}

fn (mut b Inspector) write_exprs_field(name string, v ...v.Expr) {
	b.write_label(name, 'exprs')
	b.exprs(...v)
}

fn (mut b Inspector) write_comments_field(name string, v ...v.Comment) {
	b.write_label(name, 'comments')
	b.exprs(...v)
}

fn (mut b Inspector) write_ecmnts_field(name string, ecmnts ...[]v.Comment) {
	b.write_label(name, 'ecmnts')
	b.begin_array()
	for comments in ecmnts {
		b.exprs(...comments)
		b.array_comma()
	}
	b.end_array()
}

fn (mut b Inspector) write_node_field(name string, v v.Node) {
	b.write_label(name)
	b.node(v)
}

fn (mut b Inspector) write_nodes_field(name string, v ...v.Node) {
	b.write_label(name)
	b.nodes(...v)
}

fn (mut b Inspector) write_type_field(name string, v table.Type) {
	b.write_label(name, 'typ')
	b.typ(v)
}

fn (mut b Inspector) write_types_field(name string, v ...table.Type) {
	b.write_label(name, 'types')
	b.types(...v)
}

fn (mut b Inspector) write_scope_field(name string, v &v.Scope) {
	b.write_label(name, 'scope')
	b.scope(v)
}

fn (mut b Inspector) write_params_field(name string, v ...table.Param) {
	b.write_label(name)
	b.params(...v)
}
