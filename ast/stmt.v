module ast

import v.ast as v

/*
o	AssertStmt
o	AssignStmt
	Block
	BranchStmt
	CompFor
	ConstDecl
o	DeferStmt
	EnumDecl
o	ExprStmt
o FnDecl
	ForCStmt
o	ForInStmt
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
o	TypeDecl
*/

fn (mut b Inspector) stmts_detail(stmts ...v.Stmt) {
	b.begin_array()
	for stmt in stmts {
		b.stmt_detail(stmt)
		b.array_comma()
	}
	b.end_array()
}

pub fn (mut b Inspector) stmts(stmts ...v.Stmt) {
	b.begin_array()
	for stmt in stmts {
		b.stmt(stmt)
		b.array_comma()
	}
	b.end_array()
}

pub fn (mut b Inspector) stmt(stmt v.Stmt) {
	if b.short_stmt {
		b.writeln(stmt)
	} else {
		b.stmt_detail(stmt)
	}
}

fn (mut b Inspector) stmt_detail(stmt v.Stmt) {
	match stmt {
		v.AssertStmt { b.assert_stmt(stmt) }
		v.AssignStmt { b.assign_stmt(stmt) }
		v.DeferStmt { b.defer_stmt(stmt) }
		v.FnDecl { b.fn_decl(stmt) }
		v.ForInStmt { b.for_in_stmt(stmt) }
		v.GoStmt { b.go_stmt(stmt) }
		v.GotoLabel { b.goto_label(stmt) }
		v.GotoStmt { b.goto_stmt(stmt) }
		v.Module { b.writeln(stmt) }
		v.ExprStmt { b.expr_stmt(stmt) }
		v.Return { b.return_stmt(stmt) }
		v.TypeDecl { b.type_decl(stmt) }
		else { b.writeln(stmt) }
	}
}

pub fn (mut b Inspector) assign_stmt(stmt v.AssignStmt) {
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
	b.write_comments_field('', ...stmt.comments)
	b.write_comments_field('end_comments', ...stmt.end_comments)
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

type GenericParam = v.GenericParam

fn (p GenericParam) str() string {
	return 'GenericParam{ name: $p.name }'
}

pub fn (mut b Inspector) generic_param(param GenericParam) {
	b.writeln(GenericParam(param))
}

pub fn (mut b Inspector) assert_stmt(stmt v.AssertStmt) {
	b.begin_struct('AssertStmt')
	b.write_pos_field('', stmt.pos)
	b.write_expr_field('', stmt.expr)
	b.end_struct()
}

pub fn (mut b Inspector) defer_stmt(stmt v.DeferStmt) {
	b.begin_struct('DeferStmt')
	b.write_pos_field('', stmt.pos)
	b.write_stmts_field('', ...stmt.stmts)
	b.write_any_field('ifdef', stmt.ifdef)
	b.end_struct()
}

pub fn (mut b Inspector) fn_decl(v v.FnDecl) {
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
	b.write_comments_field('', ...v.comments)
	b.write_comments_field('next_comments', ...v.next_comments)

	b.end_struct()
}

pub fn (mut b Inspector) for_in_stmt(stmt v.ForInStmt) {
	b.begin_struct('ForInStmt')
	b.write_pos_field('', stmt.pos)
	b.write_any_field('key_var', stmt.key_var)
	b.write_any_field('val_var', stmt.val_var)
	b.write_any_field('val_is_mut', stmt.val_is_mut)
	b.write_expr_field('cond', stmt.cond)
	b.write_any_field('is_range', stmt.is_range)
	b.write_expr_field('high', stmt.high)
	b.write_type_field('key_type', stmt.key_type)
	b.write_type_field('val_type', stmt.val_type)
	b.write_type_field('cond_type', stmt.cond_type)
	b.write_any_field('kind', stmt.kind)
	b.write_any_field('label', stmt.label)
	b.write_scope_field('', stmt.scope)
	b.write_stmts_field('', ...stmt.stmts)
	b.end_struct()
}

pub fn (mut b Inspector) expr_stmt(stmt v.ExprStmt) {
	b.begin_struct('ExprStmt')

	b.write_expr_field('', stmt.expr)
	b.write_pos_field('', stmt.pos)
	b.write_comments_field('', ...stmt.comments)
	b.write_any_field('is_expr', stmt.is_expr)

	b.end_struct()
}

pub fn (mut b Inspector) go_stmt(stmt v.GoStmt) {
	b.begin_struct('GoStmt')
	b.write_pos_field('', stmt.pos)
	b.write_expr_field('call_expr', stmt.call_expr)
	b.end_struct()
}

pub fn (mut b Inspector) goto_label(stmt v.GotoLabel) {
	b.begin_struct('GotoLabel')
	b.write_pos_field('', stmt.pos)
	b.write_any_field('name', stmt.name)
	b.end_struct()
}

pub fn (mut b Inspector) goto_stmt(stmt v.GotoStmt) {
	b.begin_struct('GotoStmt')
	b.write_pos_field('', stmt.pos)
	b.write_any_field('name', stmt.name)
	b.end_struct()
}

pub fn (mut b Inspector) return_stmt(stmt v.Return) {
	b.begin_struct('Return')
	b.write_pos_field('', stmt.pos)
	b.write_exprs_field('', ...stmt.exprs)
	b.write_comments_field('', ...stmt.comments)
	b.write_types_field('', ...stmt.types)
	b.end_struct()
}
