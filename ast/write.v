module ast

import v.token

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

type FieldValue = int | bool | string | token.Position | token.Kind

fn (mut b Inspector) write_label(name string) {
	b.write('$name: ')
}

fn (mut b Inspector) write_field(name string, v FieldValue) {
	b.write_label(name)
	match v {
		string {
			b.writeln("'$v'")
		}
		else {
			b.writeln(v.str())
		}
	}
}

fn (mut b Inspector) write_any_field<T>(name string, v T) {
	b.write_label(name)
	b.writeln(v.str())
}
