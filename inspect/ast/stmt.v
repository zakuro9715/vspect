module ast

import v.ast

pub fn (mut b StringBuilder) write_stmts(stmts []ast.Stmt) {
	b.writeln('[')
	b.indent()
	for stmt in stmts {
		b.write_stmt(stmt)
	}
	b.unindent()
	b.writeln(']')
}

pub fn (mut b StringBuilder) write_stmt(stmt ast.Stmt) {
	match stmt {
		ast.Module {
			b.writeln(stmt)
		}
		else { b.writeln(stmt) }
	}
}
