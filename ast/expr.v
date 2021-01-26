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
	CallExpr
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
	PostfixExpr
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
	match expr {
		ast.Ident { b.ident(expr) }
		ast.InfixExpr { b.infix_expr(expr) }
		ast.OrExpr { b.or_expr(expr) }
		ast.ParExpr { b.par_expr(expr) }
		else { b.writeln(expr) }
	}
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
	b.expr(expr.expr)
	b.end_struct()
}
