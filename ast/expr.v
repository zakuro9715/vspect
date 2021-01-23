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
o	Ident
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
	OrExpr
	ParExpr
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
	match expr {
		ast.Ident { b.ident(expr) }
		ast.InfixExpr { b.infix_expr(expr) }
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
