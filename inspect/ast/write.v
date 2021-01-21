module ast

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

fn (mut b StringBuilder) writeln<T>(v T) {
	for s in v.str().split_into_lines() {
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

fn (mut b StringBuilder) begin_struct(name string) {
	b.writeln('v.ast.$name' + '{')
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

fn (mut b StringBuilder) label(name string) {
	b.write('$name: ')
}

fn (mut b StringBuilder) insert_array_comma() {
	if b.newline {
		b.buf.go_back(1)
		b.newline = false
	}
	b.writeln(',')
}
