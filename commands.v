module main

import cli { Command, Flag }
import v.pref { Preferences }
import ast
import tokens

fn new_prefs() pref.Preferences {
	mut prefs := Preferences{}
	prefs.fill_with_defaults()
	prefs.is_fmt = true
	return prefs
}

const (
	commands = [
		Command{
			name: 'ast'
			description: 'print AST'
			flags: [
				Flag{
					flag: .string
					name: 'fn'
					abbrev: 'f'
					description: 'Show only specified function'
				},
			]
			execute: fn (cmd Command) ? {
				paths := cmd.args
				prefs := new_prefs()
				func := cmd.flags.get_string('fn') or { '' }
				opts := ast.InspectOpts{
					func: func
				}
				ast.inspect(paths, prefs, opts)
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
)
