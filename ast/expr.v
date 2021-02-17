module ast

import v.ast as v

/*
o	AnonFn
o	ArrayDecompose
o	ArrayInit
o	AsCast
o	Assoc
o	AtExpr
o	BoolLiteral
o	CTempVar
o	CallExpr
o	CastExpr
o	ChanInit
o	CharLiteral
o	Comment
o	ComptimeCall
o	ComptimeSelector
o	ConcatExpr
	EnumVal
o	FloatLiteral
o	GoExpr
_	Ident
o	IfExpr
o	IfGuardExpr
o	IndexExpr
o	InfixExpr
o	IntegerLiteral
o	Likely
	LockExpr
o	MapInit
o	MatchExpr
o	None
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
o	TypeOf
o	UnsafeExpr
*/

pub fn (mut b Inspector) exprs(exprs ...v.Expr) {
	b.begin_array()
	for expr in exprs {
		b.expr(expr)
		b.array_comma()
	}
	b.end_array()
}

pub fn (mut b Inspector) expr(expr v.Expr) {
	if b.short_expr {
		b.writeln(expr)
		return
	}
	if expr.type_name().starts_with('unknown') {
		b.writeln('')
		return
	}
	match expr {
		v.AnonFn { b.anon_fn(expr) }
		v.ArrayInit { b.array_init(expr) }
		v.ArrayDecompose { b.array_decompose(expr) }
		v.AsCast { b.as_cast(expr) }
		v.Assoc { b.assoc(expr) }
		v.AtExpr { b.at_expr(expr) }
		v.BoolLiteral { b.bool_literal(expr) }
		v.CallExpr { b.call_expr(expr) }
		v.CastExpr { b.cast_expr(expr) }
		v.ChanInit { b.chan_init(expr) }
		v.CharLiteral { b.char_literal(expr) }
		v.Comment { b.comment(expr) }
		v.ComptimeCall { b.comptime_call(expr) }
		v.ComptimeSelector { b.comptime_selector(expr) }
		v.ConcatExpr { b.concat_expr(expr) }
		v.CTempVar { b.c_temp_var(expr) }
		v.FloatLiteral { b.float_literal(expr) }
		v.GoExpr { b.go_expr(expr) }
		v.Ident { b.ident(expr) }
		v.IfExpr { b.if_expr(expr) }
		v.IfGuardExpr { b.if_guard_expr(expr) }
		v.IndexExpr { b.index_expr(expr) }
		v.InfixExpr { b.infix_expr(expr) }
		v.IntegerLiteral { b.integer_literal(expr) }
		v.Likely { b.likely(expr) }
		v.MapInit { b.map_init(expr) }
		v.MatchExpr { b.match_expr(expr) }
		v.None { b.none_expr(expr) }
		v.OrExpr { b.or_expr(expr) }
		v.ParExpr { b.par_expr(expr) }
		v.PostfixExpr { b.postfix_expr(expr) }
		v.PrefixExpr { b.prefix_expr(expr) }
		v.RangeExpr { b.range_expr(expr) }
		v.SizeOf { b.size_of(expr) }
		v.TypeOf { b.type_of(expr) }
		v.UnsafeExpr { b.unsafe_expr(expr) }
		else { b.writeln(expr) }
	}
}

pub fn (mut b Inspector) anon_fn(expr v.AnonFn) {
	b.begin_struct('AnonFn')
	b.write_stmt_field('decl', expr.decl)
	b.write_type_field('', expr.typ)
	b.end_struct()
}

pub fn (mut b Inspector) array_init(expr v.ArrayInit) {
	b.begin_struct('ArrayInit')
	b.write_pos_field('', expr.pos)
	b.write_type_field('', expr.typ)
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

	b.write_ecmnts_field('', ...expr.ecmnts)
	b.end_struct()
}

pub fn (mut b Inspector) array_decompose(expr v.ArrayDecompose) {
	b.begin_struct('ArrayDecompose')
	b.write_pos_field('', expr.pos)
	b.write_expr_field('', expr.expr)
	b.write_type_field('expr_type', expr.expr_type)
	b.write_type_field('arg_type', expr.arg_type)
	b.end_struct()
}

pub fn (mut b Inspector) as_cast(expr v.AsCast) {
	b.begin_struct('AsCast')
	b.write_pos_field('', expr.pos)
	b.write_type_field('', expr.typ)
	b.write_expr_field('', expr.expr)
	b.write_type_field('expr_type', expr.expr_type)
	b.end_struct()
}

