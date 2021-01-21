module ast

import v.ast

pub fn (mut b StringBuilder) stmts(stmts ...ast.Stmt) {
	if stmts.len == 0 {
		b.writeln('[]')
		return
	}
	b.begin_array()
	for stmt in stmts {
		b.stmt(stmt)
		b.insert_array_comma()
	}
	b.end_array()
}

pub fn (mut b StringBuilder) stmt(stmt ast.Stmt) {
	match stmt {
		ast.FnDecl { b.fn_decl(stmt) }
		ast.Module { b.writeln(stmt) }
		else { b.writeln(stmt) }
	}
}

pub fn (mut b StringBuilder) fn_decl(v ast.FnDecl) {
	b.begin_struct('FnDecl')

	b.write_field('name', v.name)
	b.write_field('mod', v.mod)
	b.write_nodes_field('params', ...v.params)
	b.write_field('is_pub', v.is_pub)
	b.write_field('is_method', v.is_method)
	b.write_field('is_anon', v.is_anon)
	b.write_field('is_builtin', v.is_builtin)
	b.write_field('is_generic', v.is_generic)
	b.write_field('is_deprecated', v.is_deprecated)
	b.write_field('is_manualfree', v.is_manualfree)
	b.write_field('is_direct_arr', v.is_direct_arr)
	b.write_field('is_variadic', v.is_variadic)
	b.write_field('no_body', v.no_body)
	b.write_node_field('receiver', v.receiver)
	b.write_field('no_body', v.no_body)
	b.write_field('pos', v.pos)
	b.write_field('body_pos', v.body_pos)
	b.write_stmts_field('stmts', ...v.stmts)
	b.write_field('return_type', v.return_type)
	b.write_field('comments', v.comments)
	b.write_field('next_comments', v.next_comments)
	b.write_field('scope', *v.scope)

	b.end_struct()
}
