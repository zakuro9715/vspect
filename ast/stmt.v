module ast

import v.ast {
	Stmt,
	AssertStmt,
	AssignStmt,
	ExprStmt,
	FnDecl,
	GoStmt,
	GotoLabel,
	GotoStmt,
	Return,
}

/*
o	AssertStmt
o	AssignStmt
	Block
	BranchStmt
	CompFor
	ConstDecl
	DeferStmt
	EnumDecl
o	ExprStmt
o FnDecl
	ForCStmt
	ForInStmt
	ForStmt
	GlobalDecl
o	GoStmt
o	GotoLabel
o	GotoStmt
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

fn (mut b Inspector) stmts_detail(stmts ...Stmt) {
	b.begin_array()
	for stmt in stmts {
		b.stmt_detail(stmt)
		b.array_comma()
	}
	b.end_array()
}

pub fn (mut b Inspector) stmts(stmts ...Stmt) {
	b.begin_array()
	for stmt in stmts {
		b.stmt(stmt)
		b.array_comma()
	}
	b.end_array()
}

pub fn (mut b Inspector) stmt(stmt Stmt) {
	if b.short_stmt {
		b.writeln(stmt)
	} else {
		b.stmt_detail(stmt)
	}
}

fn (mut b Inspector) stmt_detail(stmt Stmt) {
	match stmt {
		ast.AssertStmt { b.assert_stmt(stmt) }
		ast.AssignStmt { b.assign_stmt(stmt) }
		ast.FnDecl { b.fn_decl(stmt) }
		ast.GoStmt { b.go_stmt(stmt) }
		ast.GotoLabel { b.goto_label(stmt) }
		ast.GotoStmt { b.goto_stmt(stmt) }
		ast.Module { b.writeln(stmt) }
		ast.ExprStmt { b.expr_stmt(stmt) }
		ast.Return { b.return_stmt(stmt) }
		else { b.writeln(stmt) }
	}
}

pub fn (mut b Inspector) assign_stmt(stmt AssignStmt) {
	b.begin_struct('AssignStmt')
	b.write_pos_field('', stmt.pos)
	b.write_any_field('op', stmt.op)
	b.write_exprs_field('left', ...stmt.left)
	b.write_types_field('left_types', ...stmt.left_types)
	b.write_exprs_field('right', ...stmt.right)
	b.write_types_field('right_types', ...stmt.right_types)
	b.write_any_field('is_static', stmt.is_static)
	b.write_any_field('is_simple', stmt.is_simple)
	b.write_any_field('has_cross_var', stmt.has_cross_var)
	b.write_exprs_field('comments', ...stmt.comments)
	b.write_exprs_field('end_comments', ...stmt.end_comments)
	b.end_struct()
}

pub fn (mut b Inspector) generic_params(params ...GenericParam) {
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

pub fn (mut b Inspector) generic_param(param GenericParam) {
	b.writeln(GenericParam(param))
}

pub fn (mut b Inspector) assert_stmt(stmt AssertStmt) {
	b.begin_struct('AssertStmt')
	b.write_pos_field('', stmt.pos)
	b.write_expr_field('', stmt.expr)
	b.end_struct()
}

pub fn (mut b Inspector) fn_decl(v FnDecl) {
	b.begin_struct('FnDecl')

	b.write_any_field('name', v.name)
	b.write_any_field('mod', v.mod)
	b.write_params_field('params', ...v.params)
	b.write_label('generic_params')
	b.generic_params(...v.generic_params)
	b.write_any_field('is_pub', v.is_pub)
	b.write_any_field('is_method', v.is_method)
	b.write_any_field('is_anon', v.is_anon)
	b.write_any_field('is_builtin', v.is_builtin)
	b.write_any_field('is_deprecated', v.is_deprecated)
	b.write_any_field('is_manualfree', v.is_manualfree)
	b.write_any_field('is_direct_arr', v.is_direct_arr)
	b.write_any_field('is_variadic', v.is_variadic)
	b.write_any_field('no_body', v.no_body)
	b.write_node_field('receiver', v.receiver)
	b.write_any_field('no_body', v.no_body)
	b.write_pos_field('', v.pos)
	b.write_pos_field('body_pos', v.body_pos)
	b.write_stmts_field('', ...v.stmts)
	b.write_type_field('return_type', v.return_type)
	b.write_exprs_field('comments', ...v.comments)
	b.write_exprs_field('next_comments', ...v.next_comments)

	b.end_struct()
}

pub fn (mut b Inspector) expr_stmt(stmt ExprStmt) {
	b.begin_struct('ExprStmt')

	b.write_expr_field('', stmt.expr)
	b.write_pos_field('', stmt.pos)
	b.write_exprs_field('comments', ...stmt.comments)
	b.write_any_field('is_expr', stmt.is_expr)

	b.end_struct()
}

pub fn (mut b Inspector) go_stmt(stmt GoStmt) {
	b.begin_struct('GoStmt')
	b.write_pos_field('', stmt.pos)
	b.write_expr_field('call_expr', stmt.call_expr)
	b.end_struct()
}
pub fn (mut b Inspector) goto_label(stmt GotoLabel) {
	b.begin_struct('GotoLabel')
	b.write_pos_field('', stmt.pos)
	b.write_any_field('name', stmt.name)
	b.end_struct()
}

pub fn (mut b Inspector) goto_stmt(stmt GotoStmt) {
	b.begin_struct('GotoStmt')
	b.write_pos_field('', stmt.pos)
	b.write_any_field('name', stmt.name)
	b.end_struct()
}

pub fn (mut b Inspector) return_stmt(stmt Return) {
	b.begin_struct('Return')
	b.write_pos_field('', stmt.pos)
	b.write_exprs_field('', ...stmt.exprs)
	b.write_exprs_field('comments', ...stmt.comments)
	b.write_types_field('', ...stmt.types)
	b.end_struct()
}
