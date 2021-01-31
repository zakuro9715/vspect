module ast

import v.ast {
	TypeDecl
}

/*
	AliasTypeDecl
	FnTypeDecl
	SumTypeDecl
*/

pub fn (mut b Inspector) type_decls(decls ...TypeDecl) {
	b.begin_array()
	for decl in decls {
		b.type_decl(decl)
		b.array_comma()
	}
	b.end_array()
}

pub fn (mut b Inspector) type_decl(decl TypeDecl) {
	match decl {
		else { b.writeln(decl) }
	}
}

