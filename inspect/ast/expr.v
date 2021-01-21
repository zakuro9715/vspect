module ast

import v.ast

pub fn (mut b StringBuilder) expr(expr ast.Expr) {
	match expr {
		else { b.writeln(expr) }
	}
}
