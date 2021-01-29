module ast

import v.ast {
	Node,
	Field,
	File,
}

/*
ConstField
	EnumField
	Expr
o	Field
_ File
	GlobalField
	IfBranch
	MatchBranch
	ScopeObject
	SelectBranch
o	Stmt
	StructField
	StructInitField
o	table.Param
*/

pub fn (mut b Inspector) nodes(nodes ...Node) {
	b.begin_array()
	for node in nodes {
		b.node(node)
		b.array_comma()
	}
	b.end_array()
}

pub fn (mut b Inspector) node(v Node) {
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
pub fn (mut b Inspector) file(file &File) {
	// b.begin_struct<ast.File>(file)
	b.begin_struct('File')
	b.write_label('stmts')
	if b.short_fn {
		b.stmts(...file.stmts)
	} else {
		b.stmts_detail(...file.stmts)
	}
	b.end_struct()
}

pub fn (mut b Inspector) visit(node Node) ? {
	if node is ast.Stmt {
		if node is ast.FnDecl {
			if node.name.split('.').last() == b.target_fn {
				b.fn_decl(node)
			}
		}
	}
	return
}
