module ast

import v.ast

pub fn (mut b Inspector) exprs(exprs ...ast.Expr) {
	n := exprs.len
	b.begin_array(n)
	for expr in exprs {
		b.expr(expr)
		b.array_comma(n)
	}
	b.end_array(n)
}

pub fn (mut b Inspector) expr(expr ast.Expr) {
	match expr {
		else { b.writeln(expr) }
	}
}
