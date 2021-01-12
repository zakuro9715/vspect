module inspect

import cli { Command }
import v.ast
import v.parser
import v.pref { Preferences }
import v.table

fn new_pref() pref.Preferences {
	mut prefs := Preferences{}
	prefs.fill_with_defaults()
	prefs.is_fmt = true
	return prefs
}

pub const (
	command = Command{
		name: 'inspect'
		description: 'inspect source code'
		commands: [
			Command{
				name: 'ast'
				description: 'print AST'
				execute: fn (cmd Command) ? {
					paths := cmd.args
					prefs := new_pref()
					global_scope := ast.Scope{
						start_pos: 0
						parent: 0
					}
					for path in paths {
						f := parser.parse_file(path, table.new_table(), .parse_comments,
							&prefs, &global_scope)
						print_ast_file(f)
					}
				}
			},
			Command{
				name: 'tokens'
				description: 'print tokens'
				execute: fn (cmd Command) ? {
					println('Not implemented')
				}
			},
		]
	}
)