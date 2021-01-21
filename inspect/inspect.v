module inspect

import cli { Command }
import v.pref { Preferences }
import inspect.ast
import inspect.tokens

fn new_prefs() pref.Preferences {
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
					prefs := new_prefs()
					ast.inspect_files(paths, prefs)
					return
				}
			},
			Command{
				name: 'tokens'
				description: 'print tokens'
				execute: fn (cmd Command) ? {
					paths := cmd.args
					prefs := new_prefs()
					tokens.inspect_tokens(paths, &prefs)
					return
				}
			},
		]
	}
)