pub fn (mut b Inspector) assoc(expr v.Assoc) {
	b.begin_struct('Assoc')
	b.write_pos_field('', expr.pos)
	b.write_any_field('var_name', expr.var_name)
	b.write_any_field('fields', expr.fields)
	b.write_exprs_field('', ...expr.exprs)
	b.write_type_field('', expr.typ)
	b.write_scope_field('', expr.scope)
	b.end_struct()
}

pub fn (mut b Inspector) at_expr(expr v.AtExpr) {
	b.begin_struct('AtExpr')
	b.write_pos_field('', expr.pos)
	b.write_any_field('kind', expr.kind)
	b.write_any_field('name', expr.name)
	b.write_any_field('val', expr.val)
	b.end_struct()
}

pub fn (mut b Inspector) bool_literal(expr v.BoolLiteral) {
	b.begin_struct('BoolLiteral')
	b.write_pos_field('', expr.pos)
	b.write_any_field('val', expr.val)
	b.end_struct()
}

fn (mut b Inspector) call_arg(arg v.CallArg) {
	b.begin_struct('CallArg')

	b.write_pos_field('', arg.pos)
	b.write_any_field('is_mut', arg.is_mut)
	b.write_any_field('is_tmp_autofree', arg.is_tmp_autofree)
	b.write_any_field('share_type', arg.share)
	b.write_expr_field('', arg.expr)
	b.write_comments_field('', ...arg.comments)
	b.write_type_field('type', arg.typ)

	b.end_struct()
}

pub fn (mut b Inspector) call_expr(expr v.CallExpr) {
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
	b.write_scope_field('', expr.scope)
	b.write_comments_field('', ...expr.comments)

	b.end_struct()
}

pub fn (mut b Inspector) cast_expr(expr v.CastExpr) {
	b.begin_struct('CastExpr')
	b.write_pos_field('', expr.pos)
	b.write_type_field('', expr.typ)
	b.write_expr_field('', expr.expr)
	b.write_type_field('expr_type', expr.expr_type)
	b.write_expr_field('arg', expr.arg)
	b.write_any_field('typname', expr.typname)
	b.write_any_field('has_arg', expr.has_arg)
	b.write_any_field('in_prexpr', expr.in_prexpr)
	b.end_struct()
}

pub fn (mut b Inspector) chan_init(expr v.ChanInit) {
	b.begin_struct('ChanInit')
	b.write_pos_field('', expr.pos)
	b.write_any_field('has_cap', expr.has_cap)
	b.write_expr_field('cap_expr', expr.cap_expr)
	b.write_type_field('', expr.typ)
	b.write_type_field('elem_type', expr.elem_type)
	b.end_struct()
}

pub fn (mut b Inspector) char_literal(expr v.CharLiteral) {
	b.begin_struct('CharLiteral')
	b.write_pos_field('', expr.pos)
	b.write_any_field('val', expr.val)
	b.end_struct()
}

pub fn (mut b Inspector) comment(expr v.Comment) {
	b.begin_struct('Comment')
	b.write_pos_field('', expr.pos)
	b.write_any_field('line_nr', expr.line_nr)
	b.write_any_field('is_multi', expr.is_multi)
	b.write_any_field('text', expr.text)
	b.end_struct()
}

// TODO EmbededFile TypeSymbol
pub fn (mut b Inspector) comptime_call(expr v.ComptimeCall) {
	b.begin_struct('ComptimeCall')
	b.write_expr_field('left', expr.left)
	b.write_pos_field('method_pos', expr.method_pos)
	b.write_any_field('method_name', expr.method_name)
	b.write_any_field('has_parents', expr.has_parens)
	b.write_scope_field('scope', expr.scope)
	b.write_any_field('args_var', expr.args_var)

	b.write_any_field('is_vweb', expr.is_vweb)
	b.write_label('vweb_temp')
	b.file(expr.vweb_tmpl)

	b.write_any_field('is_embed', expr.is_embed)
	b.write_any_field('embed_file', expr.embed_file)

	b.write_any_field('is_env', expr.is_env)
	b.write_pos_field('env_pos', expr.env_pos)
	b.write_any_field('env_value', expr.env_value)

	// b.write_any_field('sym', expr.sym)
	b.write_type_field('result_type', expr.result_type)

	b.end_struct()
}

pub fn (mut b Inspector) comptime_selector(expr v.ComptimeSelector) {
	b.begin_struct('ComptimeSelector')
	b.write_type_field('', expr.typ)
	b.write_expr_field('left', expr.left)
	b.write_type_field('left_type', expr.left_type)
	b.write_expr_field('field_expr', expr.field_expr)
	b.write_any_field('has_parens', expr.has_parens)
	b.end_struct()
}

