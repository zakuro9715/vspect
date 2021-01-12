module inspect

import v.ast

fn print_ast_files(files []ast.File) {
	for f in files {
		print_ast_file(f)
	}
}

fn print_ast_file(file ast.File) {
	println(file)
}
