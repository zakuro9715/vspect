module ast

import v.ast {
	TypeDecl,
	SumTypeDecl,
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
		ast.SumTypeDecl { b.sum_type_decl(decl) }
		else { b.writeln(decl) }
	}
}

pub fn (mut b Inspector) sum_type_decl(decl SumTypeDecl) {
	b.begin_struct('SumTypeDecl')

	b.write_pos_field('', decl.pos)
	b.write_any_field('name', decl.name)
	b.write_any_field('is_pub', decl.is_pub)
	b.write_exprs_field('comments', ...decl.comments)

	b.write_label('variants')
	b.begin_array()
	for v in decl.variants {
		b.begin_struct('SumTypeVariant')
		b.write_pos_field('', v.pos)
		b.write_type_field('', v.typ)
		b.end_struct()
		b.array_comma()
	}
	b.end_array()

	b.end_struct()
}
