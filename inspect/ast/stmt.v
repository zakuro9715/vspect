module ast

import v.ast

pub fn (mut b StringBuilder) write_stmts(stmts []ast.Stmt) {
	b.begin_array()
	for stmt in stmts {
		b.write_stmt(stmt)
	}
	b.end_array()
}

pub fn (mut b StringBuilder) write_stmt(stmt ast.Stmt) {
	match stmt {
		ast.Module {
			b.writeln(stmt)
		}
		else { b.writeln(stmt) }
	}
}
