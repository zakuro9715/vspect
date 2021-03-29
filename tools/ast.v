module main
import os { join_path, dir }
import v.parser
import v.table
import v.ast
import v.pref { Preferences }


fn parse_files(targets []string) map[string]ast.File{
	table := table.new_table()
	global_scope := &ast.Scope{ parent: 0 }
	mut prefs := &Preferences{}
	prefs.fill_with_defaults()

	parsed_files := parser.parse_files(targets, table, prefs, global_scope)
	mut res := map[string]ast.File{}
	for f in parsed_files {
		res[f.path_base] = f
	}
	return res
}

fn main() {

	vdir := join_path(dir(@VEXE), 'vlib', 'v')
	files := parse_files([
		join_path(vdir, 'ast', 'ast.v'),
		join_path(vdir, 'table', 'table.v'),
	])

	println(files)
}
