module ast

import v.ast

pub fn (mut b StringBuilder) write_stmts(stmts []ast.Stmt) {
	b.begin_array()
	for stmt in stmts {
		b.write_stmt(stmt)
		b.insert_array_comma()
	}
	b.end_array()
}

pub fn (mut b StringBuilder) write_stmt(stmt ast.Stmt) {
	match stmt {
		ast.FnDecl {
			b.fn_decl(stmt)
		}
		ast.Module {
			b.writeln(stmt)
		}
		else { b.writeln(stmt) }
	}
}
pub fn (mut b StringBuilder) fn_decl(v ast.FnDecl) {
	b.begin_struct('FnDecl')

	b.field('name', v.name)
	b.field('mod', v.mod)
	b.label('params')
	b.writeln(v.params)
	b.field('is_pub', v.is_pub)
	b.field('is_method', v.is_method)
	b.field('is_anon', v.is_anon)
	b.field('is_builtin', v.is_builtin)
	b.field('is_generic', v.is_generic)
	b.field('is_deprecated', v.is_deprecated)
	b.field('is_manualfree', v.is_manualfree)
	b.field('is_direct_arr', v.is_direct_arr)
	b.field('is_variadic', v.is_variadic)
	b.field('no_body', v.no_body)
	b.label('receiver')
	b.writeln(v.receiver)
	b.field('no_body', v.no_body)
	b.field('pos', v.pos)
	b.field('body_pos', v.body_pos)

	b.label('stmts')
	b.write_stmts(v.stmts)
	b.field('return_type', v.return_type)
	b.field('comments', v.comments)
	b.field('next_comments', v.next_comments)
	b.field('scope', *v.scope)
	b.end_struct()
}
