module ast

import v.ast

/*
	AnonFn
	ArrayDecompose
	ArrayInit
	AsCast
	Assoc
	AtExpr
	BoolLiteral
	CTempVar
o	CallExpr
	CastExpr
	ChanInit
	CharLiteral
	Comment
	ComptimeCall
	ComptimeSelector
	ConcatExpr
	EnumVal
	FloatLiteral
	GoExpr
_	Ident
	IfExpr
	IfGuardExpr
	IndexExpr
o	InfixExpr
	IntegerLiteral
	Likely
	LockExpr
	MapInit
	MatchExpr
	None
o	OrExpr
o	ParExpr
o	PostfixExpr
	PrefixExpr
	RangeExpr
	SelectExpr
	SelectorExpr
	SizeOf
	SqlExpr
	StringInterLiteral
	StringLiteral
	StructInit
	Type
	TypeOf
	UnsafeExpr
*/

pub fn (mut b Inspector) exprs(exprs ...ast.Expr) {
	b.begin_array()
	for expr in exprs {
		b.expr(expr)
		b.array_comma()
	}
	b.end_array()
}

pub fn (mut b Inspector) expr(expr ast.Expr) {
	if b.short_expr {
		b.writeln(expr)
		return
	}
	if expr.type_name().starts_with('unknown') {
		b.writeln('')
		return
	}
	match expr {
		ast.CallExpr { b.call_expr(expr) }
		ast.Ident { b.ident(expr) }
		ast.InfixExpr { b.infix_expr(expr) }
		ast.OrExpr { b.or_expr(expr) }
		ast.ParExpr { b.par_expr(expr) }
		ast.PostfixExpr { b.postfix_expr(expr) }
		ast.PrefixExpr { b.prefix_expr(expr) }
		else { b.writeln(expr) }
	}
}

// TODO: share type
fn (mut b Inspector) call_arg(arg ast.CallArg) {
	b.begin_struct('CallArg')

	b.write_field('pos', arg.pos)
	b.write_field('is_mut', arg.is_mut)
	b.write_field('is_tmp_autofree', arg.is_tmp_autofree)
	b.write_field('share_type', arg.share)
	b.write_label('expr')
	b.expr(arg.expr)
	b.write_label('comments')
	b.exprs(...arg.comments)
	b.write_label('type')
	b.typ(arg.typ)

	b.end_struct()
}

// TODO: scope
pub fn (mut b Inspector) call_expr(expr ast.CallExpr) {
	b.begin_struct('CallExpr')

	b.write_field('language', expr.language)
	b.write_field('mod', expr.mod)
	b.write_field('name', expr.name)
	b.write_field('pos', expr.pos)
	b.write_field('is_field', expr.is_field)
	b.write_field('is_method', expr.is_method)
	b.write_field('free_receiver', expr.free_receiver)
	b.write_field('should_be_skipped', expr.should_be_skipped)
	b.write_label('left')
	b.expr(expr.left)
	b.write_label('left_type')
	b.typ(expr.left_type)
	b.write_label('receiver_type')
	b.typ(expr.receiver_type)
	b.write_label('return_type')
	b.typ(expr.return_type)
	b.write_label('from_embed_type')
	b.typ(expr.from_embed_type)

	b.write_label('args')
	b.begin_array()
	for arg in expr.args {
		b.call_arg(arg)
		b.array_comma()
	}
	b.end_array()

	b.write_label('expected_arg_types')
	b.types(...expr.expected_arg_types)
	b.write_label('generic_types')
	b.types(...expr.generic_types)
	b.write_field('generic_list_pos', expr.generic_list_pos)
	b.write_label('or_block')
	b.or_expr(expr.or_block)
	b.write_label('comments')
	b.exprs(...expr.comments)

	b.end_struct()
}

pub fn (mut b Inspector) ident(expr ast.Ident) {
	if b.short_ident {
		b.writeln(expr.name)
	} else {
		b.writeln(expr)
	}
}

pub fn (mut b Inspector) infix_expr(expr ast.InfixExpr) {
	b.begin_struct('InfixExpr')

	b.write_field('op', expr.op)
	b.write_field('pos', expr.pos)
	b.write_label('left')
	b.expr(expr.left)
	b.write_label('right')
	b.expr(expr.right)
	b.write_field('auto_locked', expr.auto_locked)
	b.write_label('or_block')
	b.expr(expr.or_block)

	b.end_struct()
}

pub fn (mut b Inspector) or_expr(expr ast.OrExpr) {
	if expr.kind == .absent {
		b.writeln('.absent')
		return
	}
	b.begin_struct('OrExpr')
	b.write_field('pos', expr.pos)
	b.write_field('kind', expr.kind)
	b.write_label('stmts')
	b.stmts(...expr.stmts)
	b.end_struct()
}

pub fn (mut b Inspector) par_expr(expr ast.ParExpr) {
	b.begin_struct('ParExpr')
	b.write_field('pos', expr.pos)
	b.write_label('expr')
	b.expr(expr.expr)
	b.end_struct()
}

pub fn (mut b Inspector) postfix_expr(expr ast.PostfixExpr) {
	b.begin_struct('PostfixExpr')
	b.write_field('pos', expr.pos)
	b.write_field('op', expr.op)
	b.write_label('expr')
	b.expr(expr.expr)
	b.write_field('auto_locked', expr.auto_locked)
	b.end_struct()
}

pub fn (mut b Inspector) prefix_expr(expr ast.PrefixExpr) {
	b.begin_struct('PrefixExpr')
	b.write_field('pos', expr.pos)
	b.write_field('op', expr.op)
	b.write_label('right')
	b.expr(expr.right)
	b.write_label('right_type')
	b.typ(expr.right_type)
	b.write_label('or_block')
	b.or_expr(expr.or_block)
	b.end_struct()
}
