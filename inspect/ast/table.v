module ast

import v.table

pub fn (mut b StringBuilder) typ(v table.Type) {
	b.writeln(b.table.type_to_str(v))
}
