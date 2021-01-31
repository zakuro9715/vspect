module ast

import v.ast {
	Expr,
	AnonFn,
	ArrayInit,
	ArrayDecompose,
	CallArg,
	CallExpr,
	ChanInit,
	Ident,
	IfGuardExpr,
	InfixExpr,
	MapInit,
	OrExpr,
	ParExpr,
	PostfixExpr,
	PrefixExpr,
	RangeExpr,
	SizeOf
}

/*
o	AnonFn
o	ArrayDecompose
o	ArrayInit
	AsCast
	Assoc
	AtExpr
	BoolLiteral
	CTempVar
o	CallExpr
	CastExpr
o	ChanInit
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
o	IfGuardExpr
	IndexExpr
o	InfixExpr
	IntegerLiteral
	Likely
	LockExpr
o	MapInit
	MatchExpr
	None
o	OrExpr
o	ParExpr
o	PostfixExpr
	PrefixExpr
o	RangeExpr
	SelectExpr
	SelectorExpr
o	SizeOf
	SqlExpr
	StringInterLiteral
	StringLiteral
	StructInit
	Type
	TypeOf
	UnsafeExpr
*/

pub fn (mut b Inspector) exprs(exprs ...Expr) {
	b.begin_array()
	for expr in exprs {
		b.expr(expr)
		b.array_comma()
	}
	b.end_array()
}

pub fn (mut b Inspector) expr(expr Expr) {
	if b.short_expr {
		b.writeln(expr)
		return
	}
	if expr.type_name().starts_with('unknown') {
		b.writeln('')
		return
	}
	match expr {
		ast.AnonFn { b.anon_fn(expr) }
		ast.ArrayInit { b.array_init(expr) }
		ast.ArrayDecompose { b.array_decompose(expr) }
		ast.CallExpr { b.call_expr(expr) }
		ast.ChanInit { b.chan_init(expr) }
		ast.Ident { b.ident(expr) }
		ast.IfGuardExpr { b.if_guard_expr(expr) }
		ast.InfixExpr { b.infix_expr(expr) }
		ast.MapInit { b.map_init(expr) }
		ast.OrExpr { b.or_expr(expr) }
		ast.ParExpr { b.par_expr(expr) }
		ast.PostfixExpr { b.postfix_expr(expr) }
		ast.PrefixExpr { b.prefix_expr(expr) }
		ast.RangeExpr { b.range_expr(expr) }
		ast.SizeOf { b.size_of(expr) }
		else { b.writeln(expr) }
	}
}

pub fn (mut b Inspector) anon_fn(expr AnonFn) {
	b.begin_struct('AnonFn')
	b.write_stmt_field('decl', expr.decl)
	b.write_type_field('typ', expr.typ)
	b.end_struct()
}

pub fn (mut b Inspector) array_init(expr ArrayInit) {
	b.begin_struct('ArrayInit')
	b.write_pos_field('', expr.pos)
	b.write_type_field('typ', expr.typ)
	b.write_any_field('elem_type_pos', expr.elem_type_pos)
	b.write_type_field('elem_type', expr.elem_type)
	b.write_exprs_field('', ...expr.exprs)
	b.write_types_field('expr_types', ...expr.expr_types)
	b.write_any_field('has_len', expr.has_len)
	b.write_expr_field('len_expr', expr.len_expr)
	b.write_any_field('has_cap', expr.has_cap)
	b.write_expr_field('cap_expr', expr.cap_expr)
	b.write_any_field('has_default', expr.has_default)
	b.write_expr_field('default_expr', expr.default_expr)
	b.write_any_field('is_fixed', expr.is_fixed)
	b.write_any_field('has_val', expr.has_val)
	b.write_any_field('mod', expr.mod)
	b.write_any_field('is_interface', expr.is_interface)
	b.write_type_field('interface_type', expr.interface_type)
	b.end_struct()
}

pub fn (mut b Inspector) array_decompose(expr ArrayDecompose) {
	b.begin_struct('ArrayDecompose')
	b.write_pos_field('', expr.pos)
	b.write_expr_field('', expr.expr)
	b.write_type_field('expr_type', expr.expr_type)
	b.write_type_field('arg_type', expr.arg_type)
	b.end_struct()
}

// TODO: share type
fn (mut b Inspector) call_arg(arg CallArg) {
	b.begin_struct('CallArg')

	b.write_pos_field('', arg.pos)
	b.write_any_field('is_mut', arg.is_mut)
	b.write_any_field('is_tmp_autofree', arg.is_tmp_autofree)
	b.write_any_field('share_type', arg.share)
	b.write_expr_field('', arg.expr)
	b.write_exprs_field('comments', ...arg.comments)
	b.write_type_field('type', arg.typ)

	b.end_struct()
}

