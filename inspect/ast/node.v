module ast

import v.ast

pub fn (mut b StringBuilder) nodes(nodes ...ast.Node) {
	b.begin_array()
	for node in nodes {
		b.node(node)
		b.insert_array_comma()
	}
	b.end_array()
}

pub fn (mut b StringBuilder) node(v ast.Node) {
	match v {
		ast.Expr {
			b.expr(v)
		}
		ast.Stmt {
			b.stmt(v)
		}
		ast.File {
			b.file(v)
		}
		ast.Field {
			if v.name.len > 0 {
				b.writeln(v)
			} else {
				b.writeln('Field{}')
			}
		}
		else {
			b.writeln(v)
		}
	}
}

// WIP
pub fn (mut b StringBuilder) file(file &ast.File) {
	// b.begin_struct<ast.File>(file)
	b.begin_struct('File')
	b.write_label('stmts')
	b.stmts(...file.stmts)
	b.end_struct()
}
