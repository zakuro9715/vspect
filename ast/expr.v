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
	Ident
	IfExpr
	IfGuardExpr
	IndexExpr
	InfixExpr
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
		else { b.writeln(expr) }
	}
}