pub fn (mut b Inspector) concat_expr(expr v.ConcatExpr) {
	b.begin_struct('ConcatExpr')
	b.write_pos_field('', expr.pos)
	b.write_exprs_field('vals', ...expr.vals)
	b.write_type_field('return_type', expr.return_type)
	b.end_struct()
}

pub fn (mut b Inspector) c_temp_var(expr v.CTempVar) {
	b.begin_struct('CTempVar')
	b.write_any_field('name', expr.name)
	b.write_expr_field('orig', expr.orig)
	b.write_type_field('', expr.typ)
	b.write_any_field('is_ptr', expr.is_ptr)
	b.end_struct()
}

pub fn (mut b Inspector) float_literal(expr v.FloatLiteral) {
	b.begin_struct('FloatLiteral')
	b.write_pos_field('', expr.pos)
	b.write_any_field('val', expr.val)
	b.end_struct()
}

pub fn (mut b Inspector) go_expr(expr v.GoExpr) {
	b.begin_struct('GoExpr')
	b.write_pos_field('', expr.pos)
	b.write_stmt_field('go_stmt', expr.go_stmt)
	// b.write_type_field('return_type', expr.return_type)
	b.end_struct()
}

pub fn (mut b Inspector) ident(expr v.Ident) {
	if b.short_ident {
		b.writeln(expr.name)
	} else {
		b.writeln(expr)
	}
}

pub fn (mut b Inspector) if_guard_expr(expr v.IfGuardExpr) {
	b.begin_struct('IfGuardExpr')
	b.write_pos_field('', expr.pos)
	b.write_any_field('var_name', expr.var_name)
	b.write_expr_field('', expr.expr)
	b.write_type_field('expr_type', expr.expr_type)
	b.end_struct()
}

pub fn (mut b Inspector) if_branches(branches ...v.IfBranch) {
	b.begin_array()
	for v in branches {
		b.begin_struct('IfBranch')
		b.write_pos_field('', v.pos)
		b.write_pos_field('body_pos', v.body_pos)
		b.write_expr_field('cond', v.cond)
		b.write_comments_field('', ...v.comments)
		b.write_stmts_field('', ...v.stmts)
		b.write_any_field('smartcast', v.smartcast)
		b.write_scope_field('', v.scope)
		b.end_struct()
		b.array_comma()
	}
	b.end_array()
}

pub fn (mut b Inspector) if_expr(expr v.IfExpr) {
	b.begin_struct('IfExpr')
	b.write_pos_field('', expr.pos)
	b.write_any_field('tok_Kind', expr.tok_kind)
	b.write_any_field('is_comptime', expr.is_comptime)
	b.write_any_field('is_expr', expr.is_expr)
	b.write_any_field('has_else', expr.has_else)
	b.write_type_field('', expr.typ)
	b.write_expr_field('left', expr.left)
	b.write_exprs_field('post_comments', ...expr.post_comments)
	b.write_label('branches')
	b.if_branches(...expr.branches)
	b.end_struct()
}

pub fn (mut b Inspector) infix_expr(expr v.InfixExpr) {
	b.begin_struct('InfixExpr')

	b.write_any_field('op', expr.op)
	b.write_pos_field('', expr.pos)
	b.write_expr_field('left', expr.left)
	b.write_expr_field('right', expr.right)
	b.write_any_field('auto_locked', expr.auto_locked)
	b.write_expr_field('or_block', expr.or_block)

	b.end_struct()
}

pub fn (mut b Inspector) index_expr(expr v.IndexExpr) {
	b.begin_struct('IndexExpr')
	b.write_pos_field('', expr.pos)
	b.write_expr_field('left', expr.left)
	b.write_type_field('left_type', expr.left_type)
	b.write_expr_field('index', expr.index)
	b.write_expr_field('or_expr', expr.or_expr)
	b.write_any_field('is_setter', expr.is_setter)
	b.end_struct()
}

pub fn (mut b Inspector) integer_literal(expr v.IntegerLiteral) {
	b.begin_struct('IntegerLiteral')
	b.write_pos_field('', expr.pos)
	b.write_any_field('val', expr.val)
	b.end_struct()
}

pub fn (mut b Inspector) likely(expr v.Likely) {
	b.begin_struct('Likely')
	b.write_pos_field('', expr.pos)
	b.write_expr_field('', expr.expr)
	b.write_label('is_likely')
	b.write('$expr.is_likely ')
	if expr.is_likely {
		b.writeln('(_likely_)')
	} else {
		b.writeln('(_unlikely_)')
	}
	b.end_struct()
}

