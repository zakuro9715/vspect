module ast

import v.ast

/*
	AssertStmt
	AssignStmt
	Block
	BranchStmt
	CompFor
	ConstDecl
	DeferStmt
	EnumDecl
	ExprStmt
o FnDecl
	ForCStmt
	ForInStmt
	ForStmt
	GlobalDecl
	GoStmt
	GotoLabel
	GotoStmt
	HashStmt
	Import
	InterfaceDecl
	Module
o	Return
	SqlStmt
	StructDecl
	TypeDecl
		AliasTypeDecl
		FnTypeDecl
		SumTypeDecl
*/


pub fn (mut b Inspector) stmts(stmts ...ast.Stmt) {
	b.begin_array()
	for stmt in stmts {
		b.stmt(stmt)
		b.array_comma()
	}
	b.end_array()
}

pub fn (mut b Inspector) stmt(stmt ast.Stmt) {
	match stmt {
		ast.FnDecl { b.fn_decl(stmt) }
		ast.Module { b.writeln(stmt) }
		ast.ExprStmt { b.expr_stmt(stmt) }
		ast.Return { b.return_stmt(stmt) }
		else { b.writeln(stmt) }
	}
}

pub fn (mut b Inspector) generic_params(params ...ast.GenericParam) {
	b.begin_array()
	for param in params {
		b.generic_param(param)
		b.array_comma()
	}
	b.end_array()
}

type GenericParam = ast.GenericParam
fn (p GenericParam) str() string {
	return 'GenericParam{ name: $p.name }'
}

pub fn (mut b Inspector) generic_param(param ast.GenericParam) {
	b.writeln(GenericParam(param))
}

pub fn (mut b Inspector) fn_decl(v ast.FnDecl) {
	b.begin_struct('FnDecl')

	b.write_field('name', v.name)
	b.write_field('mod', v.mod)
	b.write_label('params')
	b.params(...v.params)
	b.write_label('generic_params')
	b.generic_params(...v.generic_params)
	b.write_field('is_pub', v.is_pub)
	b.write_field('is_method', v.is_method)
	b.write_field('is_anon', v.is_anon)
	b.write_field('is_builtin', v.is_builtin)
	b.write_field('is_deprecated', v.is_deprecated)
	b.write_field('is_manualfree', v.is_manualfree)
	b.write_field('is_direct_arr', v.is_direct_arr)
	b.write_field('is_variadic', v.is_variadic)
	b.write_field('no_body', v.no_body)
	b.write_label('receiver')
	b.node(v.receiver)
	b.write_field('no_body', v.no_body)
	b.write_field('pos', v.pos)
	b.write_field('body_pos', v.body_pos)
	b.write_label('stmts')
	b.stmts(...v.stmts)
	b.write_label('return_type')
	b.typ(v.return_type)
	b.write_label('comments')
	b.exprs(...v.comments)
	b.write_label('next_comments')
	b.exprs(...v.next_comments)

	b.end_struct()
}

pub fn (mut b Inspector) expr_stmt(stmt ast.ExprStmt) {
	b.begin_struct('ExprStmt')

	b.write_label('expr')
	b.expr(stmt.expr)
	b.write_field('pos', stmt.pos)
	b.write_label('comments')
	b.exprs(...stmt.comments)
	b.write_field('is_expr', stmt.is_expr)

	b.end_struct()
}

pub fn (mut b Inspector) return_stmt(stmt ast.Return) {
	b.begin_struct('Return')
	b.write_field('pos', stmt.pos)
	b.write_label('exprs')
	b.exprs(...stmt.exprs)
	b.write_label('comments')
	b.exprs(...stmt.comments)
	b.write_label('types')
	b.types(...stmt.types)
	b.end_struct()
}
