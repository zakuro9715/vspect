module astspect

import v.ast

// TODO
pub fn (mut b Inspector) scope(scope &ast.Scope) {
	b.writeln(*scope)
}