// TODO: scope
pub fn (mut b Inspector) call_expr(expr CallExpr) {
	b.begin_struct('CallExpr')

	b.write_any_field('language', expr.language)
	b.write_any_field('mod', expr.mod)
	b.write_any_field('name', expr.name)
	b.write_pos_field('', expr.pos)
	b.write_any_field('is_field', expr.is_field)
	b.write_any_field('is_method', expr.is_method)
	b.write_any_field('free_receiver', expr.free_receiver)
	b.write_any_field('should_be_skipped', expr.should_be_skipped)
	b.write_expr_field('left', expr.left)
	b.write_type_field('left_type', expr.left_type)
	b.write_type_field('receiver_type', expr.receiver_type)
	b.write_type_field('return_type', expr.return_type)
	b.write_type_field('from_embed_type', expr.from_embed_type)

	b.write_label('args')
	b.begin_array()
	for arg in expr.args {
		b.call_arg(arg)
		b.array_comma()
	}
	b.end_array()

	b.write_types_field('expected_arg_types', ...expr.expected_arg_types)
	b.write_types_field('generic_types', ...expr.generic_types)
	b.write_pos_field('generic_list_pos', expr.generic_list_pos)
	b.write_expr_field('or_block', expr.or_block)
	b.write_exprs_field('comments', ...expr.comments)

	b.end_struct()
}

pub fn (mut b Inspector) chan_init(expr ChanInit) {
	b.begin_struct('ChanInit')
	b.write_pos_field('', expr.pos)
	b.write_any_field('has_cap', expr.has_cap)
	b.write_expr_field('cap_expr', expr.cap_expr)
	b.write_type_field('typ', expr.typ)
	b.write_type_field('elem_type', expr.elem_type)
	b.end_struct()
}

pub fn (mut b Inspector) ident(expr Ident) {
	if b.short_ident {
		b.writeln(expr.name)
	} else {
		b.writeln(expr)
	}
}

pub fn (mut b Inspector) if_guard_expr(expr IfGuardExpr) {
	b.begin_struct('IfGuardExpr')
	b.write_pos_field('', expr.pos)
	b.write_any_field('var_name', expr.var_name)
	b.write_expr_field('', expr.expr)
	b.write_type_field('expr_type', expr.expr_type)
	b.end_struct()
}

pub fn (mut b Inspector) infix_expr(expr InfixExpr) {
	b.begin_struct('InfixExpr')

	b.write_any_field('op', expr.op)
	b.write_pos_field('', expr.pos)
	b.write_expr_field('left', expr.left)
	b.write_expr_field('right', expr.right)
	b.write_any_field('auto_locked', expr.auto_locked)
	b.write_expr_field('or_block', expr.or_block)

	b.end_struct()
}

pub fn (mut b Inspector) map_init(expr MapInit) {
	b.begin_struct('MapInit')
	b.write_pos_field('', expr.pos)
	b.write_exprs_field('keys', ...expr.keys)
	b.write_exprs_field('vals', ...expr.vals)
	b.write_type_field('typ', expr.typ)
	b.write_type_field('key_type', expr.key_type)
	b.write_type_field('value_type', expr.value_type)
	b.end_struct()
}

pub fn (mut b Inspector) or_expr(expr OrExpr) {
	if expr.kind == .absent {
		b.writeln('.absent')
		return
	}
	b.begin_struct('OrExpr')
	b.write_pos_field('', expr.pos)
	b.write_any_field('kind', expr.kind)
	b.write_stmts_field('', ...expr.stmts)
	b.end_struct()
}

pub fn (mut b Inspector) par_expr(expr ParExpr) {
	b.begin_struct('ParExpr')
	b.write_pos_field('', expr.pos)
	b.write_expr_field('', expr.expr)
	b.end_struct()
}

pub fn (mut b Inspector) postfix_expr(expr PostfixExpr) {
	b.begin_struct('PostfixExpr')
	b.write_pos_field('', expr.pos)
	b.write_any_field('op', expr.op)
	b.write_expr_field('', expr.expr)
	b.write_any_field('auto_locked', expr.auto_locked)
	b.end_struct()
}

pub fn (mut b Inspector) prefix_expr(expr PrefixExpr) {
	b.begin_struct('PrefixExpr')
	b.write_pos_field('', expr.pos)
	b.write_any_field('op', expr.op)
	b.write_expr_field('right', expr.right)
	b.write_type_field('right_type', expr.right_type)
	b.write_expr_field('or_block', expr.or_block)
	b.end_struct()
}

pub fn (mut b Inspector) range_expr(expr RangeExpr) {
	b.begin_struct('RangeExpr')
	b.write_pos_field('', expr.pos)
	b.write_any_field('has_low', expr.has_low)
	b.write_expr_field('low', expr.low)
	b.write_any_field('has_high', expr.has_high)
	b.write_expr_field('high', expr.high)
	b.end_struct()
}

pub fn (mut b Inspector) size_of(expr SizeOf) {
	b.begin_struct('SizeOf')
	b.write_pos_field('', expr.pos)
	b.write_any_field('is_type', expr.is_type)
	b.write_expr_field('', expr.expr)
	b.write_type_field('typ', expr.typ)
	b.end_struct()
}
