module ast

import v.ast as v

// TODO
pub fn (mut b Inspector) scope(scope &v.Scope) {
	b.writeln(*scope)
}
