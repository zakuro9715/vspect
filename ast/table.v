module ast

import v.table

pub fn (mut b Inspector) typ(v table.Type) {
	b.writeln('${b.table.type_to_str(v)} -> table.Type($v)')
}

pub fn (mut b Inspector) params(params ...table.Param) {
	b.begin_array()
	for p in params {
		b.param(p)
		b.array_comma()
	}
	b.end_array()

}
pub fn (mut b Inspector) param(v table.Param) {
	b.begin_struct('Param')

	b.write_field('name', v.name)
	b.write_field('is_mut', v.is_mut)
	b.write_field('is_hidden', v.is_hidden)
	b.write_field('pos', v.pos)
	b.write_label('typ')
	b.typ(v.typ)
	b.write_field('type_pos', v.type_pos)

	b.end_struct()
}
