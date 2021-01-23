module ast

import v.ast

fn (mut b Inspector) write<T>(v T) {
	if b.newline {
		b.write_indent()
	}
	text := v.str()
	if text.len > 0 {
		b.buf.write(text)
		b.newline = text[text.len - 1] == `\n`
	}
}

fn (mut b Inspector) write_indent() {
	b.buf.write(' '.repeat(b.indent_n * 4))
}

fn (mut b Inspector) writeln<T>(v T) {
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
	if b.newline {
		b.buf.go_back(1)
		b.newline = false
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
