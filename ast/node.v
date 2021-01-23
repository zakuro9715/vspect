module ast

import v.ast

pub fn (mut b Inspector) nodes(nodes ...ast.Node) {
	n := nodes.len
	b.begin_array(n)
	for node in nodes {
		b.node(node)
		b.array_comma(n)
	}
	b.end_array(n)
}

pub fn (mut b Inspector) node(v ast.Node) {
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
pub fn (mut b Inspector) file(file &ast.File) {
	// b.begin_struct<ast.File>(file)
	b.begin_struct('File')
	b.write_label('stmts')
	b.stmts(...file.stmts)
	b.end_struct()
}

pub fn (mut b Inspector) visit(node ast.Node) ? {
	if node is ast.Stmt {
		if node is ast.FnDecl {
			if node.name.split('.').last() == b.target_fn {
				b.fn_decl(node)
			}
		}
	}
	return
}
