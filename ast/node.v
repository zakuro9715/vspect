module ast

import v.ast as v

/*
ConstField
o	EnumField
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

pub fn (mut b Inspector) nodes(nodes ...v.Node) {
	b.begin_array()
	for node in nodes {
		b.node(node)
		b.array_comma()
	}
	b.end_array()
}

pub fn (mut b Inspector) node(v v.Node) {
	match v {
		v.EnumField { b.enum_field(v) }
		v.Expr {
			b.expr(v)
		}
		v.Stmt {
			b.stmt(v)
		}
		v.File {
			b.file(v)
		}
		v.Field {
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
pub fn (mut b Inspector) file(file &v.File) {
	// b.begin_struct<v.File>(file)
	b.begin_struct('File')
	b.write_label('stmts')
	if b.short_fn {
		b.stmts(...file.stmts)
	} else {
		b.stmts_detail(...file.stmts)
	}
	b.end_struct()
}

pub fn (mut b Inspector) visit(node v.Node) ? {
	if node is v.Stmt {
		if node is v.FnDecl {
			if node.name.split('.').last() == b.target_fn {
				b.fn_decl(node)
			}
		}
	}
	return
}