pub fn (mut b Inspector) map_init(expr v.MapInit) {
	b.begin_struct('MapInit')
	b.write_pos_field('', expr.pos)
	b.write_exprs_field('keys', ...expr.keys)
	b.write_exprs_field('vals', ...expr.vals)
	b.write_type_field('', expr.typ)
	b.write_type_field('key_type', expr.key_type)
	b.write_type_field('value_type', expr.value_type)
	b.end_struct()
}

pub fn (mut b Inspector) match_branches(branches ...v.MatchBranch) {
	b.begin_array()
	for v in branches {
		b.begin_struct('MatchBranch')
		b.write_pos_field('', v.pos)
		b.write_exprs_field('', ...v.exprs)
		b.write_ecmnts_field('', ...v.ecmnts)
		b.write_stmts_field('', ...v.stmts)
		b.write_any_field('is_else', v.is_else)
		b.write_comments_field('post_comments', ...v.post_comments)
		b.write_scope_field('', v.scope)
		b.end_struct()
		b.array_comma()
	}
	b.end_array()
}

pub fn (mut b Inspector) match_expr(expr v.MatchExpr) {
	b.begin_struct('MatchExpr')
	b.write_pos_field('', expr.pos)
	b.write_any_field('tok_Kind', expr.tok_kind)
	b.write_expr_field('cond', expr.cond)
	b.write_type_field('cond_type', expr.cond_type)
	b.write_type_field('return_type', expr.return_type)
	b.write_type_field('expected_type', expr.expected_type)
	b.write_any_field('is_expr', expr.is_expr)
	b.write_any_field('is_sum_type', expr.is_sum_type)
	b.write_comments_field('', ...expr.comments)
	b.write_label('branches')
	b.match_branches(...expr.branches)
	b.end_struct()
}

pub fn (mut b Inspector) none_expr(expr v.None) {
	b.begin_struct('None')
	b.write_pos_field('', expr.pos)
	b.write_any_field('foo', expr.foo)
	b.end_struct()
}

pub fn (mut b Inspector) or_expr(expr v.OrExpr) {
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

pub fn (mut b Inspector) par_expr(expr v.ParExpr) {
	b.begin_struct('ParExpr')
	b.write_pos_field('', expr.pos)
	b.write_expr_field('', expr.expr)
	b.end_struct()
}

pub fn (mut b Inspector) postfix_expr(expr v.PostfixExpr) {
	b.begin_struct('PostfixExpr')
	b.write_pos_field('', expr.pos)
	b.write_any_field('op', expr.op)
	b.write_expr_field('', expr.expr)
	b.write_any_field('auto_locked', expr.auto_locked)
	b.end_struct()
}

pub fn (mut b Inspector) prefix_expr(expr v.PrefixExpr) {
	b.begin_struct('PrefixExpr')
	b.write_pos_field('', expr.pos)
	b.write_any_field('op', expr.op)
	b.write_expr_field('right', expr.right)
	b.write_type_field('right_type', expr.right_type)
	b.write_expr_field('or_block', expr.or_block)
	b.end_struct()
}

pub fn (mut b Inspector) range_expr(expr v.RangeExpr) {
	b.begin_struct('RangeExpr')
	b.write_pos_field('', expr.pos)
	b.write_any_field('has_low', expr.has_low)
	b.write_expr_field('low', expr.low)
	b.write_any_field('has_high', expr.has_high)
	b.write_expr_field('high', expr.high)
	b.end_struct()
}

pub fn (mut b Inspector) size_of(expr v.SizeOf) {
	b.begin_struct('SizeOf')
	b.write_pos_field('', expr.pos)
	b.write_any_field('is_type', expr.is_type)
	b.write_expr_field('', expr.expr)
	b.write_type_field('', expr.typ)
	b.end_struct()
}

pub fn (mut b Inspector) type_of(expr v.TypeOf) {
	b.begin_struct('TypeOf')
	b.write_pos_field('', expr.pos)
	b.write_expr_field('', expr.expr)
	b.write_type_field('expr_type', expr.expr_type)
	b.end_struct()
}

pub fn (mut b Inspector) unsafe_expr(expr v.UnsafeExpr) {
	b.begin_struct('UnsafeExpr')
	b.write_pos_field('', expr.pos)
	b.write_expr_field('', expr.expr)
	b.end_struct()
}
