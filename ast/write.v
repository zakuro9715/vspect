module ast

import v.ast

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
		s := if i == 0 && line.starts_with('v.ast.') && line.ends_with('{') {
			line.trim_prefix('v.ast.')
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

fn (mut b Inspector) begin_array(n int) {
	if n == 0 {
		b.write('[')
		return
	}
	b.writeln('[')
	b.indent()
}

fn (mut b Inspector) end_array(n int) {
	if n > 0 {
		b.unindent()
	}
	b.writeln(']')
}

fn (mut b Inspector) array_comma(n int) {
	if n == 0 {
		return
	}
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
