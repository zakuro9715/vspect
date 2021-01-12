module inspect

import v.ast

// V 0.2.1 71d3d4c

fn print_ast_files(files []ast.File) {
	for f in files {
		print_ast_file(f)
	}
}

fn print_ast_file(file ast.File) {
	println(file)
}
