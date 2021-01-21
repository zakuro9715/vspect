module ast

import v.ast

// V 0.2.1 71d3d4c
pub fn (mut b StringBuilder) write_expr(expr ast.Expr) {
	match expr {
		else { b.writeln(expr) }
	}
}
