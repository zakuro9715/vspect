module main

import cli
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

fn inspect_command() cli.Command {
	return cli.Command{
		name: 'inspect'
		description: 'inspect code tools'
		commands: [
			cli.Command{
				name: 'ast'
				description: 'print AST'
				execute: fn (cmd cli.Command) ? {
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
			cli.Command{
				name: 'tokens'
				description: 'print tokens'
				execute: fn (cmd cli.Command) ? {
					println('Not implemented')
				}
			},
		]
	}
}
