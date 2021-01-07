module main

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

const (
	inspect_command = Command{
		name: 'inspect'
		description: 'inspect code tools'
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
					parsed_files := parser.parse_files(paths, table.new_table(), &prefs,
						&global_scope)
					println(parsed_files)
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
