module ast

import v.ast

pub fn (mut b StringBuilder) exprs(exprs ...ast.Expr) {
	if exprs.len == 0 {
		b.writeln('[]')
		return
	}
	b.begin_array()
	for expr in exprs {
		b.expr(expr)
		b.insert_array_comma()
	}
	b.end_array()
}

pub fn (mut b StringBuilder) expr(expr ast.Expr) {
	match expr {
		else { b.writeln(expr) }
	}
}
